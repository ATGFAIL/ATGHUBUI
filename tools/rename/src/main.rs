//! atg-rename: rename local variables in a Lua/Luau file without changing
//! behaviour, and prove it.
//!
//! Commands
//!   dump   <file> [--lines A-B] [--uses]   list local bindings (for naming)
//!   apply  <file> <map>... [--dry-run]     rename bindings listed in maps
//!   verify <old> <new>                     check that two files differ only
//!                                           by consistent local renames
//!
//! A map file has one rename per line: `LINE:COLUMN OLD NEW`, where
//! LINE:COLUMN is the position of the declaring identifier as printed by
//! `dump`. `#` starts a comment.
//!
//! `apply` only writes the file when all checks pass:
//!   1. the result parses,
//!   2. the token stream (including comments and whitespace) is identical
//!      except for the renamed identifiers,
//!   3. every identifier reference resolves to the same binding (or the same
//!      global) as before, so no new name can capture or shadow another,
//!   4. every new name is a valid identifier and not a (contextual) keyword.

mod resolve;

use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs;
use std::process::ExitCode;

use full_moon::tokenizer::{Lexer, Token, TokenType};
use full_moon::LuaVersion;

use resolve::{resolve, BindingKind, Resolution};

const RESERVED: &[&str] = &[
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local",
    "nil", "not", "or", "repeat", "return", "then", "true", "until", "while", "continue", "type",
    "export", "typeof", "self",
];

fn parse(source: &str) -> Result<full_moon::ast::Ast, String> {
    full_moon::parse_fallible(source, LuaVersion::luau())
        .into_result()
        .map_err(|errors| {
            errors
                .iter()
                .take(5)
                .map(|error| error.to_string())
                .collect::<Vec<_>>()
                .join("\n")
        })
}

fn lex(source: &str) -> Result<Vec<Token>, String> {
    match Lexer::new(source, LuaVersion::luau()).collect() {
        full_moon::tokenizer::LexerResult::Ok(tokens) => Ok(tokens),
        other => Err(format!("tokenizer errors: {:?}", other.errors())),
    }
}

fn valid_identifier(name: &str) -> bool {
    let mut chars = name.chars();
    match chars.next() {
        Some(first) if first == '_' || first.is_ascii_alphabetic() => {}
        _ => return false,
    }
    chars.all(|character| character == '_' || character.is_ascii_alphanumeric())
        && !RESERVED.contains(&name)
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
enum Target {
    Binding(usize),
    Global(String),
}

/// Maps each reference (by token index) to what it resolves to (by token
/// index of the declaring identifier, or the global name).
fn binding_graph(
    source: &str,
    tokens: &[Token],
) -> Result<(BTreeMap<usize, Target>, BTreeMap<usize, BindingKind>), String> {
    let ast = parse(source)?;
    let resolution: Resolution = resolve(&ast)?;
    let mut index_of_byte = HashMap::new();
    for (index, token) in tokens.iter().enumerate() {
        index_of_byte.insert(token.start_position().bytes(), index);
    }
    let token_index = |byte: usize| -> Result<usize, String> {
        index_of_byte
            .get(&byte)
            .copied()
            .ok_or_else(|| format!("no token at byte {byte}"))
    };
    let mut bindings = BTreeMap::new();
    let mut binding_token = Vec::with_capacity(resolution.bindings.len());
    for binding in &resolution.bindings {
        let index = token_index(binding.byte)?;
        binding_token.push(index);
        // An implicit self shares the method-name token, keep kinds distinct.
        let key = if binding.kind == BindingKind::ImplicitSelf {
            index + 1_000_000_000
        } else {
            index
        };
        bindings.insert(key, binding.kind);
    }
    let mut graph = BTreeMap::new();
    for reference in &resolution.references {
        let index = token_index(reference.byte)?;
        let target = match reference.binding {
            Some(binding) => {
                let kind = resolution.bindings[binding].kind;
                let base = binding_token[binding];
                Target::Binding(if kind == BindingKind::ImplicitSelf {
                    base + 1_000_000_000
                } else {
                    base
                })
            }
            None => Target::Global(reference.name.clone()),
        };
        graph.insert(index, target);
    }
    Ok((graph, bindings))
}

fn token_text(token: &Token) -> String {
    token.to_string()
}

/// Checks 1-3 described in the module docs. `expected` maps byte offsets in
/// `old` of renamed identifiers to (old name, new name); when None, any
/// consistent identifier rename is accepted.
fn verify(old: &str, new: &str, expected: Option<&HashMap<usize, (String, String)>>) -> Result<String, String> {
    parse(new).map_err(|error| format!("result does not parse:\n{error}"))?;
    let old_tokens = lex(old)?;
    let new_tokens = lex(new)?;
    if old_tokens.len() != new_tokens.len() {
        return Err(format!(
            "token count changed: {} -> {}",
            old_tokens.len(),
            new_tokens.len()
        ));
    }
    let mut renamed = 0usize;
    let mut seen_expected = HashSet::new();
    for (index, (a, b)) in old_tokens.iter().zip(new_tokens.iter()).enumerate() {
        if a.token_type() == b.token_type() {
            continue;
        }
        match (a.token_type(), b.token_type()) {
            (TokenType::Identifier { .. }, TokenType::Identifier { .. }) => {
                let byte = a.start_position().bytes();
                if let Some(expected) = expected {
                    match expected.get(&byte) {
                        Some((old_name, new_name))
                            if *old_name == token_text(a) && *new_name == token_text(b) =>
                        {
                            seen_expected.insert(byte);
                        }
                        _ => {
                            return Err(format!(
                                "unexpected identifier change at token {index} (line {}): {} -> {}",
                                a.start_position().line(),
                                token_text(a),
                                token_text(b)
                            ))
                        }
                    }
                }
                renamed += 1;
            }
            _ => {
                return Err(format!(
                    "non-identifier token changed at token {index} (line {}): {:?} -> {:?}",
                    a.start_position().line(),
                    token_text(a),
                    token_text(b)
                ))
            }
        }
    }
    if let Some(expected) = expected {
        if seen_expected.len() != expected.len() {
            return Err(format!(
                "{} planned replacements were not found in the token stream",
                expected.len() - seen_expected.len()
            ));
        }
    }
    let (old_graph, old_bindings) = binding_graph(old, &old_tokens)?;
    let (new_graph, new_bindings) = binding_graph(new, &new_tokens)?;
    if old_bindings != new_bindings {
        return Err("the set of bindings changed".to_string());
    }
    if old_graph.len() != new_graph.len() {
        return Err("the number of resolved references changed".to_string());
    }
    for (index, target) in &old_graph {
        match new_graph.get(index) {
            Some(new_target) if new_target == target => {}
            other => {
                let token = &old_tokens[*index];
                return Err(format!(
                    "reference `{}` at line {} resolved to {:?} before and {:?} after",
                    token_text(token),
                    token.start_position().line(),
                    target,
                    other
                ));
            }
        }
    }
    Ok(format!(
        "verified: {} identifiers renamed, {} references resolve identically, {} bindings",
        renamed,
        old_graph.len(),
        old_bindings.len()
    ))
}

struct RenameEntry {
    line: usize,
    column: usize,
    old: String,
    new: String,
    origin: String,
}

fn read_maps(paths: &[String]) -> Result<Vec<RenameEntry>, String> {
    let mut entries = Vec::new();
    for path in paths {
        let text = fs::read_to_string(path).map_err(|error| format!("{path}: {error}"))?;
        for (number, raw) in text.lines().enumerate() {
            let line = raw.split('#').next().unwrap_or("").trim();
            if line.is_empty() {
                continue;
            }
            let parts: Vec<&str> = line.split_whitespace().collect();
            if parts.len() != 3 {
                return Err(format!("{path}:{}: expected `LINE:COL OLD NEW`", number + 1));
            }
            let (line_text, column_text) = parts[0]
                .split_once(':')
                .ok_or_else(|| format!("{path}:{}: bad position {}", number + 1, parts[0]))?;
            entries.push(RenameEntry {
                line: line_text
                    .parse()
                    .map_err(|_| format!("{path}:{}: bad line", number + 1))?,
                column: column_text
                    .parse()
                    .map_err(|_| format!("{path}:{}: bad column", number + 1))?,
                old: parts[1].to_string(),
                new: parts[2].to_string(),
                origin: format!("{path}:{}", number + 1),
            });
        }
    }
    Ok(entries)
}

fn apply(file: &str, maps: &[String], dry_run: bool) -> Result<String, String> {
    let source = fs::read_to_string(file).map_err(|error| format!("{file}: {error}"))?;
    let entries = read_maps(maps)?;
    let (output, report) = rename_source(&source, &entries)?;
    if !dry_run {
        fs::write(file, &output).map_err(|error| format!("{file}: {error}"))?;
    }
    Ok(format!("{report}{}", if dry_run { " (dry run, file not written)" } else { "" }))
}

fn rename_source(source: &str, entries: &[RenameEntry]) -> Result<(String, String), String> {
    let source = source.to_string();
    let ast = parse(&source)?;
    let resolution = resolve(&ast)?;
    let mut by_position = HashMap::new();
    for (index, binding) in resolution.bindings.iter().enumerate() {
        if binding.kind != BindingKind::ImplicitSelf {
            by_position.insert((binding.line, binding.column), index);
        }
    }
    let mut renames: HashMap<usize, String> = HashMap::new();
    for entry in entries {
        let index = *by_position
            .get(&(entry.line, entry.column))
            .ok_or_else(|| format!("{}: no local binding declared at {}:{}", entry.origin, entry.line, entry.column))?;
        let binding = &resolution.bindings[index];
        if binding.name != entry.old {
            return Err(format!(
                "{}: binding at {}:{} is `{}`, not `{}`",
                entry.origin, entry.line, entry.column, binding.name, entry.old
            ));
        }
        if !valid_identifier(&entry.new) {
            return Err(format!("{}: `{}` is not an allowed identifier", entry.origin, entry.new));
        }
        if renames.insert(index, entry.new.clone()).is_some() {
            return Err(format!("{}: binding renamed twice", entry.origin));
        }
    }

    // Collect byte ranges to replace.
    let mut replacements: Vec<(usize, usize, String)> = Vec::new();
    let mut expected: HashMap<usize, (String, String)> = HashMap::new();
    for (index, new_name) in &renames {
        let binding = &resolution.bindings[*index];
        replacements.push((binding.byte, binding.name.len(), new_name.clone()));
        expected.insert(binding.byte, (binding.name.clone(), new_name.clone()));
    }
    for reference in &resolution.references {
        if let Some(binding) = reference.binding {
            if let Some(new_name) = renames.get(&binding) {
                replacements.push((reference.byte, reference.name.len(), new_name.clone()));
                expected.insert(reference.byte, (reference.name.clone(), new_name.clone()));
            }
        }
    }
    replacements.sort_by(|a, b| b.0.cmp(&a.0));
    let mut output = source.clone();
    for (byte, length, new_name) in &replacements {
        let current = &output[*byte..*byte + *length];
        let original = &source[*byte..*byte + *length];
        if current != original {
            return Err(format!("overlapping replacement at byte {byte}"));
        }
        output.replace_range(*byte..*byte + *length, new_name);
    }
    let report = verify(&source, &output, Some(&expected))?;
    Ok((
        output,
        format!(
            "{} bindings renamed ({} occurrences).\n{}",
            renames.len(),
            replacements.len(),
            report
        ),
    ))
}

fn dump(file: &str, range: Option<(usize, usize)>, uses: bool) -> Result<String, String> {
    let source = fs::read_to_string(file).map_err(|error| format!("{file}: {error}"))?;
    let lines: Vec<&str> = source.lines().collect();
    let ast = parse(&source)?;
    let resolution = resolve(&ast)?;
    let mut references_of: HashMap<usize, Vec<usize>> = HashMap::new();
    for (index, reference) in resolution.references.iter().enumerate() {
        if let Some(binding) = reference.binding {
            references_of.entry(binding).or_default().push(index);
        }
    }
    let mut out = String::new();
    for (index, binding) in resolution.bindings.iter().enumerate() {
        if binding.kind == BindingKind::ImplicitSelf {
            continue;
        }
        if let Some((first, last)) = range {
            if binding.line < first || binding.line > last {
                continue;
            }
        }
        let references = references_of.get(&index).cloned().unwrap_or_default();
        let mut members: Vec<String> = Vec::new();
        for reference in &references {
            if let Some(member) = &resolution.references[*reference].member {
                if !members.contains(member) {
                    members.push(member.clone());
                }
            }
        }
        members.truncate(12);
        out.push_str(&format!(
            "{}:{}\t{}\t{}\trefs={}\tmembers=[{}]\tinit={}\n",
            binding.line,
            binding.column,
            binding.name,
            binding.kind.label(),
            references.len(),
            members.join(","),
            binding.init.clone().unwrap_or_default()
        ));
        if uses {
            for reference in references.iter().take(3) {
                let line = resolution.references[*reference].line;
                let text = lines.get(line - 1).map(|text| text.trim()).unwrap_or("");
                let text: String = text.chars().take(120).collect();
                out.push_str(&format!("\t\tuse {line}: {text}\n"));
            }
        }
    }
    Ok(out)
}

fn run(args: Vec<String>) -> Result<String, String> {
    let command = args.get(1).map(String::as_str).unwrap_or("");
    match command {
        "dump" => {
            let file = args.get(2).ok_or("dump needs a file")?;
            let mut range = None;
            let mut uses = false;
            let mut index = 3;
            while index < args.len() {
                match args[index].as_str() {
                    "--lines" => {
                        let spec = args.get(index + 1).ok_or("--lines needs A-B")?;
                        let (a, b) = spec.split_once('-').ok_or("--lines needs A-B")?;
                        range = Some((
                            a.parse().map_err(|_| "bad --lines")?,
                            b.parse().map_err(|_| "bad --lines")?,
                        ));
                        index += 2;
                    }
                    "--uses" => {
                        uses = true;
                        index += 1;
                    }
                    other => return Err(format!("unknown option {other}")),
                }
            }
            dump(file, range, uses)
        }
        "apply" => {
            let file = args.get(2).ok_or("apply needs a file")?;
            let dry_run = args.iter().any(|arg| arg == "--dry-run");
            let maps: Vec<String> = args[3..]
                .iter()
                .filter(|arg| arg.as_str() != "--dry-run")
                .cloned()
                .collect();
            if maps.is_empty() {
                return Err("apply needs at least one map file".to_string());
            }
            apply(file, &maps, dry_run)
        }
        "verify" => {
            let old = fs::read_to_string(args.get(2).ok_or("verify needs OLD NEW")?)
                .map_err(|error| error.to_string())?;
            let new = fs::read_to_string(args.get(3).ok_or("verify needs OLD NEW")?)
                .map_err(|error| error.to_string())?;
            verify(&old, &new, None)
        }
        _ => Err("usage: atg-rename dump|apply|verify ...".to_string()),
    }
}

fn main() -> ExitCode {
    match run(std::env::args().collect()) {
        Ok(output) => {
            print!("{output}");
            if !output.ends_with('\n') {
                println!();
            }
            ExitCode::SUCCESS
        }
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn entry(line: usize, column: usize, old: &str, new: &str) -> RenameEntry {
        RenameEntry {
            line,
            column,
            old: old.to_string(),
            new: new.to_string(),
            origin: "test".to_string(),
        }
    }

    fn rename(source: &str, entries: &[RenameEntry]) -> Result<String, String> {
        rename_source(source, entries).map(|(output, _)| output)
    }

    #[test]
    fn renames_a_local_and_its_references() {
        let source = "local a = 1\nprint(a, a + 1)\n";
        let output = rename(source, &[entry(1, 7, "a", "count")]).unwrap();
        assert_eq!(output, "local count = 1\nprint(count, count + 1)\n");
    }

    #[test]
    fn refuses_a_name_that_captures_an_outer_reference() {
        let source = "local a = 1\nlocal function f()\n\tlocal b = 2\n\treturn a + b\nend\n";
        let error = rename(source, &[entry(3, 8, "b", "a")]).unwrap_err();
        assert!(error.contains("resolved to"), "{error}");
    }

    #[test]
    fn refuses_a_name_that_shadows_a_used_global() {
        let source = "local a = 1\nprint(a)\n";
        let error = rename(source, &[entry(1, 7, "a", "print")]).unwrap_err();
        assert!(error.contains("resolved to"), "{error}");
    }

    #[test]
    fn right_hand_side_sees_the_outer_binding() {
        let source = "local x = 1\ndo\n\tlocal x = x + 1\n\tprint(x)\nend\nprint(x)\n";
        let output = rename(source, &[entry(3, 8, "x", "inner")]).unwrap();
        assert_eq!(output, "local x = 1\ndo\n\tlocal inner = x + 1\n\tprint(inner)\nend\nprint(x)\n");
    }

    #[test]
    fn repeat_until_sees_body_locals() {
        let source = "repeat\n\tlocal done = true\nuntil done\n";
        let output = rename(source, &[entry(2, 8, "done", "finished")]).unwrap();
        assert_eq!(output, "repeat\n\tlocal finished = true\nuntil finished\n");
    }

    #[test]
    fn loop_variables_parameters_and_local_functions() {
        let source = "local function f(a, ...)\n\tfor i = 1, a do print(i) end\n\tfor k, v in pairs({}) do print(k, v) end\n\treturn f\nend\n";
        let output = rename(
            source,
            &[
                entry(1, 16, "f", "walk"),
                entry(1, 18, "a", "limit"),
                entry(2, 6, "i", "index"),
                entry(3, 6, "k", "key"),
                entry(3, 9, "v", "value"),
            ],
        )
        .unwrap();
        assert_eq!(
            output,
            "local function walk(limit, ...)\n\tfor index = 1, limit do print(index) end\n\tfor key, value in pairs({}) do print(key, value) end\n\treturn walk\nend\n"
        );
    }

    #[test]
    fn fields_and_method_names_are_not_renamed() {
        let source = "local t = {a = 1}\nlocal a = t.a\nt:a()\nprint(a)\n";
        let output = rename(source, &[entry(2, 7, "a", "value")]).unwrap();
        assert_eq!(output, "local t = {a = 1}\nlocal value = t.a\nt:a()\nprint(value)\n");
    }

    #[test]
    fn method_self_is_kept() {
        let source = "local obj = {}\nfunction obj:get(x)\n\treturn self, x\nend\n";
        let output = rename(source, &[entry(2, 18, "x", "key")]).unwrap();
        assert_eq!(output, "local obj = {}\nfunction obj:get(key)\n\treturn self, key\nend\n");
    }

    #[test]
    fn refuses_keywords_and_wrong_old_names() {
        let source = "local a = 1\n";
        assert!(rename(source, &[entry(1, 7, "a", "end")]).is_err());
        assert!(rename(source, &[entry(1, 7, "b", "c")]).is_err());
        assert!(rename(source, &[entry(1, 7, "a", "self")]).is_err());
    }

    #[test]
    fn comments_and_strings_are_untouched() {
        let source = "local a = \"a\" -- a\nprint(a)\n";
        let output = rename(source, &[entry(1, 7, "a", "b")]).unwrap();
        assert_eq!(output, "local b = \"a\" -- a\nprint(b)\n");
    }

    #[test]
    fn verify_rejects_a_changed_literal() {
        assert!(verify("local a = 1\n", "local a = 2\n", None).is_err());
        assert!(verify("local a = 1\nprint(a)\n", "local b = 1\nprint(b)\n", None).is_ok());
        assert!(verify("local a = 1\nprint(a)\n", "local b = 1\nprint(a)\n", None).is_err());
    }
}

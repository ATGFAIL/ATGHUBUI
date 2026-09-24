//! Scope resolution for Lua/Luau source.
//!
//! Walks a full_moon AST and records every local binding (local variables,
//! local functions, parameters, loop variables and the implicit `self` of
//! methods) together with every identifier reference and the binding it
//! resolves to (or `None` for a global).
//!
//! The walker is deliberately strict: any statement or expression kind it
//! does not understand is an error, so an unsupported construct can never be
//! silently mis-resolved.

use std::collections::HashMap;

use full_moon::ast::{
    self, Block, Call, Expression, Field, FunctionArgs, FunctionBody, Index, LastStmt, Parameter,
    Prefix, Stmt, Suffix, Var,
};
use full_moon::node::Node;
use full_moon::tokenizer::TokenReference;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum BindingKind {
    Local,
    LocalFunction,
    Parameter,
    ForVariable,
    ImplicitSelf,
}

impl BindingKind {
    pub fn label(self) -> &'static str {
        match self {
            BindingKind::Local => "local",
            BindingKind::LocalFunction => "local-function",
            BindingKind::Parameter => "param",
            BindingKind::ForVariable => "for",
            BindingKind::ImplicitSelf => "self",
        }
    }
}

#[derive(Clone, Debug)]
pub struct Binding {
    pub name: String,
    pub kind: BindingKind,
    /// Byte offset of the declaring identifier. For an implicit `self` this is
    /// the byte offset of the method name, which is not itself renamed.
    pub byte: usize,
    pub line: usize,
    pub column: usize,
    /// Source text of the initialising expression (locals) or of the
    /// function signature (parameters), for naming help.
    pub init: Option<String>,
    /// Byte offset of the start of the enclosing function (0 for the chunk).
    pub function_byte: usize,
}

#[derive(Clone, Debug)]
pub struct Reference {
    pub name: String,
    pub byte: usize,
    pub line: usize,
    pub column: usize,
    /// Index into `Resolution::bindings`, or None when the name is global.
    pub binding: Option<usize>,
    /// Member accessed right after this reference (`x.Foo` / `x:Foo()`).
    pub member: Option<String>,
}

#[derive(Default, Debug)]
pub struct Resolution {
    pub bindings: Vec<Binding>,
    pub references: Vec<Reference>,
}

pub type ResolveResult<T> = Result<T, String>;

fn token_name(token: &TokenReference) -> String {
    token.token().to_string()
}

fn token_byte(token: &TokenReference) -> usize {
    token.token().start_position().bytes()
}

fn token_line_column(token: &TokenReference) -> (usize, usize) {
    let position = token.token().start_position();
    (position.line(), position.character())
}

fn node_text<N: Node + std::fmt::Display>(node: &N) -> String {
    let text = node.to_string();
    let collapsed: String = text.split_whitespace().collect::<Vec<_>>().join(" ");
    if collapsed.chars().count() > 140 {
        let truncated: String = collapsed.chars().take(140).collect();
        format!("{truncated}…")
    } else {
        collapsed
    }
}

pub struct Resolver {
    scopes: Vec<HashMap<String, usize>>,
    function_stack: Vec<usize>,
    pub resolution: Resolution,
}

impl Resolver {
    pub fn new() -> Self {
        Resolver {
            scopes: vec![HashMap::new()],
            function_stack: vec![0],
            resolution: Resolution::default(),
        }
    }

    fn declare(&mut self, token: &TokenReference, kind: BindingKind, init: Option<String>) {
        let name = token_name(token);
        let (line, column) = token_line_column(token);
        let index = self.resolution.bindings.len();
        self.resolution.bindings.push(Binding {
            name: name.clone(),
            kind,
            byte: token_byte(token),
            line,
            column,
            init,
            function_byte: *self.function_stack.last().unwrap(),
        });
        self.scopes.last_mut().unwrap().insert(name, index);
    }

    fn declare_implicit_self(&mut self, anchor: &TokenReference) {
        let (line, column) = token_line_column(anchor);
        let index = self.resolution.bindings.len();
        self.resolution.bindings.push(Binding {
            name: "self".to_string(),
            kind: BindingKind::ImplicitSelf,
            byte: token_byte(anchor),
            line,
            column,
            init: None,
            function_byte: *self.function_stack.last().unwrap(),
        });
        self.scopes.last_mut().unwrap().insert("self".to_string(), index);
    }

    fn lookup(&self, name: &str) -> Option<usize> {
        for scope in self.scopes.iter().rev() {
            if let Some(index) = scope.get(name) {
                return Some(*index);
            }
        }
        None
    }

    fn reference(&mut self, token: &TokenReference, member: Option<String>) {
        let name = token_name(token);
        let (line, column) = token_line_column(token);
        let binding = self.lookup(&name);
        self.resolution.references.push(Reference {
            name,
            byte: token_byte(token),
            line,
            column,
            binding,
            member,
        });
    }

    fn push_scope(&mut self) {
        self.scopes.push(HashMap::new());
    }

    fn pop_scope(&mut self) {
        self.scopes.pop();
    }

    pub fn chunk(&mut self, ast: &ast::Ast) -> ResolveResult<()> {
        self.block_statements(ast.nodes())
    }

    fn block(&mut self, block: &Block) -> ResolveResult<()> {
        self.push_scope();
        let result = self.block_statements(block);
        self.pop_scope();
        result
    }

    fn block_statements(&mut self, block: &Block) -> ResolveResult<()> {
        for stmt in block.stmts() {
            self.stmt(stmt)?;
        }
        if let Some(last) = block.last_stmt() {
            match last {
                LastStmt::Return(ret) => {
                    for expression in ret.returns().iter() {
                        self.expression(expression)?;
                    }
                }
                LastStmt::Break(_) => {}
                LastStmt::Continue(_) => {}
                other => return Err(format!("unsupported last statement: {}", node_text(other))),
            }
        }
        Ok(())
    }

    fn stmt(&mut self, stmt: &Stmt) -> ResolveResult<()> {
        match stmt {
            Stmt::Assignment(assignment) => {
                for expression in assignment.expressions().iter() {
                    self.expression(expression)?;
                }
                for var in assignment.variables().iter() {
                    self.var(var)?;
                }
            }
            Stmt::Do(do_block) => self.block(do_block.block())?,
            Stmt::FunctionCall(call) => self.function_call(call)?,
            Stmt::FunctionDeclaration(declaration) => {
                let name = declaration.name();
                let mut names = name.names().iter();
                let first = names
                    .next()
                    .ok_or_else(|| "function declaration without a name".to_string())?;
                let member = name
                    .names()
                    .iter()
                    .nth(1)
                    .map(token_name)
                    .or_else(|| name.method_name().map(token_name));
                self.reference(first, member);
                let method = name.method_name();
                self.function_body(declaration.body(), method, declaration.function_token())?;
            }
            Stmt::GenericFor(generic_for) => {
                for expression in generic_for.expressions().iter() {
                    self.expression(expression)?;
                }
                self.push_scope();
                let init = Some(format!("for-in {}", node_text(generic_for.expressions())));
                for name in generic_for.names().iter() {
                    self.declare(name, BindingKind::ForVariable, init.clone());
                }
                let result = self.block(generic_for.block());
                self.pop_scope();
                result?;
            }
            Stmt::If(if_stmt) => {
                self.expression(if_stmt.condition())?;
                self.block(if_stmt.block())?;
                if let Some(else_ifs) = if_stmt.else_if() {
                    for else_if in else_ifs {
                        self.expression(else_if.condition())?;
                        self.block(else_if.block())?;
                    }
                }
                if let Some(else_block) = if_stmt.else_block() {
                    self.block(else_block)?;
                }
            }
            Stmt::LocalAssignment(local) => {
                let expressions: Vec<&Expression> = local.expressions().iter().collect();
                for expression in &expressions {
                    self.expression(expression)?;
                }
                let names: Vec<&TokenReference> = local.names().iter().collect();
                let count = names.len();
                for (index, name) in names.into_iter().enumerate() {
                    let init = if let Some(expression) = expressions.get(index) {
                        Some(node_text(*expression))
                    } else if let Some(last) = expressions.last() {
                        Some(format!("(value {} of) {}", index + 1, node_text(*last)))
                    } else {
                        None
                    };
                    let init = if count > 1 && expressions.len() == 1 {
                        Some(format!("(value {} of) {}", index + 1, node_text(expressions[0])))
                    } else {
                        init
                    };
                    self.declare(name, BindingKind::Local, init);
                }
            }
            Stmt::LocalFunction(local_function) => {
                let signature = format!("function({})", node_text(local_function.body().parameters()));
                self.declare(local_function.name(), BindingKind::LocalFunction, Some(signature));
                self.function_body(local_function.body(), None, local_function.function_token())?;
            }
            Stmt::NumericFor(numeric_for) => {
                self.expression(numeric_for.start())?;
                self.expression(numeric_for.end())?;
                if let Some(step) = numeric_for.step() {
                    self.expression(step)?;
                }
                self.push_scope();
                self.declare(
                    numeric_for.index_variable(),
                    BindingKind::ForVariable,
                    Some("numeric for".to_string()),
                );
                let result = self.block(numeric_for.block());
                self.pop_scope();
                result?;
            }
            Stmt::Repeat(repeat) => {
                // The `until` condition can see locals declared in the body.
                self.push_scope();
                let result = self
                    .block_statements(repeat.block())
                    .and_then(|_| self.expression(repeat.until()));
                self.pop_scope();
                result?;
            }
            Stmt::While(while_stmt) => {
                self.expression(while_stmt.condition())?;
                self.block(while_stmt.block())?;
            }
            Stmt::CompoundAssignment(compound) => {
                self.expression(compound.rhs())?;
                self.var(compound.lhs())?;
            }
            other => return Err(format!("unsupported statement: {}", node_text(other))),
        }
        Ok(())
    }

    fn function_body(
        &mut self,
        body: &FunctionBody,
        method_name: Option<&TokenReference>,
        function_token: &TokenReference,
    ) -> ResolveResult<()> {
        self.function_stack.push(token_byte(function_token));
        self.push_scope();
        if let Some(method) = method_name {
            self.declare_implicit_self(method);
        }
        let parameters_text = node_text(body.parameters());
        for parameter in body.parameters().iter() {
            match parameter {
                Parameter::Name(name) => self.declare(
                    name,
                    BindingKind::Parameter,
                    Some(format!("param of function({parameters_text})")),
                ),
                Parameter::Ellipsis(_) => {}
                other => {
                    self.pop_scope();
                    self.function_stack.pop();
                    return Err(format!("unsupported parameter: {}", node_text(other)));
                }
            }
        }
        let result = self.block(body.block());
        self.pop_scope();
        self.function_stack.pop();
        result
    }

    fn function_call(&mut self, call: &ast::FunctionCall) -> ResolveResult<()> {
        let suffixes: Vec<&Suffix> = call.suffixes().collect();
        let member = first_member(&suffixes);
        self.prefix(call.prefix(), member)?;
        for suffix in suffixes {
            self.suffix(suffix)?;
        }
        Ok(())
    }

    fn prefix(&mut self, prefix: &Prefix, member: Option<String>) -> ResolveResult<()> {
        match prefix {
            Prefix::Name(name) => {
                self.reference(name, member);
                Ok(())
            }
            Prefix::Expression(expression) => self.expression(expression),
            other => Err(format!("unsupported prefix: {}", node_text(other))),
        }
    }

    fn suffix(&mut self, suffix: &Suffix) -> ResolveResult<()> {
        match suffix {
            Suffix::Call(Call::AnonymousCall(args)) => self.function_args(args),
            Suffix::Call(Call::MethodCall(method)) => self.function_args(method.args()),
            Suffix::Index(Index::Brackets { expression, .. }) => self.expression(expression),
            Suffix::Index(Index::Dot { .. }) => Ok(()),
            Suffix::TypeInstantiation(_) => Ok(()),
            other => Err(format!("unsupported suffix: {}", node_text(other))),
        }
    }

    fn function_args(&mut self, args: &FunctionArgs) -> ResolveResult<()> {
        match args {
            FunctionArgs::Parentheses { arguments, .. } => {
                for argument in arguments.iter() {
                    self.expression(argument)?;
                }
                Ok(())
            }
            FunctionArgs::String(_) => Ok(()),
            FunctionArgs::TableConstructor(table) => self.table(table),
            other => Err(format!("unsupported function arguments: {}", node_text(other))),
        }
    }

    fn table(&mut self, table: &ast::TableConstructor) -> ResolveResult<()> {
        for field in table.fields().iter() {
            match field {
                Field::ExpressionKey { key, value, .. } => {
                    self.expression(key)?;
                    self.expression(value)?;
                }
                Field::NameKey { value, .. } => self.expression(value)?,
                Field::NoKey(value) => self.expression(value)?,
                other => return Err(format!("unsupported table field: {}", node_text(other))),
            }
        }
        Ok(())
    }

    fn var(&mut self, var: &Var) -> ResolveResult<()> {
        match var {
            Var::Name(name) => {
                self.reference(name, None);
                Ok(())
            }
            Var::Expression(var_expression) => {
                let suffixes: Vec<&Suffix> = var_expression.suffixes().collect();
                let member = first_member(&suffixes);
                self.prefix(var_expression.prefix(), member)?;
                for suffix in suffixes {
                    self.suffix(suffix)?;
                }
                Ok(())
            }
            other => Err(format!("unsupported var: {}", node_text(other))),
        }
    }

    fn expression(&mut self, expression: &Expression) -> ResolveResult<()> {
        match expression {
            Expression::BinaryOperator { lhs, rhs, .. } => {
                self.expression(lhs)?;
                self.expression(rhs)
            }
            Expression::Parentheses { expression, .. } => self.expression(expression),
            Expression::UnaryOperator { expression, .. } => self.expression(expression),
            Expression::Function(function) => {
                self.function_body(function.body(), None, function.function_token())
            }
            Expression::FunctionCall(call) => self.function_call(call),
            Expression::IfExpression(if_expression) => {
                self.expression(if_expression.condition())?;
                self.expression(if_expression.if_expression())?;
                if let Some(else_ifs) = if_expression.else_if_expressions() {
                    for else_if in else_ifs {
                        self.expression(else_if.condition())?;
                        self.expression(else_if.expression())?;
                    }
                }
                self.expression(if_expression.else_expression())
            }
            Expression::InterpolatedString(interpolated) => {
                for part in interpolated.expressions() {
                    self.expression(part)?;
                }
                Ok(())
            }
            Expression::TableConstructor(table) => self.table(table),
            Expression::Number(_) | Expression::String(_) | Expression::Symbol(_) => Ok(()),
            Expression::TypeAssertion { expression, .. } => self.expression(expression),
            Expression::Var(var) => self.var(var),
            other => Err(format!("unsupported expression: {}", node_text(other))),
        }
    }
}

fn first_member(suffixes: &[&Suffix]) -> Option<String> {
    match suffixes.first() {
        Some(Suffix::Index(Index::Dot { name, .. })) => Some(token_name(name)),
        Some(Suffix::Call(Call::MethodCall(method))) => Some(format!(":{}", token_name(method.name()))),
        Some(Suffix::Call(Call::AnonymousCall(_))) => Some("()".to_string()),
        Some(Suffix::Index(Index::Brackets { .. })) => Some("[]".to_string()),
        _ => None,
    }
}

pub fn resolve(ast: &ast::Ast) -> ResolveResult<Resolution> {
    let mut resolver = Resolver::new();
    resolver.chunk(ast)?;
    Ok(resolver.resolution)
}

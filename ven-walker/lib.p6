func getAttrList() {
  return [
    # simple recursion
    [Q.Term.Object, ["propertylist"]],
    [Q.Term.Dict, ["propertylist"]],
    [Q.Property, ["value"]],
    [Q.Trait, ["identifier", "expr"]],
    [Q.Term.Func, ["identifier", "traitlist", "block"]],
    [Q.Block, ["parameterlist", "statementlist"]],
    [Q.Prefix, ["identifier", "operand"]],
    [Q.Infix, ["identifier", "lhs", "rhs"]],
    [Q.Postfix, ["identifier", "operand"]],
    [Q.Postfix.Index, ["index"]],
    [Q.Postfix.Call, ["argumentlist"]],
    [Q.Postfix.Property, ["property"]],
    [Q.Unquote, ["qtype", "expr"]],
    [Q.Unquote.Prefix, ["operand"]],
    [Q.Unquote.Infix, ["lhs", "rhs"]],
    [Q.Term.My, ["identifier"]],
    [Q.Term.Quasi, ["qtype", "contents"]],
    [Q.Parameter, ["identifier"]],
    [Q.Statement.Expr, ["expr"]],
    [Q.Statement.If, ["expr", "block", "else"]],
    [Q.Statement.Block, ["block"]],
    [Q.Statement.For, ["expr", "block"]],
    [Q.Statement.While, ["expr", "block"]],
    [Q.Statement.Return, ["expr"]],
    [Q.Statement.Throw, ["expr"]],
    [Q.Statement.Func, ["identifier", "traitlist"]],
    [Q.Statement.Macro, ["identifier", "traitlist", "block"]],
    [Q.Statement.BEGIN, ["block"]],
    [Q.Statement.Class, ["block"]],
    [Q.Expr.BlockAdapter, ["block"]],

    # array recursion
    [Q.TraitList, ["traits"]],
    [Q.Term.Array, ["elements"]],
    [Q.PropertyList, ["properties"]],
    [Q.ArgumentList, ["arguments"]],
    [Q.ParameterList, ["parameters"]],
    [Q.StatementList, ["statements"]],
  ];
}

func getInheritList() {
  return [
    # XXX Q::CompUnit?
    [Q,                   []],
    [Q.Expr,              [Q]],
    [Q.Block,             [Q]],
    [Q.StatementList,     [Q]],
    [Q.Statement,         [Q]],
    [Q.Identifier,        [Q]],
    [Q.Declaration,       []], # anything that does Q.Declaration does some other role, so Q is always in the inheritance tree
    [Q.Expr.BlockAdapter, [Q.Expr]],

    [Q.PropertyList,      [Q]],
    [Q.Property,          [Q]],
    [Q.TraitList,         [Q]],
    [Q.Trait,             [Q]],
    [Q.ArgumentList,      [Q]],
    [Q.ParameterList,     [Q]],
    [Q.Parameter,         [Q.Declaration, Q]],

    [Q.Term,              [Q.Expr]],
    [Q.Term.Func,         [Q.Term, Q.Declaration]],
    [Q.Term.Quasi,        [Q.Term]],
    [Q.Term.My,           [Q.Term]],
    [Q.Term.Dict,         [Q.Term]],
    [Q.Term.Object,       [Q.Term]],
    [Q.Term.Array,        [Q.Term]],
    [Q.Term.Regex,        [Q.Term]],
    [Q.Term.Identifier,   [Q.Identifier, Q.Term]],

    [Q.Literal,           [Q.Term]],
    [Q.Literal.Str,       [Q.Literal]],
    [Q.Literal.Int,       [Q.Literal]],
    [Q.Literal.Bool,      [Q.Literal]],
    [Q.Literal.None,      [Q.Literal]],

    [Q.Regex.Fragment,    []],
    [Q.Regex.ZeroOrOne,   [Q.Regex.Fragment]],
    [Q.Regex.ZeroOrMore,  [Q.Regex.Fragment]],
    [Q.Regex.OneOrMore,   [Q.Regex.Fragment]],
    [Q.Regex.Group,       [Q.Regex.Fragment]],
    [Q.Regex.Alternation, [Q.Regex.Fragment]],
    [Q.Regex.Call,        [Q.Regex.Fragment]],
    [Q.Regex.Identifier,  [Q.Regex.Fragment]],
    [Q.Regex.Str,         [Q.Regex.Fragment]],

    [Q.Unquote,           [Q]],
    [Q.Unquote.Prefix,    [Q.Unquote]],
    [Q.Unquote.Infix,     [Q.Unquote]],

    [Q.Prefix,            [Q.Expr]],

    [Q.Infix,             [Q.Expr]],
    [Q.Infix.And,         [Q.Infix]],
    [Q.Infix.Or,          [Q.Infix]],
    [Q.Infix.DefinedOr,   [Q.Infix]],
    [Q.Infix.Assignment,  [Q.Infix]],
    [Q.Infix.Assignment,  [Q.Infix]],

    [Q.Postfix,           [Q.Expr]],
    [Q.Postfix.Property,  [Q.Postfix]],
    [Q.Postfix.Call,      [Q.Postfix]],
    [Q.Postfix.Index,     [Q.Postfix]],

    [Q.Statement.BEGIN,   [Q.Statement]],
    [Q.Statement.Last,    [Q.Statement]],
    [Q.Statement.Next,    [Q.Statement]],
    [Q.Statement.Throw,   [Q.Statement]],
    [Q.Statement.Return,  [Q.Statement]],
    [Q.Statement.While,   [Q.Statement]],
    [Q.Statement.For,     [Q.Statement]],
    [Q.Statement.If,      [Q.Statement]],
    [Q.Statement.Block,   [Q.Statement]],
    [Q.Statement.Expr,    [Q.Statement]],

    # Q.Declaration before Q.Statement because it's more restrictive
    [Q.Statement.Class,   [Q.Declaration, Q.Statement]],
    [Q.Statement.Macro,   [Q.Declaration, Q.Statement]],
    [Q.Statement.Func,    [Q.Declaration, Q.Statement]],
  ];
}
# Index operation an array of pairs. Does not differentiate between no such value and a nil value.
func atType(xs, t) {
  for xs -> x {
    if x[0] == t {
      return x[1];
    }
  }
}
func walkAtType(walkers, rootType) {
  if atType(getInheritList(), rootType) -> parentTypes {
    # breadth-first
    for parentTypes -> parentType {
      if atType(walkers, parentType) -> res {
        return res; # we found a match for the parent
      }
    }

    # loop again!
    # this time: recurse for depth, find parent's parents
    for parentTypes -> parentType {
      if walkAtType(walkers, parentType) -> res {
        return res; # we found a match for the parent's parent (or we self-recursed again)
      }
    }
  }
}
# XXX maybe we need `append` in Alma?
func append(to, from) {
  if from {
    for from -> x {
      to.push(x);
    }
  }
}
func findAllAttributes(rootType) {
  my attrs = [];

  append(attrs, atType(getAttrList(), rootType));

  if atType(getInheritList(), rootType) -> parentTypes {
    # no breadth-first here since order shouldn't matter...
    for parentTypes -> parentType {
      append(attrs, findAllAttributes(parentType));
    }
  }

  return attrs;
}
func walk(root, walkers) {
  if root ~~ Array {
    return root.map(func (subRoot) { return walk(subRoot, walkers); });
  }
  # TODO dict?

  my rootType = type(root);

  # first: perfect match
  if atType(walkers, rootType) -> perfectMatch {
    return perfectMatch(root);
  }

  # any parent in the inheritance chain
  if walkAtType(walkers, rootType) -> parent {
    return parent(root);
  }

  if findAllAttributes(rootType) -> attrs {
    # reconstruct a node, based on its properties, traversed.
    my o = [];
    for attrs -> attr {
      my updatedValue = walk(root[attr], walkers);
      o.push([attr, updatedValue]);
    }
    return rootType.create(o);
  } else {
    return root;
  }
}

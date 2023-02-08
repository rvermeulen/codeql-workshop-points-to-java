# CodeQL workshop - Elements of Syntactical Program Analysis for Java

## Introduction

This workshop is an introduction to identifying syntactical elements using QL by implementing a basic Andersen style points-to analysis[^1].
A points-to analysis is a [pointer analysis](https://en.wikipedia.org/wiki/Pointer_analysis) that statically determines the set of object a variable can point to and provides information that can be used to improve the accuracy of other analyses such as computing a call-graph.
For example, consider the following Java snippet. How do we determine which `foo` method is called?
To answer the question we need to know to what object `a` points to, which can be an instance of `A` or `B` depending on how `bar` is called.

```java
class A {
    public void foo() {}
}

class B extends A {
    @Override
    public void foo() {}
}

class C {
    public void bar(A a) {
        a.foo();
    }
}
```

In this workshop the focus will be on syntactically describing elements and not the points-to algorithm.
We will learn how to describe:

- How objects are created.
- How methods are called.
- How variables are accessed and assigned a value.
- How fields are accessed, assigned a value, and how to get the qualifier of a field access.
- How to syntactically matchup method arguments with method parameters.
- How to reason about statements in a method.

We will follow the declarative formulation of the basic points-to analysis as found in the book [Pointer Analysis](https://yanniss.github.io/points-to-tutorial15.pdf)[^2]

[^1]:  Lars O. Andersen. Program Analysis and Specialization of the C Programming Language. PhD thesis, DIKU, University of Copenhagen, 1994.
[^2]: Smaragdakis, Yannis and Balatsouras, George. Pointer Analysis. Found. Trends Program. Lang. 2015.

## Representing programs

This workshops focuses on reasoning about syntactical elements.
Reasoning about syntactical elements means that we work with a representation of source code.
The representation used by CodeQL is called an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree)(AST).
It is a tree representation that captures the *parent/child* relationship of program elements in the source code and elides concrete syntax elements that do not or are no longer necessary once the *parent/child* relationship is established.
An example of concrete syntax that is commonly elided are parenthesis used to define precedence within expression `(expression) op expression `.
The parentheses are required in a linear representation such as text, but are not necessary in a tree representation such as an AST.

The AST for the following expression demonstrates this.
For the expression `(a + b) * c` we have the following corresponding AST:

```
                  .─.
                 ( * )
                  `─'
            ┌────────────┐
            │            │
            ▼            ▼
           .─.         ┌───┐
          ( + )        │ c │
           `─'         └───┘
      ┌───────────┐
      ▼           ▼
    ┌───┐       ┌───┐
    │ a │       │ b │
    └───┘       └───┘
```

The AST captures the relationships between the operators and the operands and there is no ambiguity for the precedence of the operations.
When working with QL, the *parent/child* relationships are made available in a more meaningful way through the QL classes in the standard library.
For binary expression, for example, we talk about operands and for method calls we talk about arguments instead of children.
However, if you peek into their definitions, like for the `BinaryExpr` member predicate `[getLeftOperand](https://github.com/github/codeql/blob/main/java/ql/lib/semmle/code/java/Expr.qll#L731)` you can see it relies on the *parent/child` relationship captured by the AST with the `isNthChildOf` predicate.

To explore the AST representation of a Java class you can use the AST viewer functionality available in the Visual Code CodeQL extension.
With a selected database, select a Java file in the Visual Studio Code Explorer in the folder that is added to the workspace when selecting a database, and click on the *View AST* button in the AST view in the CodeQL view found on the Visual Studio Code [Activity Bar](https://code.visualstudio.com/docs/getstarted/userinterface#_basic-layout).
Alternatively, you can right-click in the Editor and run the command *CodeQL: View AST*.

## Exercises

The following exercises incrementally implement a naive points-to implementation by syntactically describing program elements.
Each exercise is accompanied by a QL test that you can run to test your solution.
The tests are available through the Testing view or can be executed via the terminal using the `codeql test run <path-to-test>` command.

For example, to run the test for exercise 1 run `codeql test run exercises-tests/exercise1` in a terminal at the root of this repository.

When a test fails it will show you the difference between the actual output of your query and the expected output. For a failed test the test database is kept so you can select it for debugging your query.

Solutions for each exercise are provided in the `solutions` directory.

### Exercise 1

To determine the objects where variables can point to, we first need to describe what an object is.
During runtime a program can allocate multiple objects using the `new ...` expression at a single location in the program.
Since we are statically analyzing a program we need to approximate object allocation and we do that by representing objects by their allocation size, that is the program location where an object is allocated using a `new ...` expression.

Write a query to find all allocation sites by looking for the `new ...` expression.

<details>
<summary>Hints</summary>
To discover how a program element such as an expression is represented in QL you can use to approaches.

1. Use the *AST viewer* to find the element's QL class. You can create a database out of a test case by running `cp -R exercises-tests/exercise1/exercise1.testproj/ exercise1-db && codeql database bundle -o exercise1-db.zip exercise1-db/` and select the database `exercise1-db.zip` to use the AST viewer.
2. Write a query that finds all the values of type `Element` restricted to a region of code using the element's [Location](https://codeql.github.com/codeql-standard-libraries/java/semmle/code/Location.qll/type.Location$Location.html), retrieved with `getLocation()`, and obtain its primary QL classes with `getPrimaryQlClasses` to find the QL class that best describes the element.

</details>

### Exercise 2

With the allocation site of objects identified we can implement the first step in identifying points-to information.
Implement the `alloc` predicate that associates the creation of an object with a variable.
The `varPointsTo` predicate will use this as a first step to determine where variables point to.

<details>
<summary>Hints</summary>

- The class `Variable`, of which `LocalScopeVariable` is a subclass, supports the member predicate `getAnAssignedValue`
- The class `Expr` contains the member predicate `getEnclosingCallable` to find the `Callable`, such as a `Method`, the expression occurs in. 

</details>

### Exercise 3

The next step is to propagate the points-to set when a variable is assigned a value hold by a variable.
Implement the predicate `move` to capture the pattern `a = b` where `a` and `b` are both variables.

<details>
<summary>Hints</summary>

- The class `Variable`, of which `LocalScopeVariable` is a subclass, supports the member predicate `getAnAccess` to determine where the variable is accessed.

</details>

### Exercise 4

At this point we are able to gather points-to information for variables.
Java, and many other languages, supports fields to store information in variables associated with an object.
We would like to capture points-to information that is field-sensitive, or in other words, can distinguish where each fields points to.

Implement the predicate `store` to capture a variable being stored in a field.

<details>
<summary>Hints</summary>

- A `Field` is a `Variable` and supports the member predicate `getAnAccess` to determine where the field is accessed.
- An alternative is the class `FieldAccess` that captures field access and supports the predicate `getField` to get the `Field` being accessed.
- A `Field` is accessed through a qualifier, an expression that references the object the field belongs to. To get the qualifier use the predicate `getQualifier`.
- The expression `AssignExpr` captures an assignment. Use the predicates `getSrc` and `getDest` to reason about the constituents of the assignment.

</details>

### Exercise 5

Now that we known of to reason about how variables are stored in fields we want to reason about the reverse, how variables are getting their values from fields.
Implement the predicate `load` to describe the pattern `a = b.c`

### Exercise 6

With both stores and loads of fields we can start to reason about to what objects they point to.
Implement the `fieldPointsTo` predicate that associates the allocation sites of the qualifier and the variable being assigned to the field.

<details>
<summary>Hints</summary>

- To reason about allocation sites you can use the provided predicate `varPointsTo`.

</details>

### Exercise 7

At this point we have established where fields can point to.
We want to propagate this information to variables being assigned a field.
Add a conjunction to the predicate `varPointsTo` that equates the allocation site for a variable to that of the field it is assigned.

<details>
<summary>Hints</summary>

- To reason about allocation sites for field you can use the predicate `fieldPointsTo`.
- To reason about variables being assigned a field you can use the predicate  `load`.

</details>

### Exercise 8

One use of points-to analysis is the construction of a call graph.
To do that we first have to identify method calls and the signature of the method they are calling so we can look up the method when we know where the qualifier points to.
Implement the predicate `methodCall` to identify method calls, their qualifiers, and signatures.

To get a signature of the method being called from a method call use the provided predicate `getSignature`.
The reason for the `getSignature` predicate is that CodeQL doesn't provide the signature information at the call site because it has already resolved the called method during extraction.

<details>
<summary>Hints</summary>

- To reason about method calls you can use the class `MethodAccess`.
- To reason about method call qualifiers you can use the member predicate `getQualifier` provided by the `MethodAccess` class.

</details>

### Exercise 9

To associate method calls with methods we need to be able to lookup methods by their class and their signature.
Implement the predicate `getMethod` that given a `Class` and a signature returns a method.

Note: this exercise is purely educational. The standard library provides a more accurate implementation to resolve methods that is accessible from the `MethodAccess` class with the member predicate `getMethod`.

<details>
<summary>Hints</summary>

- To reason about a method's signature you can use the member predicate `getSignature`.
- A method belongs to a [reference type](https://docs.oracle.com/javase/specs/jls/se8/html/jls-4.html#jls-4.3), such as a *class* or *interface*. To obtain the type declaring the method you can use the member predicate `getDeclaringType`.

</details>

### Exercise 10

Now that we can reason about method calls and lookup methods we can construct a call graph using the points-to information of the qualifier of the method call.
Implement the predicate `callGraph` that for a method call looks up the corresponding method based on the point-so information of the qualifier.

<details>
<summary>Hints</summary>

- To reason about a variable and a use of the variable you can use the member predicate `getAnAccess` on a variable or use the class `VariableAccess` in combination with the member predicate `getVariable`.

</details>

### Exercise 11

So far we have only reasoned about points-to information intraprocedurally. That is, within a function and not across function boundaries through, for example, calls.
Implement the `interproceduralAssign` predicate to associate the points-to information of a method call argument to the called method's parameter.

<details>
<summary>Hints</summary>

- To reason about a method call's argument you can use the member predicate  `getArgument` or `getAnArgument`.
- To reason about a method's parameter you can use the member predicate `getParameter` or `getAParameter`.
- Java passes arguments by position.

</details>

### Exercise 12

In the previous exercise we have propagated points-to information from the *caller* to the *callee*.
What remains is to propagate points-to information from the *callee* to the *caller* that can happen through a return statement.
Add a *disjunction* to the `interproceduralAssign` predicate to associate points-to information from the result of a method call to an assignment of a variable.

<details>
<summary>Hints</summary>

- The `Assignment` class, representing assignment expressions `x = y`, has the member predicates `getDest` and `getSrc` to reason about its operands.
- To reason about the statements in a method you can use the `Method`'s member predicate `getBody` to get the method's block statement `{...}` and the `BlockStmt`s member predicate `getAStmt`.
- The class `ReturnStmt` can be used to reason about `return ...` statements. It's member predicate `getResult` provides the expression that is returned.
- QL supports [https://codeql.github.com/docs/ql-language-reference/expressions/#casts] to constrain the type of an expression. For example:

  ```ql
  import java

  from BlockStmt s, Expr result
  where result = s.getAStmt().(ReturnStmt).getResult()
  select result
  ```

</details>

# CodeQL workshop - Elements of Syntactical Program Analysis for Java

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

## Exercises

### Exercise 1

To determine the objects where variables can point to, we first need to describe what an object is.
During runtime a program can allocate multiple objects using the `new ...` expression.
Since we are statically analyzing a program we need to approximate object allocation and represent objects by allocation size, that is the program location where an object is allocated using a `new ...` expression.

Write a query to find all allocation size by looking for the `new ...` expression.
To test your query run the test `exercises-tests/exercise1/Exercise1.qlref` via the Visual Studio Code test explorer or with the command `codeql test run exercises-tests/exercise1` in a terminal in the root of

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

### Exercise 9

To associate method calls with methods we need to be able to lookup methods by their class and their signature.
Implement the predicate `getMethod` that given a `Class` and a signature returns a method.

### Exercise 10

Now that we can reason about method calls and lookup methods we can construct a call graph using the points-to information of the qualifier of the method call.
Implement the predicate `callGraph` to associate method calls with method.
class A {}

class B extends A {}

class C {
  public A a;

  void foo() {}
}

class D {
  void bar() {}
}

class E extends C {
  void foo() {}
}

class Test {
  public static void main(String[] args) {
    alloc();
    move();
    store();
    load();
    call();
  }

  public static void alloc() {
    A a = new A();
    B b = new B();
  }

  public static void move() {
    A a = new A();
    B b = new B();
    a = b;
  }

  public static void store() {
    C c = new C();
    A a = new A();
    c.a = a;
  }

  public static void load() {
    C c = new C();
    B b = new B();
    c.a = b;
    A a;

    a = c.a;
  }

  public static void call() {
    C c1 = new C();
    D d = new D();
    E e = new E();
    C c2 = new E();
    c1.foo();
    d.bar();
    e.foo();
    c2.foo();
  }
}
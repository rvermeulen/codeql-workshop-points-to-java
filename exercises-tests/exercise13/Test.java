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

class F {

  Object identity(Object o) { return o; }
}

class Test {
  public static void main(String[] args) {
    alloc();
    move();
    store();
    load();
    vcall();
    inter_proc();
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

  public static void vcall() {
    C c = new C();
    D d = new D();
    E e = new E();
    c.foo();
    d.bar();
    e.foo();
  }

  public static void inter_proc() {
    Object a = new A();
    B b = new B();
    C c = new C();
    F f = new F();

    a = f.identity(b);
    a = f.identity(c);
  }
}
class A {}

class B extends A {}

class C {
  public A a;
}

class Test {
  public static void main(String[] args) {
    alloc();
    move();
    store();
    load();
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
}
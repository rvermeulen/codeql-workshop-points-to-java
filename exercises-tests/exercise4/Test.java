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
}
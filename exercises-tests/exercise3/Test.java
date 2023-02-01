class A {}

class B extends A {}

class Test {
  public static void main(String[] args) {
    alloc();
    move();
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
}
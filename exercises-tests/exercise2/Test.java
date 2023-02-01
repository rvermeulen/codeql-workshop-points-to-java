class A {}

class B extends A {}

class Test {
  public static void main(String[] args) { alloc(); }

  public static void alloc() {
    A a = new A();
    B b = new B();
  }
}
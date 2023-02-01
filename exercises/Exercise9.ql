import java

Method getMethod(Class klass, string signature) {
  // Exercise 9: Find the method given their class and signature.
  any()
}

from Class klass, string signature, Method method
where method = getMethod(klass, signature) and exists(method.getFile().getRelativePath())
select klass, signature, method

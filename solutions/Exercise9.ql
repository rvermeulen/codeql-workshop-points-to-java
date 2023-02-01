import java

Method getMethod(Class klass, string signature) {
  result.getDeclaringType() = klass and
  result.getSignature() = signature
}

from Class klass, string signature, Method method
where method = getMethod(klass, signature) and exists(method.getFile().getRelativePath())
select klass, signature, method

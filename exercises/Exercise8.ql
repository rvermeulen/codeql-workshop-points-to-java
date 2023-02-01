import java

string getSignature(MethodAccess call) { result = call.getCallee().getSignature() }

predicate methodCall(
  LocalScopeVariable qualifier, string signature, MethodAccess call, Method inMethod
) {
  // Exercise 8: Given a method call find the qualifier, the signature of the called method, and the method containing the call.
  any()
}

from LocalScopeVariable qualifier, MethodAccess call, Method inMethod, string signature
where methodCall(qualifier, signature, call, inMethod)
select qualifier, call, signature, inMethod

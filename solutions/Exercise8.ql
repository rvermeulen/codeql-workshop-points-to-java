import java

string getSignature(MethodAccess call) { result = call.getCallee().getSignature() }

predicate methodCall(
  LocalScopeVariable qualifier, string signature, MethodAccess call, Method inMethod
) {
  call.getCaller() = inMethod and
  call.getQualifier() = qualifier.getAnAccess() and
  signature = getSignature(call)
}

from LocalScopeVariable qualifier, MethodAccess call, Method inMethod, string signature
where methodCall(qualifier, signature, call, inMethod)
select qualifier, call, signature, inMethod

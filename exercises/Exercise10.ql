import java

// Replace with the solution from exercise 1
class AllocationSite extends Expr {
  AllocationSite() { none() }
}

predicate alloc(LocalScopeVariable variable, AllocationSite allocationSite, Callable callable) {
  // Replace with the solution from exercise 2.
  any()
}

predicate move(LocalScopeVariable dest, Variable src) {
  // Exercise 3: Describe how a value in `src` is moved to `dest`
  none()
}

predicate store(LocalScopeVariable qualifier, Field field, LocalScopeVariable src) {
  // Replace with the solution from exercise 4.
  any()
}

predicate load(LocalScopeVariable dest, LocalScopeVariable qualifier, Field field) {
  // Replace with the solution from exercise 5.
  any()
}

predicate fieldPointsTo(
  AllocationSite qualifierAllocationSite, Field field, AllocationSite srcAllocationSite
) {
  // Replace with the solution from exercise 6
  any()
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  // Replace with solution from exercise 7.
  any()
}

string getSignature(MethodAccess methodAccess) { result = methodAccess.getMethod().getSignature() }

predicate methodCall(
  LocalScopeVariable qualifier, string signature, MethodAccess call, Method inMethod
) {
  // Replace with solution from exercise 8.
  any()
}

Method getMethod(Class klass, string signature) {
  // Replace with solution from exercise 9.
  any()
}

predicate callGraph(MethodAccess methodAccess, Method method) {
  // Exercise 10: Associate a method call with a method by using the points-to information of the qualifier
  any()
}

from MethodAccess methodAccess, Method method
where callGraph(methodAccess, method)
select methodAccess, method

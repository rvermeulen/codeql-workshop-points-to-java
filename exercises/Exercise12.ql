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
  // Replace with solution from exercise 10.
  any()
}

predicate interproceduralAssign(LocalScopeVariable src, LocalScopeVariable dest) {
  // Replace with solution from exercise 11.
  exists(Method method, MethodAccess methodAccess, int index | any())
  or
  exists(Method method, MethodAccess methodAccess, Assignment assignment |
    // Exercise 12: Associate the points-to information from the variable being returned to the value being assigned the method call result.
    any()
  )
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

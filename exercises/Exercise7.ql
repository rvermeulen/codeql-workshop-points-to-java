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
  alloc(variable, allocationSite, _)
  or
  exists(LocalScopeVariable src | move(variable, src) and varPointsTo(src, allocationSite))
  // Exercise 7: Implement the propagation of points-to information from a field load to a variable.
  // That is the pattern, `a = b.c`
  // or
  //exists(LocalScopeVariable qualifier, AllocationSite qualifierAllocationSite, Field field |
  //)
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

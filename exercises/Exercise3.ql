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

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
  or
  exists(LocalScopeVariable src | move(variable, src) and varPointsTo(src, allocationSite))
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

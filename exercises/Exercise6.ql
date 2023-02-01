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

predicate fieldPointsTo(
  AllocationSite qualifierAllocationSite, Field field, AllocationSite srcAllocationSite
) {
  // Exercise 6: Associate the qualifier allocation site and the source allocation site with the field.
  any()
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
  or
  exists(LocalScopeVariable src | move(variable, src) and varPointsTo(src, allocationSite))
}

from AllocationSite qualifierAllocationSite, Field field, AllocationSite srcAllocationSite
where fieldPointsTo(qualifierAllocationSite, field, srcAllocationSite)
select qualifierAllocationSite, field, srcAllocationSite

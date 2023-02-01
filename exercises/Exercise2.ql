import java

// Copy your solution from exercise 1
class AllocationSite extends Expr {
  AllocationSite() { none() }
}

// Exercise 2: Associated an allocation site, the creation of an object with a variable by describing the pattern `a = new ...`
predicate alloc(LocalScopeVariable variable, AllocationSite allocationSite, Callable callable) {
  none()
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

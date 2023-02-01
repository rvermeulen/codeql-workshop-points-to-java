import java

class AllocationSite = ClassInstanceExpr;

predicate alloc(LocalScopeVariable variable, AllocationSite allocationSite, Callable callable) {
  variable.getAnAssignedValue() = allocationSite and
  allocationSite.getEnclosingCallable() = callable
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

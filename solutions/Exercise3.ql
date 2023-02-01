import java

class AllocationSite = ClassInstanceExpr;

predicate alloc(LocalScopeVariable variable, AllocationSite allocationSite, Callable callable) {
  variable.getAnAssignedValue() = allocationSite and
  allocationSite.getEnclosingCallable() = callable
}

predicate move(LocalScopeVariable dest, Variable src) {
  exists(AssignExpr assign |
    assign.getSource() = src.getAnAccess() and assign.getDest() = dest.getAnAccess()
  )
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
  or
  exists(LocalScopeVariable src | move(variable, src) and varPointsTo(src, allocationSite))
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

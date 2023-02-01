import java

class AllocationSite = ClassInstanceExpr;

predicate alloc(LocalScopeVariable variable, AllocationSite allocationSite, Callable callable) {
  variable.getAnAssignedValue() = allocationSite and
  allocationSite.getEnclosingCallable() = callable
}

predicate move(LocalScopeVariable dest, LocalScopeVariable src) {
  exists(AssignExpr assign |
    assign.getSource() = src.getAnAccess() and assign.getDest() = dest.getAnAccess()
  )
}

predicate store(LocalScopeVariable qualifier, Field field, LocalScopeVariable src) {
  exists(AssignExpr assign, FieldAccess fieldAccess |
    assign.getSource() = src.getAnAccess() and
    assign.getDest() = fieldAccess and
    fieldAccess.getField() = field and
    fieldAccess.getQualifier() = qualifier.getAnAccess()
  )
}

predicate load(LocalScopeVariable dest, LocalScopeVariable qualifier, Field field) {
  exists(AssignExpr assign, FieldAccess fieldAccess |
    assign.getSource() = fieldAccess and
    assign.getDest() = dest.getAnAccess() and
    fieldAccess.getField() = field and
    fieldAccess.getQualifier() = qualifier.getAnAccess()
  )
}

predicate fieldPointsTo(
  AllocationSite qualifierAllocationSite, Field field, AllocationSite srcAllocationSite
) {
  exists(LocalScopeVariable qualifier, LocalScopeVariable src |
    store(qualifier, field, src) and
    varPointsTo(qualifier, qualifierAllocationSite) and
    varPointsTo(src, srcAllocationSite)
  )
}

predicate varPointsTo(LocalScopeVariable variable, AllocationSite allocationSite) {
  alloc(variable, allocationSite, _)
  or
  exists(LocalScopeVariable src | move(variable, src) and varPointsTo(src, allocationSite))
  or
  exists(LocalScopeVariable qualifier, AllocationSite qualifierAllocationSite, Field field |
    load(variable, qualifier, field) and
    varPointsTo(qualifier, qualifierAllocationSite) and
    fieldPointsTo(qualifierAllocationSite, field, allocationSite)
  )
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

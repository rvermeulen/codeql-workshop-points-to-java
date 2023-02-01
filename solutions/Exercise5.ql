import java

predicate load(LocalScopeVariable dest, LocalScopeVariable qualifier, Field field) {
  exists(AssignExpr assign, FieldAccess fieldAccess |
    assign.getSource() = fieldAccess and
    assign.getDest() = dest.getAnAccess() and
    fieldAccess.getField() = field and
    fieldAccess.getQualifier() = qualifier.getAnAccess()
  )
}

from LocalScopeVariable dest, LocalScopeVariable qualifier, Field field
where load(dest, qualifier, field)
select dest, qualifier, field

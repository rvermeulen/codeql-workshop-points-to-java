import java

predicate store(LocalScopeVariable qualifier, Field field, LocalScopeVariable src) {
  exists(AssignExpr assign, FieldAccess fieldAccess |
    assign.getSource() = src.getAnAccess() and
    assign.getDest() = fieldAccess and
    fieldAccess.getField() = field and
    fieldAccess.getQualifier() = qualifier.getAnAccess()
  )
}

from LocalScopeVariable qualifier, Field field, LocalScopeVariable src
where store(qualifier, field, src)
select qualifier, field, src

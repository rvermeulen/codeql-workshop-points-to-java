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
  or
  exists(LocalScopeVariable src |
    interproceduralAssign(src, variable) and
    varPointsTo(src, allocationSite)
  )
}

string getSignature(MethodAccess methodAccess) { result = methodAccess.getMethod().getSignature() }

predicate methodCall(
  LocalScopeVariable qualifier, string signature, MethodAccess call, Method inMethod
) {
  call.getCaller() = inMethod and
  call.getQualifier() = qualifier.getAnAccess() and
  signature = getSignature(call)
}

Method getMethod(Class klass, string signature) {
  result.getDeclaringType() = klass and
  result.getSignature() = signature
}

predicate callGraph(MethodAccess methodAccess, Method method) {
  exists(LocalScopeVariable qualifier, string signature, AllocationSite qualifierAllocationSite |
    methodCall(qualifier, signature, methodAccess, _) and
    varPointsTo(qualifier, qualifierAllocationSite) and
    method = getMethod(qualifierAllocationSite.getType(), signature)
  )
}

predicate interproceduralAssign(LocalScopeVariable src, LocalScopeVariable dest) {
  exists(Method method, MethodAccess methodAccess, int index |
    callGraph(methodAccess, method) and
    methodAccess.getArgument(index) = src.getAnAccess() and
    method.getParameter(index) = dest
  )
  or
  exists(Method method, MethodAccess methodAccess, Assignment assignment |
    callGraph(methodAccess, method) and
    assignment.getDest() = dest.getAnAccess() and
    assignment.getSource() = methodAccess and
    method.getBody().getAStmt().(ReturnStmt).getResult() = src.getAnAccess()
  )
}

from LocalScopeVariable variable, AllocationSite allocationSite
where varPointsTo(variable, allocationSite)
select variable, allocationSite

import java

predicate load(LocalScopeVariable dest, LocalScopeVariable qualifier, Field field) { any() }

from LocalScopeVariable dest, LocalScopeVariable qualifier, Field field
where load(dest, qualifier, field)
select dest, qualifier, field

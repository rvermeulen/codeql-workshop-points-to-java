import java

predicate store(LocalScopeVariable qualifier, Field field, LocalScopeVariable src) { any() }

from LocalScopeVariable qualifier, Field field, LocalScopeVariable src
where store(qualifier, field, src)
select qualifier, field, src

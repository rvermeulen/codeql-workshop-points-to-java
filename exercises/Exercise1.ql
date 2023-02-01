import java

// Exercise 1: Implement a characteristic predicate that represents the `new ...` expression.
class AllocationSite extends Expr {
  AllocationSite() { none() }
}

select any(AllocationSite allocationSite)

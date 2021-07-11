import Foundation

struct PredicateSet<A> {
    let contains: (A) -> Bool
    
    /// contravarient to map left side A to B isn't possible with map
    func contramap<B>(_ f: @escaping (B) -> A) -> PredicateSet<B> {
        return PredicateSet<B> { b in
            self.contains(f(b))
        }
    }
    
    /// we can rename contramap to pullback following category theory and math
    /// pullback name is better to us from Local to Global or Subclass to Superclass
    func pullback<B>(_ f: @escaping (B) -> A) -> PredicateSet<B> {
        return self.contramap(f)
    }
}

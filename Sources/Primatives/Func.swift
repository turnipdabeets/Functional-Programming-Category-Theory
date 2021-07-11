import Foundation

struct Func<A, C> {
    let apply: (A) -> C
}

/// Functor
extension Func {
    /// maps right side C to D
    func fmap<D>(_ f: @escaping(C) -> D) -> Func<A, D> {
        return Func<A, D> { a in
            f(self.apply(a))
        }
    }
    
    /// maps left side A to B
    func contramap<B>(_ f: @escaping(B) -> A) -> Func<B, C> {
        return Func<B, C> { b in
            self.apply(f(b))
        }
    }
    
    func _fmap<D>(_ f: @escaping (C) -> D) -> Func<A, D> {
        return self.bind { c in Func<A, D> { _ in f(c) } }
    }
}

/// Monad
extension Func {
    func bind<D>(_ f: @escaping (C) -> Func<A, D>) -> Func<A, D> {
        return Func<A, D> { a -> D in
            f(self.apply(a)).apply(a)
        }
    }
}

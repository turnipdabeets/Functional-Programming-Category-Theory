import Foundation

/// Useful if you need in-place mutations, values that potentially vary with each evaluation, or carrying working memory whie traversing a data sturcture.
public struct State<V, S> {
    private let fn: (S) -> (V, S)
    
    /// Wrap a stateful computation.
    public init(_ f: @escaping (S) -> (V, S)) {
        fn = f
    }
    
    /// Run the computation with a starting state, returning a tuple of the value and the final state.
    public func run(_ s: S) -> (V, S) {
        return fn(s)
    }
    
    /// Run the computation and return on the resulting value, discarding the final state.
    public func eval(s: S) -> V {
        return run(s).0
    }

    /// Run the computation and return the final state, discarding the resulting value.
    public func exec(s: S) -> S {
        return run(s).1
    }
}

/// Construct a State where the state is also the value you return.
public func get<S>() -> State<S, S> {
    return State { s in (s, s) }
}

/// Construct a State that replaces the current state with the resulting argument.
public func put<S>(_ s: S) -> State<(), S> {
    return State { _ in ((), s) }
}

/// Return a new state by applying a function to the current state, discarding the old state.
///
/// Example::
///
///     modify { $0 + 1 }.exec(1) // => 2
///
/// This is equivalent to a swift assignment operation::
///
///     var i = 1; i += 1 // => 2
///
public func modify<S>(f: @escaping (S) -> S) -> State<(), S> {
    return State { s in ((), f(s)) }
}

//// Monoid
//extension State: Monoid {
//    public static var mempty: State<V, S> {
////        return State({self.fn()}})
//    }
//    
//    public func mappend(_ m: State<V, S>) -> State<V, S> {
//        <#code#>
//    }
//}


// Functor
extension State {
    typealias A = V
    
    func fmap<B>(_ f: @escaping (V) -> B) -> State<B,S> {
        return State<B,S>{ s in
            let pair = self.run(s)
            let b = f(pair.0)
            return (b, pair.1)
        }
    }
}

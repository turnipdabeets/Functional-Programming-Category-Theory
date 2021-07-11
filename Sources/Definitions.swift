import Foundation

/// A semigroup generalizes a monoid in that there might not exist an identity element. Think NonEmpty
/// In mathematics, a semigroup is an algebraic structure consisting of a set together with an associative binary operation.
public protocol Semigroup {
    /// (<>) smashes or concats two values together allowing for accumulation
    func mappend(_ m: Self) -> Self
}

public protocol Monoid: Semigroup {
    /// neutral element, or identity value
    static var mempty: Self { get }
}

/// A parameterized type, aka container type
protocol Functor {
    associatedtype A
    associatedtype F: Functor = Self

    /// Preserves the structure of the Functor by reaching inside and converting an A to a B
    func fmap<B>(_ transform: (A) -> B) -> F where F.A == B
}

/// A structure intermediate between a functor and a monad (technically, a strong lax monoidal functor).
protocol Applicative: Functor {
    associatedtype A
    associatedtype F = Self
    
    /// Lifts a value to the context type implementing this instance of `Applicative`.
    func pure<A>(_ a: A) -> F where F.A == A
    
    ///  (<*>) signature is very similar to fmap, but wraps transform inside a Functor
 // func apply<B>(_ transform: F<(A) -> B> -> F<B>
//    func apply<B>(_ transform: F) -> F where F.A == B
}

//protocol ApplicativeFunctor: Applicative, Functor


/// **"A monad is a monoid in the category of endofunctors"**
/// Endofunctor is a mapping of objects and morphisims from one category to the same category. All functors we work with in programming are endofunctors becasue we are dealing with one catgory, the category of types (sometimes we use the category of sets to demonstrate types)!

/// Therefore, all monads in programming are monoids

/// All Monads are Functors and Monoids? No, Applicative functors are not monads
protocol Monad {
    associatedtype T
    associatedtype M: Monad = Self
    
    /// (>>=) Sequentially compose two actions, passing any value produced by the first as an argument to the second. This can be read as "then" and known as `flatMap` in Swift. This operation will short curcuit rather than accumulate.
    func bind<B>(_ transform: (T) -> M) -> M where M.T == B
}

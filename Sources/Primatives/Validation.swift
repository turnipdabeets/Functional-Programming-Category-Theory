import Foundation
import NonEmpty

/// **"A data-type like Either but with an accumulating Applicative"**.
/// Validation is isomorphic to Either, but if two (or more) errors are encountered, they are appended using a Semigroup operation where Either will sshort curcuit on one error case.
/// As a consequence of this Applicative instance, there is no corresponding Bind or Monad instance. Validation is an example of, "An applicative functor that is not a monad."
enum Validation<Success, Failure> where Failure: Semigroup {
    case valid(Success)
    /// Failure is a Semigroup instead of a Monoid becasue it can never be empty.
    /// An alternative would be `invalid(NonEmptyArray<Failure>)`
    case invalid(Failure)
//    case invalid(NonEmptyArray<Failure>)
}

extension Validation: Functor {
    func fmap<B>(_ f: (Success) -> B) -> Validation<B, Failure> {
        switch self {
        case let .valid(a):
            return .valid(f(a))
        case let .invalid(e):
            return .invalid(e)
        }
    }
    
    func _fmap<B>(_ f: (Success) -> B) -> Validation<B, Failure> {
        return self.bind { .valid(f($0)) }
    }
    
    /// Validtion is also an instance of bifunctor, TODO: write bifunctor
}

extension Validation: Applicative {
    func pure<A>(_ a: A) -> Validation<A, Failure> {
        return .valid(a)
    }
    
    func apply<B>(_ transform: Validation<(Success) -> B, Failure>) -> Validation<B, Failure> {
        switch self {
        case let .valid(value):
            switch transform {
            case let .valid(f):
                return .valid(f(value))
            case let .invalid(error):
                return .invalid(error)
            }
        case let .invalid(error):
            switch transform {
            case .valid:
                return .invalid(error)
            case let .invalid(error2):
                return .invalid(error.mappend(error2))
            }
        }
    }
}


/// If you don't use the Applicative Validation you can actually still write bind, but in haskell this doesn't exists. Validation is an example of, "An applicative functor that is not a monad."
extension Validation: Monad {
    func bind<B>(_ f: (Success) -> Validation<B, Failure>) -> Validation<B, Failure> {
        switch self {
        case let .valid(value):
            return f(value)
        case let .invalid(error):
            return .invalid(error)
        }
    }
}

///can't make a zip out of flapMap for Validated becasue it will not concat more than one error


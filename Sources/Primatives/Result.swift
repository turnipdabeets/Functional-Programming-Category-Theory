import Foundation

extension Result: Monad {
    func bind<B>(_ f: (A) -> Result<B, Failure>) -> Result<B, Failure> {
        switch self {
        case let .success(value):
            return f(value)
        case let .failure(error):
            return .failure(error)
        }
    }
}

extension Result: Functor {
    func fmap<B>(_ f: (Success) -> B) -> Result<B, Failure> {
        switch self {
        case let .success(value):
            return .success(f(value))
        case let .failure(e):
            return .failure(e)
        }
    }
    
    func _fmap<B>(_ f: (Success) -> B) -> Result<B, Failure> {
        return self.flatMap { .success(f($0)) }
    }
    
    /// Result is a Bifunctor because we can map both parameters
    func bimap<B,F>(_ f: (Success) -> B, _ g: (Failure) -> F) -> Result<B, F>{
        switch self {
        case let .success(value):
            return .success(f(value))
        case let .failure(e):
            return .failure(g(e))
        }
    }
}

extension Result: Semigroup where Success: Monoid {
    public static var mempty: Result<Success, Failure> {
        .success(Success.mempty)
    }
    
    // Should errors forwards? Is the mempty value correct??
    public func mappend(_ m: Result<Success, Failure>) -> Result<Success, Failure> {
        switch self {
        case let .failure(e1):
            return .failure(e1)
        case let .success(value):
            switch m {
            case let .failure(e2):
                return .failure(e2)
            case let .success(nextValue):
                return .success(value.mappend(nextValue))
            }
        }
    }
}

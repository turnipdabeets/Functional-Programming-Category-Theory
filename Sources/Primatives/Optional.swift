import Foundation

extension Optional: Monad {
//    typealias B = D
    
//    typealias C = Wrapped

    func bind<D>(_ f: (Wrapped) -> D?) -> D? {
        switch self {
        case let .some(value):
            return f(value)
        case .none:
            return .none
        }
    }
}

extension Optional: Functor {
    typealias A = Wrapped
    
    public func fmap<B>(_ f: (Wrapped) -> B) -> B?{
        switch self {
        case let .some(value):
            return .some(f(value))
        case .none:
            return .none
        }
    }
    
    public func _fmap<B>(_ f: (Wrapped) -> B) -> B? {
        return self.bind { Optional<B>.some(f($0)) }
    }
}

extension Optional: Applicative {
    func pure<A>(_ a: A) -> A? {
        return .some(a)
    }
    
    func apply<B>(_ f: ((Wrapped) -> B)?) -> B? {
        switch f {
        case let .some(someFunc): return fmap(someFunc)
        case .none: return .none
        }
    }
}

// Because we need to constrain Wrapped we can't define all of these functions together and conform to Monad
extension Optional where Wrapped: Monoid {
    var identity: Optional {
        return self.mappend(Optional.mempty)
    }

    static var mempty: Optional {
        return .none
    }
    
    func mappend(_ m: Optional<Wrapped>) -> Optional<Wrapped> {
        switch self {
        case .none:
            return m
        case let .some(value):
            switch m {
            case .none:
                return self
            case let .some(nextValue):
                return .some(value.mappend(nextValue))
            }
        }
    }
}

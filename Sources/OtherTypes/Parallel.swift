import Foundation

struct Parallel<A> {
    let run: (@escaping (A) -> Void) -> Void
    
    /// A is covariant even though on left side
    /// (consider -1 + -1 = +1)
    func fmap<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
        return Parallel<B>{ callback in
            self.run { a in
                callback(f(a))
            }
        }
    }
    
    func _fmap<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
        return self.bind { a in Parallel<B> { callback in callback(f(a)) } }
    }
}

/// Monad
extension Parallel {
    func bind<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
        return Parallel<B> { callback in
            self.run { a in
                f(a).run(callback)
            }
        }
    }
    
    /// rename for bind
    func then<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
        return self.bind(f)
    }
    
    /// rename for bind
    func flatMap<B>(_ f: @escaping (A) -> Parallel<B>) -> Parallel<B> {
        return self.bind(f)
    }
}

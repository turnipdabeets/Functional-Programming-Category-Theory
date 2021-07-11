import Foundation

extension Array: Monad {
    func bind<B>(_ f: (Element) -> [B]) -> [B] {
        var result: [B] = []
        for element in self {
            result.append(contentsOf: f(element))
        }
        return result
    }
}

extension Array: Functor {
    func fmap<B>(_ f: (Element) -> B) -> [B]{
        var result = [B]()
        for item in self {
            result.append(f(item))
        }
        return result
    }
    
    func _fmap<B>(_ f: (Element) -> B) -> [B] {
        return self.flatMap { [f($0)] }
    }
}

extension Array: Applicative {
    func pure<A>(_ a: A) -> [A] {
        return [a]
    }
    
    func apply<B>(_ transform: [(Element) -> B]) -> [B] {
        var result = [B]()
        for f in transform {
            result += fmap(f)
        }
        return result
    }
}

extension Array: Monoid {
    public var identity: Array<Element> {
        return self.mappend(Array.mempty)
    }
    
    public static var mempty: Array<Element> {
        return []
    }
    
    public func mappend(_ m: Array<Element>) -> Array<Element> {
        return self + m
    }
}

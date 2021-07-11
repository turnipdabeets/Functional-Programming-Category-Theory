import Foundation

// Becasuse we can't extend Bool twice or use two typealiases we need wrappers for Any and All

public struct All {
    private let bool: Bool
}

public struct `Any` {
    private let bool: Bool
}

extension All: Monoid {
    public static var mempty: All {
        return All(bool: true)
    }
    
    public func mappend(_ m: All) -> All {
        return All(bool: self.bool && m.bool)
    }
}

extension `Any`: Monoid {
    public static var mempty: `Any` {
        return `Any`(bool: false)
    }
    
    public func mappend(_ m: `Any`) -> `Any` {
        return `Any`(bool: self.bool || m.bool)

    }
}

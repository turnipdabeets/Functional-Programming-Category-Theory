import Foundation

public struct Sum: Monoid {
    private let int: Int
    
    public var identity: Sum {
        return Sum(int: self.mappend(Sum.mempty).int)
    }
    
    public static var mempty: Sum {
        return Sum(int: 0)
    }
    
    public func mappend(_ m: Sum) -> Sum {
        return Sum(int: self.int + m.int)
    }
}

public struct Product: Monoid {
    private let int: Int
    
    public var identity: Product {
        return Product(int: self.mappend(Product.mempty).int)
    }
    
    public static var mempty: Product {
        return Product(int: 1)
    }
    
    public func mappend(_ m: Product) -> Product {
        return Product(int: self.int * m.int)
    }
}


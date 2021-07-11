import Foundation

extension String: Monoid {
    public var identity: String {
        return self.mappend(String.mempty)
    }
    
    public static var mempty: String {
        return ""
    }
    
    public func mappend(_ m: String) -> String {
        return self + m
    }
}

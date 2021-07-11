import Foundation

/// Writer Monad, coming from the Kleisli Category, wraps a Type and saves logs to be used by the caller, avoiding a logging dependency. Logs are usually an Array, but these can be any Monoidal type.
public struct Writer<T, M: Monoid> {
    public let value: T
    public let logs: M
    
    init(value: T, logs: M = M.mempty) {
        self.value = value
        self.logs = logs
    }
}

extension Writer: Monad {
    func bind(_ f: (T) -> Writer<T, M>) -> Writer<T, M> {
        let newWriter = f(value)
        return Writer(
            value: newWriter.value,
            logs: logs.mappend(newWriter.logs))
    }
}

import Foundation

public enum Either<A,B> {
    case Left(A)
    case Right(B)
}


/// In contrast to Validation, the Applicative for Either returns only the first error.

import Foundation

// MARK: - Debug Wrapper

public func debug<T>(
    _ name: String,
    input: String,
    position: inout String.Index,
    debugger: ParserDebugging,
    operationType: OperationType = .leaf,
    parser: (inout String.Index) -> T?
) -> T? {
    let start = input.distance(from: input.startIndex, to: position)
    debugger.enter(name, at: start, operationType: operationType)
    
    let result = parser(&position)
    
    let end = input.distance(from: input.startIndex, to: position)
    debugger.exit(success: result != nil, at: end, result: result)
    
    return result
}


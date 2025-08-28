//
//  RightMostFailureParserDebugger.swift
//  ArborEssence
//
//  Created by Yannis De Cleene on 28/08/2025.
//

public final class RightMostFailureParserDebugger: ParserDebugging {
    public var isEnabled: Bool = true

    /// Global right-most failure
    private(set) var rightMostFailure: (position: Int, expected: String)?

    /// Stack of parser frames
    private class Frame {
        let name: String
        let start: Int
        var deepestFailure: (position: Int, expected: String)?
        
        init(name: String, start: Int) {
            self.name = name
            self.start = start
        }
    }
    
    private var stack: [Frame] = []

    public init() {}

    public func reset() {
        rightMostFailure = nil
        stack.removeAll()
    }

    public func enter(_ name: String, at position: Int, operationType: OperationType) {
        guard isEnabled else { return }
        stack.append(Frame(name: name, start: position))
    }

    public func exit(success: Bool, at position: Int, result: Any?) {
        guard isEnabled else { return }
        guard let frame = stack.popLast() else { return }
        
        if success {
            // Parser succeeded → discard any child failures
            return
        } else {
            // Parser failed → propagate deepest failure to parent or global
            let failure = frame.deepestFailure ?? (position, frame.name)
            if let parent = stack.last {
                // Keep the deepest failure in parent
                if parent.deepestFailure == nil || failure.position > parent.deepestFailure!.position {
                    parent.deepestFailure = failure
                }
            } else {
                // No parent → update global right-most failure
                if rightMostFailure == nil || failure.position > rightMostFailure!.position {
                    rightMostFailure = failure
                }
            }
        }
    }

    public func recordChildFailure(position: Int, expected: String) {
        guard isEnabled else { return }
        // Only update current frame's deepest failure
        if let frame = stack.last {
            if frame.deepestFailure == nil || position > frame.deepestFailure!.position {
                frame.deepestFailure = (position, expected)
            }
        } else {
            // fallback to global
            if rightMostFailure == nil || position > rightMostFailure!.position {
                rightMostFailure = (position, expected)
            }
        }
    }

    public func printTree() {
        if let failure = rightMostFailure {
            print("❌ Right-most failure at position \(failure.position). Expected: \(failure.expected)")
        }
    }
}

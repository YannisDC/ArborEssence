//
//  ParserDebugger.swift
//  ArborEssence
//
//  Created by Yannis DE CLEENE on 11/06/2025.
//

public final class ParserDebugger: ParserDebugging {
    private(set) var root: TraceNode?
    private var current: TraceNode?
    
    public var isEnabled: Bool = true
    
    public init() {}
    
    public func reset() {
        root = nil
        current = nil
    }
    
    public func enter(_ name: String, at position: Int, operationType: OperationType = .leaf) {
        guard isEnabled else { return }
        
        let node = TraceNode(name: name, start: position, operationType: operationType, parent: current)
        if let parent = current {
            parent.children.append(node)
        } else {
            root = node
        }
        current = node
        
    }
    
    public func exit(success: Bool, at position: Int, result: Any? = nil) {
        guard isEnabled else { return }
        current?.result = result
        current?.end = position
        current = current?.parent
    }
    
    public func printTree() {
        guard isEnabled else { return }
        root?.prettyPrint()
    }
}

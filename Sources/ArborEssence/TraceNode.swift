//
//  TraceNode.swift
//  ArborEssence
//
//  Created by Yannis DE CLEENE on 11/06/2025.
//

import Foundation

class TraceNode {
    let name: String
    let start: Int
    var end: Int?
    var success: Bool {
        result != nil
    }
    var result: Any?
    var children: [TraceNode] = []
    weak var parent: TraceNode?
    let operationType: OperationType
    
    init(name: String, start: Int, operationType: OperationType = .leaf, parent: TraceNode? = nil) {
        self.name = name
        self.start = start
        self.operationType = operationType
        self.parent = parent
    }
    
    func prettyPrint(prefix: String = "", isLast: Bool = true) {
        let status = success ? SuccessSymbols.success.rawValue : operationType.symbol
        let range = end.map { "\(start)...\($0)" } ?? "\(start)...?"
        let marker = isLast ? "└─" : "├─"
        print("\(prefix)\(marker) \(status) \(name) [\(range)]" + (result != nil ? " (\(String(describing: result!)))" : ""))
        
        let nextPrefix = prefix + (isLast ? "   " : "│  ")
        for (i, child) in children.enumerated() {
            child.prettyPrint(prefix: nextPrefix, isLast: i == children.count - 1)
        }
    }
}

//
//  ParserDebugging.swift
//  ArborEssence
//
//  Created by Yannis DE CLEENE on 11/06/2025.
//

import Foundation

public protocol ParserDebugging {
    var isEnabled: Bool { get }
    
    func reset()
    func enter(_ name: String, at position: Int, operationType: OperationType)
    func exit(success: Bool, at position: Int, result: Any?)
    func printTree()
}

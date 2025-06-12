//
//  OperationType.swift
//  ArborEssence
//
//  Created by Yannis DE CLEENE on 11/06/2025.
//

import Foundation

public enum OperationType {
    case and
    case or
    case leaf
    
    var symbol: String {
        switch self {
        case .and: return SuccessSymbols.failedLoudly.rawValue
        case .or: return SuccessSymbols.failedSilently.rawValue
        case .leaf: return SuccessSymbols.failedLoudly.rawValue
        }
    }
}

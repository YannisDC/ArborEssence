//
//  TestingGrammar.swift
//  ArborEssence
//
//  Created by Yannis DE CLEENE on 11/06/2025.
//

import Foundation

public class TestingGrammar {
    public func parseLetter(_ letter: Character, _ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("Letter \(letter)", input: input, position: &position, debugger: debugger) { position in
            guard position < input.endIndex, input[position] == letter else {
                return nil
            }
            position = input.index(after: position)
            return String(letter)
        }
    }
    
    public func parseCharacter(_ char: Character, _ input: String, position: inout String.Index, debugger: ParserDebugging) -> Character? {
        return debug("Character \(char)", input: input, position: &position, debugger: debugger) { position in
            guard position < input.endIndex, input[position] == char else {
                return nil
            }
            position = input.index(after: position)
            return char
        }
    }

    /// The AND operation is following the sequential guard structure which returns if not all of them are returning a result
    public func parseAandB(_ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("a and b", input: input, position: &position, debugger: debugger, operationType: .and) { position in
            guard let a = parseLetter("a", input, position: &position, debugger: debugger),
                  let b = parseLetter("b", input, position: &position, debugger: debugger)
            else {
                return nil
            }
            return a + b
        }
    }

    /// The OR operation is following the sequential if let structure which returns the first hit and if no hits are found returns nil
    public func parseAorB(_ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("a or b", input: input, position: &position, debugger: debugger, operationType: .or) { position in
            if let a = parseLetter("a", input, position: &position, debugger: debugger) {
                return a
            }
            
            if let b = parseLetter("b", input, position: &position, debugger: debugger) {
                return b
            }
            
            return nil
        }
    }
    
    /// The ZeroOrMoreOf operation is accumulating the result with a while loop and is not checked afterwards since an empty result is a valid outcome
    func parseZeroOrMoreOfAorB(_ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("(a / b)*", input: input, position: &position, debugger: debugger) { position in
            var result = ""
            while let a = parseAorB(input, position: &position, debugger: debugger) {
                result += a
            }
            return result
        }
    }

    /// The OneOrMoreOf operation is accumulating the result with a while loop and is afterwards checked with a guard to make sure we have at least 1 hit
    public func parseOneOrMoreOfAorB(_ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("(a / b)+", input: input, position: &position, debugger: debugger) { position in
            var result = ""
            while let a = parseAorB(input, position: &position, debugger: debugger) {
                result += a
            }
            guard !result.isEmpty else {
                return nil
            }
            return result
        }
    }
    
    public static func literalMatch(_ literal: String, caseSensitive: Bool = true, _ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("Literal '\(literal)'", input: input, position: &position, debugger: debugger, operationType: .and) { position in
            let endIndex = input.index(position, offsetBy: literal.count, limitedBy: input.endIndex) ?? input.endIndex
            let slice = input[position..<endIndex]
            
            if caseSensitive {
                guard String(slice) == literal else { return nil }
            } else {
                guard String(slice).lowercased() == literal.lowercased() else { return nil }
            }
            
            position = endIndex
            return String(slice)
        }
    }

    public static func rangeMatch(_ range: ClosedRange<Character>, _ input: String, position: inout String.Index, debugger: ParserDebugging) -> String? {
        return debug("Range '\(range.lowerBound)...\(range.upperBound)'", input: input, position: &position, debugger: debugger, operationType: .leaf) { position in
            guard position < input.endIndex,
                  range.contains(input[position]) else {
                return nil
            }
            let result = String(input[position])
            position = input.index(after: position)
            return result
        }
    }
}


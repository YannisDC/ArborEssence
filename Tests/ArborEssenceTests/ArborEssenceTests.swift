import Testing
@testable import ArborEssence

@Test func parse_a_and_b() async throws {
    let input = "ab"
    var position = input.startIndex
    let debugger = ParserDebugger()
    let grammar = TestingGrammar()

    debugger.reset()
    let result = grammar.parseAandB(input, position: &position, debugger: debugger)
    debugger.printTree()
    
    #expect(result == input)
}

@Test func parse_a_or_b() async throws {
    let input = "b"
    var position = input.startIndex
    let debugger = ParserDebugger()
    let grammar = TestingGrammar()

    debugger.reset()
    let result = grammar.parseAorB(input, position: &position, debugger: debugger)
    debugger.printTree()
    
    #expect(result == input)
}

@Test func literalMatch() async throws {
    let input = "Hello123"
    var position = input.startIndex
    let debugger = ParserDebugger()

    debugger.reset()
    let result = TestingGrammar.literalMatch("Hello", caseSensitive: true, input, position: &position, debugger: debugger)
    debugger.printTree()
    
    #expect(result == "Hello")
    #expect(position == input.index(input.startIndex, offsetBy: 5))
}

@Test func nestedMatchFails() async throws {
    let input = "Hello Plant!"
    var position = input.startIndex
    let debugger = RightMostFailureParserDebugger()

    debugger.reset()
    let result = TestingGrammar().parseHelloWorldOrPlanet(input, position: &position, debugger: debugger)
    debugger.printTree()
    
    #expect(result == nil)
    #expect(position == input.index(input.startIndex, offsetBy: 6))
}

@Test func doubleNestedMatch() async throws {
    let input = "Hello You"
    var position = input.startIndex
    let debugger = RightMostFailureParserDebugger()

    debugger.reset()
    let result = TestingGrammar().parseHelloWorldPlanetOrYou(input, position: &position, debugger: debugger)
    debugger.printTree()
    
    #expect(result == "Hello You")
    #expect(position == input.index(input.startIndex, offsetBy: 9))
}

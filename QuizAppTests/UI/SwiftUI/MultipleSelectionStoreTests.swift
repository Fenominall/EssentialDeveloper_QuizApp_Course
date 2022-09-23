//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 9/23/22.
//

import XCTest
@testable import QuizApp

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    var canSubmit: Bool {
        // Cheking if an option was selected to toggle the state of canSubmit
        // The array of options shouldnot be empty
        !options.filter(\.isSelected).isEmpty
    }
    
    init(options: [String]) {
        self.options = options.map({ MultipleSelectionOption(text: $0) })
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    
    mutating func select() {
        isSelected.toggle()
    }
}
 
final class MultipleSelectionStoreTests: XCTestCase {
    
    func test_selectOption_togglesState() {
        var sut = MultipleSelectionStore(options: ["o0, o1"])
        
        // mutating an option within an array
        // when mutated a new value gets assigned to the SUT
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneoptionSelected() {
        var sut = MultipleSelectionStore(options: ["o0, o1"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)

        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
    }
}

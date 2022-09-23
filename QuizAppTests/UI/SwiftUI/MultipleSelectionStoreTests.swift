//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 9/23/22.
//

import XCTest
@testable import QuizApp
 
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
    
    func test_submit_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = MultipleSelectionStore(options: ["o0", "o1"], handler: {
            submittedOptions.append($0)
        })

        sut.submit()
        XCTAssertEqual(submittedOptions, [])
        
        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"]])
        
        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o0"], ["o0", "o1"]])

    }
}

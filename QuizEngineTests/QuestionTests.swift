//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 7/30/22.
//

import XCTest
@testable import QuizEngine

class QuestionTests: XCTestCase {
    func test_hashValue_singleAnswer_returnsTypeHash() {
        let type = "a string"
        
        let sut = Question.singleAnswer(type)
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let type = "a string"
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
}

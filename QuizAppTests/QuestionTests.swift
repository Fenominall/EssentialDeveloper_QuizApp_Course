//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 7/30/22.
//

import XCTest
import QuizEngine
@testable import QuizApp

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
    
    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer("a string"), Question.singleAnswer("a string"))
        XCTAssertEqual(Question.multipleAnswer("a string"), Question.multipleAnswer("a string"))
    }
    
    func test_notEqual_isEqual() {
        XCTAssertNotEqual(Question.singleAnswer("type"), Question.singleAnswer("type1"))
        XCTAssertNotEqual(Question.multipleAnswer("type"), Question.multipleAnswer("type1"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("another string"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("a string"))
    }
}

//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/16/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [] ,router: router)
        
        sut.start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let router = RouterSpy()
        let question1 = "Question1"
        let sut = Flow(questions: [question1], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [question1])
    }
    
    func test_start_withOneQuestion_routesToQuestion_2() {
        let router = RouterSpy()
        let question2 = "Question2"
        let sut = Flow(questions: [question2], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [question2])
    }
    
    func test_start_withTwoQuestion_routesToFirstQuestion() {
        let router = RouterSpy()
        let question1 = "Question1"
        let question2 = "Question2"
        let sut = Flow(questions: [question1 ,question2], router: router)
        
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [question1])
    }
    
    func test_startTwice_withTwoQuestion_routesToFirstQuestionTwice() {
        let router = RouterSpy()
        let question1 = "Question1"
        let question2 = "Question2"
        let sut = Flow(questions: [question1 ,question2], router: router)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, [question1, question1])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_routesToSecondQuestion() {
        let router = RouterSpy()
        let question1 = "Question1"
        let question2 = "Question2"
        let sut = Flow(questions: [question1 ,question2], router: router)
        sut.start()
        
        router.anserCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, [question1, question2])
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var anserCallback: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, anserCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.anserCallback = anserCallback
        }
    }
}

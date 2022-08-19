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
    private var delegate: DelegateSpy!
    private weak var weakSut: Flow<DelegateSpy>?
    
    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        delegate = nil
        XCTAssertNil(weakSut, "Memory leak detected. Weak reference to the SUT instance not nil.")
    }
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        XCTAssertTrue(delegate.delegatedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        let question1 = makeQuestion()
        makeSUT(questions: [question1]).start()
        XCTAssertEqual(delegate.delegatedQuestions, [question1])
    }
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        let question2 = makeQuestion("Q2")
        makeSUT(questions: [question2]).start()
        XCTAssertEqual(delegate.delegatedQuestions, [question2])
    }
    
    func test_start_withTwoQuestions_delegatesQuestionHandling() {
        let questions = makeQuestions()
        makeSUT(questions: questions).start()
        XCTAssertEqual(delegate.delegatedQuestions, [questions[0]])
    }
    
    func test_startTwice_withTwoQuestion_delegatesQuestionHandlingTwice() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.delegatedQuestions, [questions[0], questions[0]])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatsdSecondAndThridQuestionHandling() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.anserCallback("A1")
        delegate.anserCallback("A2")
        
        XCTAssertEqual(delegate.delegatedQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegatsdSecondAndThridQuestionHandling() {
        let question = makeQuestion()
        let sut = makeSUT(questions: [question])
        sut.start()
        
        delegate.anserCallback("A1")
        
        XCTAssertEqual(delegate.delegatedQuestions, [question])
    }
    
    func test_start_withNoQuestions_delegatsdResultHandling() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.delegatedResult?.answers, [:])
    }
    
    func test_startWithOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: [makeQuestion()]).start()
        XCTAssertNil(delegate.delegatedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotDelegateResultHandling() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.anserCallback("A1")
        
        XCTAssertNil(delegate.delegatedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_delegatesResultHandling() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.anserCallback("A1")
        delegate.anserCallback("A2")
        
        XCTAssertEqual(delegate.delegatedResult?.answers, [questions[0]: "A1", questions[1]: "A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { _ in 20 })
        sut.start()
        
        delegate.anserCallback("A1")
        delegate.anserCallback("A2")
        
        XCTAssertEqual(delegate.delegatedResult?.score, 20)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithTheRightAnswer() {
        var receivedAnswers = [String: String]()
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { answers in
            receivedAnswers = answers
            return 20 })
        sut.start()
        
        delegate.anserCallback("A1")
        delegate.anserCallback("A2")
        
        XCTAssertEqual(receivedAnswers, [questions[0]: "A1", questions[1]: "A2"])
    }
    // MARK: - Helpers
    private func makeSUT(questions: [String],
                         scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, router: delegate, scoring: scoring)
        weakSut = sut
        return sut
    }
    
    private func makeQuestion(
        _ question: String = "Q1") -> String {
            question
        }
    
    private func makeQuestions() -> [String] {
        [makeQuestion(), makeQuestion("Q2")]
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var delegatedQuestions: [String] = []
        var delegatedResult: Results<String, String>? = nil
        var anserCallback: (String) -> Void = { _ in }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            delegatedQuestions.append(question)
            self.anserCallback = answerCallback
        }
        
        func handle(result: Results<String, String>) {
            delegatedResult = result
        }
    
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        func routeTo(result: Results<String, String>) {
            handle(result: result)
        }
    }
}

//public func startGame<Question: Hashable, Answer: Equatable>(questions: [Question], router: Router, correctAnswers: [Question: Answer]) {
//
//}

// Possible solutions for creating types
/*
 enum Answer<T> {
 case correct(T)
 case incorrect(T)
 }
 
 protocol ProtoclAnswer {
 var isCorrect: Bool { get }
 }
 
 struct StringAnswer {
 let answer: String
 let isCorrect: Bool
 }
 
 struct Question {
 let isMultipleAnswer: Bool
 }
 */

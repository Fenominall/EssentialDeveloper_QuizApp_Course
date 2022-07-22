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
    var router: RouterSpy!
    
    override func setUp() {
        super.setUp()
        router = RouterSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
    }
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let question1 = makeQuestion()
        makeSUT(questions: [question1]).start()
        XCTAssertEqual(router.routedQuestions, [question1])
    }
    
    func test_start_withOneQuestion_routesToQuestion_2() {
        let question2 = makeQuestion("Q2")
        makeSUT(questions: [question2]).start()
        XCTAssertEqual(router.routedQuestions, [question2])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let questions = makeQuestions()
        makeSUT(questions: questions).start()
        XCTAssertEqual(router.routedQuestions, [questions[0]])
    }
    
    func test_startTwice_withTwoQuestion_routesToFirstQuestionTwice() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, [questions[0], questions[0]])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThridQuestion() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let question = makeQuestion()
        let sut = makeSUT(questions: [question])
        sut.start()
        
        router.anserCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, [question])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult?.answers, [:])
    }
    
    func test_startWithOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: [makeQuestion()]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedResult?.answers, [questions[0]: "A1", questions[1]: "A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { _ in 20 })
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedResult?.score, 20)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithTheRightAnswer() {
        var receivedAnswers = [String: String]()
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { answers in
            receivedAnswers = answers
            return 20 })
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(receivedAnswers, [questions[0]: "A1", questions[1]: "A2"])
    }
    // MARK: - Helpers
    private func makeSUT(questions: [String],
                         scoring: @escaping ([String: String]) -> Int = { _ in return 0 }) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }
    
    private func makeQuestion(
        _ question: String = "Q1") -> String {
            question
        }
    
    private func makeQuestions() -> [String] {
        [makeQuestion(), makeQuestion("Q2")]
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

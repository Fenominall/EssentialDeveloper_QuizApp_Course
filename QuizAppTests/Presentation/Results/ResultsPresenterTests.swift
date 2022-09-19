//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by Vladyslav Todorov on 8/13/22.
//

import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTests: XCTestCase {
    
    func test_title_returnsFormattedTitle() {
        XCTAssertEqual(makeSUT().title, "Result")
    }
    
    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2", "A3"])]
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2", "A3"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 1)
        XCTAssertEqual(sut.summary, "You got 1/2 correct!")
    }
    
    func test_presentableAnswers_empty_shouldBeEmpty() {
        let sut = makeSUT(userAnswers: [], correctAnswers: [])
        XCTAssertTrue(sut.presentableAnswer.isEmpty)
    }
    
    func test_presentableAnswers_withWrongSingleAnswers_mapsAnswers() {
        let answers = [(singleAnswerQuestion, ["A1"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"])]
        let sut = makeSUT(userAnswers: answers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswer.count, 1)
        XCTAssertEqual(sut.presentableAnswer.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswer.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswer.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMutltipeAnswers_mapsAnswers() {
        let userAnswers  = [(multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(multipleAnswerQuestion, ["A2", "A3"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswer.count, 1)
        XCTAssertEqual(sut.presentableAnswer.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswer.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswer.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderdAnswers() {
        let userAnswers = [(singleAnswerQuestion, ["A2"]), (multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"]), (multipleAnswerQuestion, ["A1", "A4"])]
            
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswer.count, 2)
        XCTAssertEqual(sut.presentableAnswer.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswer.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswer.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswer.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswer.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswer.last!.wrongAnswer)
    }
    
    // MARK: - Helpers
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func makeSUT(
        userAnswers: ResultsPresenter.Answers = [],
        correctAnswers: ResultsPresenter.Answers = [],
        score: Int = 0
    ) -> ResultsPresenter {
        ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: { _, _ in score })
    }
}

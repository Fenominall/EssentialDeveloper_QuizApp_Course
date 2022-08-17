//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Vladyslav Todorov on 8/14/22.
//

import XCTest
import QuizEngine
@testable import QuizApp

class QuestionPresenterTests: XCTestCase {
    let question1 = Question.singleAnswer("A1")
    let question2 = Question.multipleAnswer("A2")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], currentQuestion: question1)
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], currentQuestion: question2)
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forUnexsitentQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], currentQuestion: Question.singleAnswer("A1"))
        XCTAssertEqual(sut.title, "")
    }
}

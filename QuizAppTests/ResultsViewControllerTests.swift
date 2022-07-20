//
//  ResultsViewControllerTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 7/19/22.
//

import XCTest
@testable import QuizApp

class ResultsViewControllerTests: XCTestCase {
    func test_viewDidLoad_renderSummary() {
        let sut = makeSut(summary: "a sammary")
        XCTAssertEqual(sut.headerLabel.text, "a sammary")
    }
    
    func test_viewDidLoad_rendersAnswer() {
        XCTAssertEqual(makeSut().numberOfAnswers(), 0)
        XCTAssertEqual(makeSut(answers: [makeDummyAnswer()]).numberOfAnswers(), 1)
    }

    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1", isCorrect: true)
        let sut = makeSut(answers: [answer])
        
        let cell = sut.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_rendersWrongAnswerCell() {
        let sut = makeSut(answers: [makeAnswer(isCorrect: false)])
        
        let cell = sut.cell(at: 0) as? WrongAnswerCell
        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1", isCorrect: false)
        let sut = makeSut(answers: [answer])
        
        let cell = sut.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
    }
    
  
    // MARK: - Helpers
    private func makeSut(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        return sut
    }
    
    private func makeDummyAnswer() -> PresentableAnswer {
        makeAnswer(isCorrect: false)
    }
    
    private func makeAnswer(question: String = "", answer: String = "",  isCorrect: Bool) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, isCorrect: isCorrect)
    }
}

private extension ResultsViewController {
    func numberOfAnswers() -> Int {
        tableView.numberOfRows(inSection: answersSection)
    }
    
    func cell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: answersSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    private var answersSection: Int { 0 }
}

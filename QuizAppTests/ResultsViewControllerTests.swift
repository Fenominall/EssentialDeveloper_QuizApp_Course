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
        let header = sut.header() as? ResultsTableHeader
        XCTAssertEqual(header?.summaryLabel.text, "a sammary")
    }
    
    func test_viewDidLoad_rendersAnswer() {
        XCTAssertEqual(makeSut().numberOfAnswers(), 0)
        XCTAssertEqual(makeSut(answers: [makeAnswer()]).numberOfAnswers(), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1")
        let sut = makeSut(answers: [answer])
        
        let cell = sut.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "wrong")
        let sut = makeSut(answers: [answer])
        
        let cell = sut.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "wrong")
    }
    
    
    // MARK: - Helpers
    private func makeSut(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        return sut
    }
        
    private func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil, isCorrect: Bool = false) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
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
    
    func header() -> UIView? {
        tableView(tableView, viewForHeaderInSection: 0)
    }
    
    private var answersSection: Int { 0 }
}

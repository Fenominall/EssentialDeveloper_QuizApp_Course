//
//  QuizAppTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 7/17/22.
//

import XCTest
@testable import QuizApp

class QuestionViewControllerTests: XCTestCase {
    func test_viewDidLoad_renderQuestionHeaderText() {
        let sut = makeSut(question: "Q1")
        let header = sut.header() as? QuestionTableHeader
        XCTAssertEqual(header?.questionLabel.text, "Q1")
    }

    func test_viewDidLoad_renderOptions() {
        XCTAssertEqual(makeSut(options: []).numberOfOptions(), 0)
        XCTAssertEqual(makeSut(options: ["A1"]).numberOfOptions(), 1)
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).numberOfOptions(), 2)
        
    }
    
    func test_viewDidLoad_rendersOneOptionText() {
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).title(at: 0), "A1")
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).title(at: 1), "A2")
    }

    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { receivedAnswer = $0 }
        
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSut(options: ["A1", "A2"]) { _ in
            callbackCount += 1
        }
        sut.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateWithSelection() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        sut.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegateWith() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        sut.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: - Helpers
    private func makeSut(question: String = "",
                         options: [String] = [],
                         selection: @escaping ([String]) -> Void = { _ in }
    ) -> QuestionViewController {
        let sut = QuestionViewController(
            question: question,
            options: options,
            selection: selection)
        sut.loadViewIfNeeded()
        return sut
    }
}

private extension QuestionViewController {

    func numberOfOptions() -> Int {
        tableView.numberOfRows(inSection: optionsSection)
    }
    
    func title(at row: Int) -> String? {
        optionCell(at: row)?.textLabel?.text
    }
    
    func optionCell(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: optionsSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: optionsSection)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: optionsSection)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    func header() -> UIView? {
        tableView(tableView, viewForHeaderInSection: 0)
    }
    
    private var optionsSection: Int {
        0
    }
}

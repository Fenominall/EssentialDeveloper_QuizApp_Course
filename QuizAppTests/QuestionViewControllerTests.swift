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
        XCTAssertEqual(makeSut(options: ["A1", "A2"]).title(at: 1), "A2")
    }

    func test_viewDidLoad_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSut(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.allowsMultipleSelection)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSut(options: ["A1", "A2"], allowsMultipleSelection: true).tableView.allowsMultipleSelection)
    }

    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"], allowsMultipleSelection: false) { receivedAnswer = $0 }
        
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSut(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in
            callbackCount += 1
        }
        sut.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateWithSelection() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        sut.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegateWith() {
        var receivedAnswer = [String]()
        let sut = makeSut(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        sut.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        sut.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: - Helpers
    private func makeSut(question: String = "",
                         options: [String] = [],
                         allowsMultipleSelection: Bool = false,
                         selection: @escaping ([String]) -> Void = { _ in }
    ) -> QuestionViewController {
        let sut = QuestionViewController(
            question: question,
            options: options,
            allowsMultipleSelection: allowsMultipleSelection,
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
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath(row))
    }
    
    func select(row: Int) {
        let indexPath = indexPath(row)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = indexPath(row)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    func header() -> UIView? {
        tableView(tableView, viewForHeaderInSection: 0)
    }
    
    private var optionsSection: Int {
        0
    }
    
    private func indexPath(_ row: Int) -> IndexPath {
        IndexPath(row: row, section: optionsSection)
    }
}

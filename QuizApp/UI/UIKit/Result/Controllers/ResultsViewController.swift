//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Fenominall on 7/19/22.
//

import Foundation
import UIKit

class ResultsViewController: UITableViewController {
    
    private(set) var summary = ""
    private(set) var answers = [PresentableAnswer]()
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
        tableView.register(ResultsTableHeader.self)
    }
}

extension ResultsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        return answer.wrongAnswer == nil ?
        correctAnswerCell(for: answer) : wrongAnswerCell(for: answer)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeader()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        answers[indexPath.row].wrongAnswer == nil ? 90 : 100
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        answers[indexPath.row].wrongAnswer == nil ? 90 : 100
    }
    
    // MARK: - Helpers
    private func tableViewHeader() -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(ResultsTableHeader.self)!
        header.summaryLabel.text = summary
        return header
    }
    
    private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
    
    private func wrongAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WrongAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        cell.wrongAnswerLabel.text = answer.wrongAnswer
        return cell
    }
}

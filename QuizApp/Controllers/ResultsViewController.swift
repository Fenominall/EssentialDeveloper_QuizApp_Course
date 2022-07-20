//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Fenominall on 7/19/22.
//

import Foundation
import UIKit

class ResultsViewController: UITableViewController {
    
    private var summary = ""
    private var answers = [PresentableAnswer]()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        headerLabel.text = summary
        tableView.register(CorrectAnswerCell.self, forCellReuseIdentifier: CorrectAnswerCell.cellIdentifier)
        tableView.register(WrongAnswerCell.self, forCellReuseIdentifier: WrongAnswerCell.cellIdentifier)
    }
    
}

extension ResultsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.isCorrect {
            return correctAnswerCell(for: answer)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: WrongAnswerCell.cellIdentifier) as! WrongAnswerCell
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        return cell
    }
    
    private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CorrectAnswerCell.cellIdentifier) as! CorrectAnswerCell
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
}

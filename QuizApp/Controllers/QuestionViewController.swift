//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Fenominall on 7/17/22.
//

import Foundation
import UIKit

class QuestionViewController: UITableViewController {
    private var question = ""
    private var options = [String]()
    private var selection: (([String])-> Void)?

    init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.question = question
        self.options = options
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(QuestionTableHeader.self)
    }
}

// MARK: - UITableViewDataSource
extension QuestionViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    private func dequeCell(in tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(UITableViewCell.self)
        else {
            return UITableViewCell(style: .default,
                                   reuseIdentifier: String(describing: QuestionViewController.self))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        150
    }
    
    private func tableHeaderView() -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(QuestionTableHeader.self)!
        header.setHeaderText(question)
        return header
    }
}

// MARK: - UITableViewDelegate
extension QuestionViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPath = tableView.indexPathsForSelectedRows else { return [] }
        return indexPath.map({ options[$0.row] })
    }
}

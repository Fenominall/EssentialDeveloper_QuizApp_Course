//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Fenominall on 7/17/22.
//

import Foundation
import UIKit

class QuestionViewController: UITableViewController {
    
    private let reusableIdentifier = "reusableIdentifier"
    private var question = ""
    private var options = [String]()
    private var selection: (([String])-> Void)?
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(question: String, options: [String], selection: @escaping ([String]) -> Void) {
        self.question = question
        self.options = options
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        headerLabel.text = question
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        tableView.allowsMultipleSelection = false
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
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
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: reusableIdentifier)
        else {
            return UITableViewCell(style: .default,
                                   reuseIdentifier: reusableIdentifier)
        }
        return cell
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

//
//  QuestionTableHeader.swift
//  QuizApp
//
//  Created by Fenominall on 7/20/22.
//

import UIKit

class QuestionTableHeader: UITableViewHeaderFooterView {
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 15)
        ])
    }
}

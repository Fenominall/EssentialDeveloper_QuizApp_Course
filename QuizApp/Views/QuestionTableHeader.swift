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
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

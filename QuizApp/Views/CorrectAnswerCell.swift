//
//  CorrectAnswerCell.swift
//  QuizApp
//
//  Created by Fenominall on 7/20/22.
//

import Foundation
import UIKit

class CorrectAnswerCell: UITableViewCell {
    static let cellIdentifier = "correctAnswerCellIdentifier"
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

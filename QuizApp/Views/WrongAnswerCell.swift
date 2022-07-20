//
//  WrongAnswerCell.swift
//  QuizApp
//
//  Created by Fenominall on 7/20/22.
//

import Foundation
import UIKit

class WrongAnswerCell: UITableViewCell {
    static let cellIdentifier = "wrongAnswerCellIdentifier"
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var correctAnswerLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

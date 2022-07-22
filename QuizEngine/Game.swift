//
//  Game.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

import Foundation

public func startGame<Question, Answer, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {
    
}


//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Vladyslav Todorov on 8/13/22.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    let result: Results<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    
    var title: String {
        return "Result"
    }
    
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct!"
    }
    
    var presentableAnswer: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = result.answers[question],
                  let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn`t find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswer, correctAnswer)
        }
    }
    
    private func presentableAnswer(
        _ question: Question<String>,
        _ userAnswer: [String],
        _ correctAnswer: [String]) -> PresentableAnswer {
            switch question {
            case .singleAnswer(let value), .multipleAnswer(let value):
                return PresentableAnswer(
                    question: value,
                    answer: formattedAnswer(correctAnswer),
                    wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
            }
        }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(
        _ userAnswer: [String],
        _ correctAnswer: [String]) -> String? {
            return correctAnswer == userAnswer
            ? nil : formattedAnswer(userAnswer)
        }
}

//
//  Router.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

import Foundation

public protocol QuizDelegate {
    // Adding associatedtype for more geneirc flow, the questions and answers can be not only Strings, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer
    
    // Data Soruce //asks syncronously
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    // The same as func handle(question: Question) -> Answer // asks syncronously
    func handle(result: Results<Question, Answer>)
}



//// delegate
//func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {
//    
//}

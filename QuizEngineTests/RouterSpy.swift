//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/22/22.
//

import Foundation
import QuizEngine

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResult: Result<String, String>? = nil
    var anserCallback: (String) -> Void = { _ in }
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.anserCallback = answerCallback
    }
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}

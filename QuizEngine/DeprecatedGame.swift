//
//  Game.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

// Depricating for changes to let the client migrate with no issues
@available(*, deprecated)
public protocol Router {
    // Adding associatedtype for more geneirc flow, the questions and answers can be not only Strings, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer: Equatable
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Results<Question, Answer>)
}

import Foundation

@available(*, deprecated)
public class Game <Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer, R: Router>
(questions: [Question],
 router: R,
 correctAnswers: [Question: Answer]) ->Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer{
    let flow = Flow(
        questions: questions,
        delegate: QuizDelegateToRouterAdapter(router: router),
        scoring: { scoring($0, correctAnswers: correctAnswers) })
    flow.start()
    return Game(flow: flow)
}

// Private adapter for forwarding messages to and oldAPI with new API
@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R
    
    init(router: R) {
        self.router = router
    }
    
    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func handle(result: Results<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }
}

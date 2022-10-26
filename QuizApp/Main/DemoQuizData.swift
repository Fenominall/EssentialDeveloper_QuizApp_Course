//
//  DemoQuizData.swift
//  QuizApp
//
//  Created by Vladislav Todorov on 10/26/22.
//

import BasicQuizDomain


let demoQuiz = try! BasicQuizBuilder(
    singleAnswerQuestion: "Can Vlad become a professional iOS delevoper?",
    options: .init(
        head: "He is already on it`s way!",
        tail: [ "May be!", "Try it!"]),
    answer: "He is already on it`s way!")
    .adding(
        multipleAnswerQuestion: "I am a Boss?",
        options: .init(head: "OF Course!", tail: ["NOOO!", "Sure You are the Best!"]),
        answer: .init(head: "OF Course!", tail: ["Sure You are the Best!"]))
    .build()

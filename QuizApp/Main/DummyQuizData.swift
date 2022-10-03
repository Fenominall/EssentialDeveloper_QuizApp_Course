//
//  DummyQuizData.swift
//  QuizApp
//
//  Created by Fenominall on 10/2/22.
//

import QuizEngine

let question1 = Question.singleAnswer("Can Vlad become a professional iOS delevoper?")
let question2 = Question.multipleAnswer("I am a Boss?")
let questions = [question1, question2]

let option1 = "He is already on it`s way!"
let option2 = "May be!"
let option3 = "Try it!"
let options1 = [option1, option2, option3]

let option4 = "OF Course!"
let option5 = "May!"
let option6 = "Try!"
let options2 = [option4, option5, option6]
let options = [question1: options1, question2: options2]
let correctAnswers = [(question1, [option1]), (question2, [option4, option6])]

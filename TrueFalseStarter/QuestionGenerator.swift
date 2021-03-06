//
//  QuestionGenerator.swift
//  TrueFalseStarter
//
//  Created by Taylor Smith on 3/5/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import GameKit

//created a struct for the questions and answers in it's own .swift file

struct Questions {
    let question: String
    let possibleAnswers: [String]
    let correctAnswer: Int
    
}

var trivia: [Questions] = [
    Questions(question: "This was the only US President to serve more than two consecutive terms.", possibleAnswers: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], correctAnswer: 2),
    Questions(question: "Which of the following countries has the most residents?", possibleAnswers: ["Nigeria", "Russia", "Iran", "Vietnam"], correctAnswer: 1),
    Questions(question: "In what year was the United Nations found?", possibleAnswers: ["1918", "1919", "1945", "1954"], correctAnswer: 3),
    Questions(question: "The Titanic departed from the United Kingdom, where was it suppose to arrive?", possibleAnswers: ["Paris", "Washington D.C.", "New York City", "Boston"], correctAnswer: 3),
    Questions(question: "Which nation produces the most oil?", possibleAnswers: ["Iran", "Iraq", "Brazil", "Canada"], correctAnswer: 3),
     Questions(question: "Kobe Bryant was originally drafted by which team?", possibleAnswers: ["Lakers", "Hornets", "Jazz"], correctAnswer: 2),
     Questions(question: "Which Bear is best?", possibleAnswers: ["Black Bear", "Brown Bear", "Polar Bear"], correctAnswer: 1),
    Questions(question: "How many games are in the NBA regular season?", possibleAnswers: ["81", "74", "82"], correctAnswer: 3)
]

// assigns "trivia" to another array so I can keep track of questions that have already appeared
var triviaIndexArray: [Questions] = []

//resets the array after each game so that there are "fresh" questions
func resetQuestions() {
    triviaIndexArray = []
    for question in trivia {
        triviaIndexArray.append(question)
    }
}

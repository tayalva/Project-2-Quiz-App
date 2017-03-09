//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 5
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var incorrectSound: SystemSoundID = 2
    var timer: Timer!
    var timerCount = 15
    
// linked each new "answer" button to the view controller:
    
    @IBOutlet weak var questionField: UILabel!

    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

   
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameStartSound()
        loadCorrectSound()
        loadIncorrectSound()
        // Starts game with a sound, resetting the questions array, and displaying the first question
        playGameStartSound()
        resetQuestions()
        displayQuestion()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Made changes so that each question has 4 buttons, displaying the correct possible answers for each question
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaIndexArray.count)
        let questionDictionary = triviaIndexArray[indexOfSelectedQuestion]
        answer1.setTitle(questionDictionary.possibleAnswers[0], for: .normal)
        answer2.setTitle(questionDictionary.possibleAnswers[1], for: .normal)
        answer3.setTitle(questionDictionary.possibleAnswers[2], for: .normal)
        
    // checks to see if there are 3 or 4 possible answers
        
        if questionDictionary.possibleAnswers.count == 3 {
            
            answer4.isHidden = true
           
            
        } else {
        answer4.setTitle(questionDictionary.possibleAnswers[3], for: .normal)
            answer4.isHidden = false
        }
        
        timerLabel.isHidden = false
        timerCount = 15
        timerLabel.text = "\(timerCount)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(endTimer), userInfo: nil, repeats: true)
        
        questionField.text = questionDictionary.question
        playAgainButton.isHidden = true
       
    }
    
    // Timer and conditions when it gets to zero
    func endTimer(timer:Timer) {
        
        let selectedQuestionDict = triviaIndexArray[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.correctAnswer
    
        if timerCount <= 0 {
            questionsAsked += 1
            timer.invalidate()
            timerLabel.isHidden = true
            playInccorectSound()
            questionField.text = "Sorry, wrong answer! the correct answer is: \(selectedQuestionDict.possibleAnswers[correctAnswer - 1])"
            triviaIndexArray.remove(at: indexOfSelectedQuestion)
            loadNextRoundWithDelay(seconds: 2)
        } else {
            timerLabel.text = "\(timerCount)"
            timerCount -= 1
        }
        
    }
    
    func displayScore() {
        // Hide the answer buttons
        answer1.isHidden = true
        answer2.isHidden = true
        answer3.isHidden = true
        answer4.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    
// When an answer button is pushed, this checks to see if it is correct
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = triviaIndexArray[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.correctAnswer
        
// changed logic for all 4 answers instead of 2. also, they had objective c syntax with "===" instead of "==", so I made that uniform
        
        if (sender == answer1 && correctAnswer == 1) || (sender == answer2 && correctAnswer == 2) || (sender == answer3 && correctAnswer == 3) || (sender === answer4 && correctAnswer == 4) {
            correctQuestions += 1
            questionField.text = "Correct!"
            playCorrectSound()
        } else {
//displays correct answer when wrong answer is selected
              playInccorectSound()
            questionField.text = "Sorry, wrong answer! the correct answer is: \(selectedQuestionDict.possibleAnswers[correctAnswer - 1])"
        }
        timerLabel.isHidden = true
        timer.invalidate()
    triviaIndexArray.remove(at: indexOfSelectedQuestion)
    loadNextRoundWithDelay(seconds: 2)
    }
    

    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            resetQuestions()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        answer1.isHidden = false
        answer2.isHidden = false
        answer3.isHidden = false
        answer4.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        
    }
    
    func loadCorrectSound() {
        
        let pathToSoundFile = Bundle.main.path(forResource: "Correct", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctSound)
}
    
    func loadIncorrectSound() {
        
        let pathToSoundFile = Bundle.main.path(forResource: "Incorrect", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &incorrectSound)
    }
    
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playCorrectSound () {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playInccorectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
        
    
        
}


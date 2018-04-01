//
//  ViewController.swift
//  Apple Pie
//
//  Created by Stas on 01.04.2018.
//  Copyright © 2018 Stas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var treeImageView: UIImageView!
    
    @IBOutlet weak var correctWordLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateUI()
        updateGameState()
    }
    
    let incorrectMovesAllowed = 7
    let delay = 2.5
    
    var totalWins = 0 {
        didSet {
            enableLetterButtons(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.newRound()
            })
        }
    }
    var totalLoses = 0 {
        didSet {
            enableLetterButtons(false)
            currentGame.formattedWord = currentGame.word
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.newRound()
            })
        }
    }
    
    var currentGame: Game!
    
    func newRound() {
        if listOfWords.isEmpty {
            listOfWords = listOfNames
        }
        enableLetterButtons(true)
        let randomIndex = arc4random_uniform(UInt32(listOfWords.count))
        let newWord = listOfWords.remove(at: Int(randomIndex))
        currentGame = Game(word: newWord.lowercased(), incorrectMovesRemaning: incorrectMovesAllowed, guessedLetters: [])
        updateUI()
    }
    
    func enableLetterButtons(_ enable:Bool) {
        for view in view.subviews {
            enableButtons(enable, in: view)
        }
    }
    
    func enableButtons(_ enable: Bool, in view: Any) {
        if view is UIButton {
            (view as! UIButton).isEnabled = enable
        } else if view is UIStackView {
            for subview in (view as! UIStackView).subviews {
                enableButtons(enable, in: subview)
            }
        }
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaning < 1 {
            totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        }
        updateUI()
        
    }
    
    func updateUI() {
        let apples = currentGame.incorrectMovesRemaning
        treeImageView.image = UIImage(named: "Tree \(apples)")
        
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        letters[0] = letters[0].uppercased()
        let wordWithSpacing = letters.joined(separator: " ")
        
        scoreLabel.text = "Выигрыши: \(totalWins), Проигрыши: \(totalLoses)"
        correctWordLabel.text = wordWithSpacing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


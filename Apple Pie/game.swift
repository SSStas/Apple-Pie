//
//  game.swift
//  Apple Pie
//
//  Created by Stas on 01.04.2018.
//  Copyright © 2018 Stas. All rights reserved.
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemaning: Int
    var guessedLetters: [Character]
    var formattedWord: String {
        get {
            var guessedWord = ""
            
            for letter in word {
                if guessedLetters.contains(letter) {
                    guessedWord += "\(letter)"
                } else {
                    guessedWord += "_"
                }
            }
            
            return guessedWord
        }
        
        set {
            for letter in newValue {
                playerGuessed(letter: letter)
            }
        }
    }
    
    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaning -= 1
        }
    }
}

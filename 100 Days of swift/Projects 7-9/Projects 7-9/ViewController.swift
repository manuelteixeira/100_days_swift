//
//  ViewController.swift
//  Projects 7-9
//
//  Created by Manuel Teixeira on 15/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentAnswer: UITextField!
    var addGuessButton: UIButton!
    var incorrectGuessesLabel: UILabel!
    var emojiLabel: UILabel!
    
    let maxGuesses = 7
    var wordsToGuess = [String]()
    var usedLetters = ""
    var activeWordToGuess = ""
    var level = 0
    var incorrectGuesses = 0 {
        didSet {
            incorrectGuessesLabel.text = "You have \(maxGuesses - incorrectGuesses) guesses left"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        addGuessButton = UIButton()
        addGuessButton.translatesAutoresizingMaskIntoConstraints = false
        addGuessButton.setTitle("Add Guess", for: .normal)
        addGuessButton.setTitleColor(.darkGray, for: .normal)
        addGuessButton.addTarget(self, action: #selector(addGuessButtonTapped), for: .touchUpInside)
        view.addSubview(addGuessButton)
        
        incorrectGuessesLabel = UILabel()
        incorrectGuessesLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectGuessesLabel.textColor = .systemRed
        incorrectGuessesLabel.font = UIFont.systemFont(ofSize: 17)
        incorrectGuessesLabel.text = "You have \(maxGuesses - incorrectGuesses) guesses left"
        view.addSubview(incorrectGuessesLabel)
        
        emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "🤔"
        emojiLabel.font = UIFont.systemFont(ofSize: 84)
        view.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currentAnswer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            currentAnswer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            incorrectGuessesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            incorrectGuessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
                        
            addGuessButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            addGuessButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            emojiLabel.bottomAnchor.constraint(equalTo: currentAnswer.topAnchor, constant: -40),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(importWords), with: nil)
    }

    @objc func importWords() {
        
        guard
            let levelFileURL = Bundle.main.url(forResource: "city_names", withExtension: "txt"),
            let data = try? String(contentsOf: levelFileURL)
        else {
            let errorMessage = "Couldn't import words from file"
            
            DispatchQueue.main.async { [weak self] in
                self?.showError(message: errorMessage)
            }
            
            return
        }
        
        let words = data.components(separatedBy: "\n")
        
        for word in words {
            if !word.isEmpty {
                wordsToGuess.append(word.lowercased())
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.loadLevel()
        }
    }
    
    func loadLevel() {
        
        activeWordToGuess = wordsToGuess[level]
        
        var hiddenString = ""
        for _ in activeWordToGuess {
            hiddenString += "?"
        }
        
        currentAnswer.text = hiddenString
        
    }
    
    @objc func addGuessButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Make a guess", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let action = UIAlertAction(title: "Add guess", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard
                let guess = alertController.textFields?[0].text,
                guess.count == 1
            else {
                self.showError(message: "Hey, it's must be only ONE letter guess")
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.checkGuess(guess.lowercased())
            }
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func checkGuess(_ guess: String) {
        if activeWordToGuess.contains(guess) {
            
            usedLetters.append(guess)
            var text = ""
            
            for activeWordLetter in activeWordToGuess {
                let stringActiveWordLetter = String(activeWordLetter)
                
                if usedLetters.contains(stringActiveWordLetter) {
                    text.append(stringActiveWordLetter)
                } else {
                    text.append("?")
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.currentAnswer.text = text
                
                if !text.contains("?") {
                    self?.showMessage(message: "You WIN!")
                    self?.level += 1
                    self?.usedLetters.removeAll()
                    self?.incorrectGuesses = 0
                    self?.loadLevel()
                }
            }
            
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.incorrectGuesses += 1
                
                if self?.incorrectGuesses == 7 {
                    self?.showMessage(message: "Game OVER!")
                    self?.level = 0
                    self?.usedLetters.removeAll()
                    self?.incorrectGuesses = 0
                    self?.loadLevel()
                }
                
                self?.showMessage(message: "Oops, try again!")
            }
        }
    }
    
    func showError(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showMessage(title: String = "Message", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}


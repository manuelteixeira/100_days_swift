//
//  ViewController.swift
//  Project2
//
//  Created by Manuel Teixeira on 24/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
                
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action:  #selector(showScore))
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) - score: \(score)"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { finished in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag].capitalized)"
            score -= 1
        }
        
        var message = "Your score is \(score)"
        
        questionsCount += 1
        
        if questionsCount == 10 {
            title = "You have answered \(questionsCount) questions"
            message = "Your final score is \(score)"
            
            resetGame()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(alertController, animated: true)
    }
    
    func resetGame() {
        questionsCount = 0
        score = 0
    }
    
    @objc func showScore() {
        let title = "Score"
        let message = "Your score is \(score)"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}


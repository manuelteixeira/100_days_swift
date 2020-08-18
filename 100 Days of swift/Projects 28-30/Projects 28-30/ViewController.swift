//
//  ViewController.swift
//  Projects 28-30
//
//  Created by Manuel Teixeira on 12/08/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var countries = [Country]()
    let maxCountries = 8
    var firstSelected: UIButton?
    var countriesAndCapitalNames = [String]()
    var cards = [UIButton]()
    var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonView()
        loadCapitals()
        loadLevel()
    }
}

extension ViewController {
    
    private func setupButtonView() {
        buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        NSLayoutConstraint.activate([
            buttonView.widthAnchor.constraint(equalToConstant: 750),
            buttonView.heightAnchor.constraint(equalToConstant: 750),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.titleLabel?.layer.opacity = 1
        
        if firstSelected == nil {
            firstSelected = sender
            return
        }
        
        checkIfCorrect(value: sender)
    }
}

extension ViewController {
    
    private func loadCapitals() {
        if let path = Bundle.main.path(forResource: "capitals", ofType: "json") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError("Couldn't decode") }
            
            let decoder = JSONDecoder()
            guard let countries = try? decoder.decode([Country].self, from: data) else { fatalError("Couldn't convert") }
            
            self.countries = countries
        }
    }
    
    func loadLevel() {
        let shuffledCountries = countries.shuffled().prefix(maxCountries)
        
        shuffledCountries.forEach({
            countriesAndCapitalNames.append($0.countryName)
            countriesAndCapitalNames.append($0.capitalName)
        })
        
        countriesAndCapitalNames.shuffle()

        for row in 0..<4 {
            for col in 0..<4 {
                let countryButton = UIButton()
                
                countryButton.backgroundColor = UIColor(red: 221/255, green: 243/255, blue: 245/255, alpha: 1)
                countryButton.layer.borderWidth = 1
                countryButton.layer.borderColor = UIColor(red: 166/255, green: 220/255, blue: 239/255, alpha: 1).cgColor
                countryButton.layer.cornerRadius = 40
                
                countryButton.frame = CGRect(x: row * 200, y: col * 200, width: 150, height: 150)
                countryButton.setTitleColor(UIColor(red: 227/255, green: 99/255, blue: 135/255, alpha: 1), for: .normal)
                countryButton.titleLabel?.layer.opacity = 0

                countryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

                cards.append(countryButton)
                buttonView.addSubview(countryButton)
            }
        }
        
        addButtonsToView()
    }
    
    private func addButtonsToView() {
        for i in 0 ..< cards.count {
            cards[i].setTitle(countriesAndCapitalNames[i], for: .normal)
        }
    }
}

extension ViewController {
    
    func checkIfCorrect(value: UIButton) {
        
        guard
            let firstButton = firstSelected,
            let title = firstButton.title(for: .normal),
            let secondTitle = value.title(for: .normal)
        else { return }
        
        let country = countries.first {
            ($0.capitalName == title && $0.countryName == secondTitle)
            ||
            ($0.countryName == title && $0.capitalName == secondTitle)
        }
        
        if country != nil {
            
            UIView.animate(withDuration: 2, animations: {
                firstButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                value.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { [weak self] _ in
                
                guard let self = self else { return }
                
                firstButton.removeFromSuperview()
                value.removeFromSuperview()
                
                self.cards.removeAll { $0.titleLabel == firstButton.titleLabel }
                self.cards.removeAll { $0.titleLabel == value.titleLabel }
                
                // No more cards - end game
                if self.cards.isEmpty {
                    let ac = UIAlertController(title: "YOU WIN!", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(ac, animated: true)
                }
            }

            firstSelected = nil
        } else {
            // Turn the buttons again
            firstSelected = nil
            
            UIView.animate(withDuration: 1) {
                firstButton.titleLabel?.layer.opacity = 0
                value.titleLabel?.layer.opacity = 0
            }
        }
    }
}

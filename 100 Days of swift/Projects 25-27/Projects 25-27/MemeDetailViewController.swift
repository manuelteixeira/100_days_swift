//
//  MemeDetailViewController.swift
//  Projects 25-27
//
//  Created by Manuel Teixeira on 20/07/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.largeTitleDisplayMode = .never
        
        image.image = generateMeme(from: meme)
    }

}

extension MemeDetailViewController {
    @objc private func shareImage() {
        let activityController = UIActivityViewController(activityItems: [image.image], applicationActivities: [])
        
        present(activityController, animated: true)
    }
    
    private func generateMeme(from meme: Meme) -> UIImage {
        guard let memeImage = meme.image else { return UIImage() }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: view.bounds.width, height: view.bounds.height))
        
        let finalImage = renderer.image { context in
            
            memeImage.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: 5,
                .paragraphStyle: paragraphStyle
            ]

            if let topText = meme.topMessage {
                let attributedTopString = NSAttributedString(string: topText, attributes: attributes)
                attributedTopString.draw(with: CGRect(x: 0, y: 32, width: 400, height: 300), options: .usesLineFragmentOrigin, context: nil)

            }

            if let bottomText = meme.bottomMessage {
                let attributedBottomString = NSAttributedString(string: bottomText, attributes: attributes)
                attributedBottomString.draw(with: CGRect(x: 0, y: memeImage.size.height - 50, width: 400, height: 300), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        return finalImage
    }
}

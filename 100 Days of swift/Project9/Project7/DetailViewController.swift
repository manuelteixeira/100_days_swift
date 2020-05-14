//
//  DetailViewController.swift
//  Project7
//
//  Created by Manuel Teixeira on 08/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <style> body { font-size: 150% } h1 { color: green; font-size: 180% } </style>
        </head>
        <body>
        <h1>\(detailItem.title)</h1>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}

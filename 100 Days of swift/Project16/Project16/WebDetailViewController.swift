//
//  WebDetailViewController.swift
//  Project16
//
//  Created by Manuel Teixeira on 07/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import WebKit

class WebDetailViewController: UIViewController {
    var capital: Capital!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        view = webView
        
        guard
            let capitalName = capital.title,
            let url = URL(string: "https://en.wikipedia.org/wiki/\(capitalName)")
        else { return }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

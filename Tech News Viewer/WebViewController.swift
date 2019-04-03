//
//  WebViewController.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 02/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView =  WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

}

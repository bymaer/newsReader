//
//  WebViewController.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/5/23.
//

import Foundation

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: URL!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
    }
}

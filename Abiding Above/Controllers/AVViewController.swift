//
//  AVViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit
import WebKit

class AVViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        
        // Send user to the AV page of Abiding Above website
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // TODO: Setup loading icon on the screen when waiting for webpage to load

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Setup to handle error if URL ever changes
        let url = URL(string: "https://abidingabove.org/index.php/aamsermons/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    override func viewWillAppear(_ animated: Bool) {
        // Set tabBar back to default so that it will be more visible with website content
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundImage = nil
        tabBarController?.tabBar.shadowImage = nil
        tabBarController?.tabBar.clipsToBounds = false
    }
}

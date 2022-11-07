//
//  NewsletterViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        if parent != nil && navigationItem.titleView == nil {
            navigationControllerSetup()
        }
        
        
        loadRequest(with: urlString!)
    }
  
    func navigationControllerSetup() {
        
            // Put the logo in the navigation bar
            let logo = UIImage(named: "logoNavBar")
            let imageView = UIImageView(image: logo)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(homeTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(recognizer)
        
    }
    
    
    @objc private func homeTapped(_ recognizer: UITapGestureRecognizer) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Set tabBar back to default so that it will be more visible with website content
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.backgroundImage = nil
        tabBarController?.tabBar.shadowImage = nil
        tabBarController?.tabBar.clipsToBounds = false
        
        
        // Start the load spinner
        spinner.alpha = 1
        spinner.startAnimating()
        
    }
    
    func loadRequest(with urlString: String) {
        
        let url = URL(string: urlString)
        guard url != nil else {return}
        let request = URLRequest(url: url!)
        
        // Load the request
        webView.load(request)
        
    }
    
    // Setup functionality to allow web navigation
    @objc func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
}
// MARK: - Navigation Delegates

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Stop the spinner and hide it
        spinner.stopAnimating()
        spinner.alpha = 0
        
        // Display the "Back" button in navigation bar only if going back is an option
        if webView.canGoBack {
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = false
        }
        
        // MARK: - JavaScript injection for setting up style of webView
        
        let javaScript = [
            "document.body.style.backgroundColor = '#F5F0EB'",
            "document.querySelector('.site-header').remove()",
            "document.querySelector('.nav-backed-header').remove()",
            "document.querySelector('.col-md-3').remove()",
            "document.querySelector('.site-footer').remove()",
            "document.querySelector('.site-footer-bottom').remove()",
            "document.querySelector('.page-content.margin-20 > p').remove()",
            "document.querySelector('.share-bar').remove()"
        ]
        
        
        for item in javaScript {
            webView.evaluateJavaScript(item ,
                                       completionHandler: { (html: Any?, error: Error?) in
            })
        }
 
       // Reset the webView to visible once webpage is loaded and javascript has run to setup the webView style
        webView.alpha = 1
        
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Start the load spinner
        spinner.alpha = 1
        spinner.startAnimating()
        
        
        // Make webView invisible while javascript is deleting some aspects and changing some style options, so the user doesn't see these things happening in real time.
        webView.alpha = 0
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let externalLinks = [
            "http://ubdavid.org/",
            "http://www.emmausworldwide.org/",
            "https://t4tonline.org/",
            "https://abidingabove.org/index.php/bible-lesson-sign-up/"]
        
        if let urlString = navigationAction.request.url?.absoluteString {
            
            if externalLinks.contains(urlString) {
                decisionHandler(.cancel)
                UIApplication.shared.open(navigationAction.request.url!)
            } else {
                decisionHandler(.allow)
            }
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
               frame.isMainFrame {
               return nil
           }
           webView.load(navigationAction.request)
           return nil
    }
   
}

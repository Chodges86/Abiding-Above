//
//  NewsletterViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 10/20/21.
//

import UIKit
import WebKit

class NewsletterViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        // Put the logo in the navigation bar
        let logo = UIImage(named: "logoNavBar")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set tabBar back to default so that it will be more visible with website content
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.backgroundImage = nil
        tabBarController?.tabBar.shadowImage = nil
        tabBarController?.tabBar.clipsToBounds = false
        
        
        // Create URL object and request
        let urlString = "https://abidingabove.org/index.php/newsletters/"
        let url = URL(string: urlString)
        guard url != nil else {return}
        let request = URLRequest(url: url!)
        
        // Start the load spinner
        spinner.alpha = 1
        spinner.startAnimating()
        
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

extension NewsletterViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Stop the spinner and hide it
        spinner.stopAnimating()
        spinner.alpha = 0
        
        // Display the "Back" button in navigation bar only if going back is an option
        if webView.canGoBack {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
        // MARK: - JavaScript injection for setting up style of webView
        
        webView.evaluateJavaScript("document.body.style.backgroundColor = '#F5F0EB';" ,
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.site-header').remove();" ,
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.nav-backed-header').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.col-md-3').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.site-footer').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.site-footer-bottom').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.page-content.margin-20 > p').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
        webView.evaluateJavaScript("document.querySelector('.share-bar').remove();",
                                   completionHandler: { (html: Any?, error: Error?) in
                                   })
 
       
        
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

}

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
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Set tabBar back to default so that it will be more visible with website content
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundImage = nil
        tabBarController?.tabBar.shadowImage = nil
        tabBarController?.tabBar.clipsToBounds = false
        

        
        let urlString = "https://abidingabove.org/index.php/newsletters/"
        let url = URL(string: urlString)
        guard url != nil else {return}
        
        let request = URLRequest(url: url!)
        spinner.alpha = 1
        spinner.startAnimating()
        
        
        
        webView.load(request)
    }
    
    @objc func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
}

extension NewsletterViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Stop the spinner and hide it
        spinner.stopAnimating()
        spinner.alpha = 0
        
        if webView.canGoBack {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        
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
       
        webView.alpha = 1

    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.alpha = 0

    }
    
}

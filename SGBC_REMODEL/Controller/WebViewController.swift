//
//  WebViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 17/09/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var selectedHymn: String!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true 
        webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
        webView.navigationDelegate = self
        view = webView
       
        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: selectedHymn , withExtension: ".pdf")
        webView.load(URLRequest(url: url!))
    }

}

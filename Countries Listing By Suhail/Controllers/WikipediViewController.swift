//
//  WikipediViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 07/01/24.
//

import Foundation

import UIKit
import WebKit

class WikipediaViewController: UIViewController {
    var cityName: String?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard var city = cityName else { return }
        if city.contains(" "){
        city = city.replacingOccurrences(of: " ", with: "_")
        }
        let url = URL(string: "https://en.wikipedia.org/wiki/"+city)!
        webView.load(URLRequest(url: url))
        
    }
    

    

}

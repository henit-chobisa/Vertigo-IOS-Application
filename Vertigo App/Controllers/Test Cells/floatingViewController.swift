//
//  floatingViewController.swift
//  Vertigo App
//
//  Created by Henit Work on 23/06/21.
//

import UIKit
import WebKit
import HTMLKit
import SwiftSoup
import Kanna

class floatingViewController: UIViewController, WKNavigationDelegate {

    
    var seekValue = 0
    var linkPrefix = "https://music.youtube.com/watch?v="
    var linkSuffix = "&feature=share"
    
    
    @IBOutlet weak var myWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = WKWebpagePreferences()
        let config = WKWebViewConfiguration()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs
        myWebView.layer.cornerRadius = 10
        myWebView.navigationDelegate = self
        loadPage(on: "https://music.youtube.com")
        
        
    }
    
    @IBAction func getLink(_ sender: UIButton) {
        test()
    }
    
    func test(){
        let currentURL = myWebView.url!.absoluteString
        print(currentURL)
        let range = 34...44
        let substring = String(currentURL[range])
        print(substring)
        reloadLinkWithTime(code: substring)
        
        
    }
    
    
    func reloadLinkWithTime(code : String){
        parseHTML()
        let desiredURL = "\(linkPrefix)\(code)\(linkSuffix)&t=\(seekValue+13)"
        loadRequest(desiredURL: desiredURL)
    }
    
    func loadRequest(desiredURL : String){
        let urlToLoad = URL(string: desiredURL)!
        print(urlToLoad.absoluteString)
        let loadRequest = URLRequest(url: urlToLoad)
        myWebView.load(loadRequest)
        
    }
    
    func loadPage(on urlString : String) {
        let myurl = URL.init(string: urlString)
        let Request = URLRequest(url: myurl!)
        myWebView.load(Request)
    }
    
    
    func parseHTML(){
        
        myWebView.evaluateJavaScript("document.body.innerHTML") { (result, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else {
                let htmlString = result as! String
                
                guard let doc = try? SwiftSoup.parse(htmlString) else { return }
                guard let element = try? doc.select("tp-yt-paper-slider[id^='progress-bar']") else { return }
                do {
                    let value = try element.attr("aria-valuenow")
                    print(value)
                    self.seekValue = Int(value)!
                    print(self.seekValue)
                }
                catch{
                    print(error.localizedDescription)
                }
                
            }
        }
        
        
    }
    
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loadPage(on: "https://music.youtube.com")
        }
        else if sender.selectedSegmentIndex == 1{
            loadPage(on: "https://www.youtube.com")
        }
        else if sender.selectedSegmentIndex == 2 {
            loadPage(on: "https://open.spotify.com")
        }
        else {
            loadPage(on : "https://inshorts.com/en/read/")
        }
    }
    
    

}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

//
//https://music.youtube.com/watch?v=gmoucRvDfIk&list=RDAMVMgmoucRvDfIk
//
//https://music.youtube.com/watch?v=JBOfBY1X80I&feature=share

//
//  ViewController.swift
//  EpubTestView
//
//  Created by 김광환 on 2021/07/07.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    
    var webView: WKWebView? = nil
    let page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView = makeWebView()
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self
        webView?.frame = baseView.bounds
        baseView.addSubview(webView!)
        if let loadHtmlPath = Bundle.main.path(forResource: "11-h", ofType: "html") {
            do {
                let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
                let content = try String(contentsOfFile: loadHtmlPath)
                webView?.loadHTMLString(content, baseURL: URL(string: libraryPath)!)
//                webView?.loadFileURL(URL(string: loadHtmlPath)!, allowingReadAccessTo: URL(string: libraryPath)!)
            } catch {
                print(error)
            }
        }
        
        if let savePath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("content.html") {
            print(savePath)
//        webView.loadFileURL(<#T##URL: URL##URL#>, allowingReadAccessTo: <#T##URL#>)
        }
        func makeWebView() -> WKWebView {
            let webView = WKWebView(frame: baseView.bounds, configuration: makeConfigure(javascriptHandler: self))
            return webView
        }
        func makeConfigure(javascriptHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
            let configuration = WKWebViewConfiguration()
            configuration.preferences.javaScriptEnabled = true
            configuration.allowsInlineMediaPlayback = true
            let controller = WKUserContentController()
            configuration.userContentController = controller
            if #available(iOS 13.0, *) {
                configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            }
            return configuration
        }
    }
    

}
extension ViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

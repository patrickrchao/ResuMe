//
//  ResumeViewController.swift
//  
//
//  Created by Alex Chan on 10/8/17.
//

import UIKit
import WebKit
import PDFReader
class ResumeViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let remotePDFDocumentURLPath = "https://www.dropbox.com/s/xyjveh14e57807q/Patrick%20Chao%20Resume.pdf?dl=1"
        let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
        let document = PDFDocument(url: remotePDFDocumentURL)!
        let readerController = PDFViewController.createNew(with: document)
        navigationController?.pushViewController(readerController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



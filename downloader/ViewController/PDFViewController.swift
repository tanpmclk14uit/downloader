//
//  PDFViewController.swift
//  downloader
//
//  Created by LAP14812 on 08/07/2022.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {

    //MARK: - CONFIG UI
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: -CONFIG UI CONSTRAINT
    private func configWebViewConstraint(){
        if #available(iOS 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
    }
    
    //MARK: - Define ViewController
    public var fileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLRequestToWebView()
        view.addSubview(webView)        
        configWebViewConstraint()
    
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(onBackPress))
    }
    
    private func loadURLRequestToWebView(){
        if let url = fileURL{
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    @objc func onBackPress(){
        self.dismiss(animated: true)
    }

}

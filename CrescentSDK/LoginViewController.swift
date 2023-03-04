//
//  LoginViewController.swift
//  CrescentSDK
//
//  Created by cyh on 2023/2/8.
//


import UIKit
import WebKit

final class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        setupViews();
    }
    
    func setupViews() {
        
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let minWidth = min(screenWidth, screenHeight);
        
        let baseView = UIView();
//        baseView.backgroundColor = UIColor.white;
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.layer.cornerRadius = 25
        view.addSubview(baseView)
        
        baseView.addSubview(gmailButton)
        baseView.addSubview(outlookButton)
        baseView.addSubview(testButton)
        
        print("minWidth = ", minWidth);
        
        NSLayoutConstraint.activate([
            baseView.widthAnchor.constraint(equalToConstant: minWidth - 16),
            baseView.heightAnchor.constraint(equalToConstant: minWidth - 16),
            baseView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            baseView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            testButton.widthAnchor.constraint(equalToConstant: 192),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            testButton.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            gmailButton.widthAnchor.constraint(equalToConstant: 192),
            gmailButton.heightAnchor.constraint(equalToConstant: 50),
            gmailButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            gmailButton.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            outlookButton.widthAnchor.constraint(equalToConstant: 192),
            outlookButton.heightAnchor.constraint(equalToConstant: 50),
            outlookButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            outlookButton.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 250),
            
        ])
    }
    
    private lazy var testButton: UIButton = getButton(name: "Test", act: #selector(clickTest))
    
    private lazy var gmailButton: UIButton = getButton(name: "Gmail", act: #selector(clickGmail))
    
    private lazy var outlookButton: UIButton = getButton(name: "Outlook", act: #selector(clickOutlook))
    
    
    @objc
    func clickTest() {
        let nextVC = CrescentViewController()
        nextVC.modalPresentationStyle = .overFullScreen
//        nextVC.preferredContentSize = CGSize(width: 300, height: 400)
        nextVC.isModalInPresentation = true
        nextVC.mailType = EmailBean.TYPE_TEST
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc
    func clickGmail() {
        let nextVC = CrescentViewController()
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.isModalInPresentation = true
        nextVC.mailType = EmailBean.TYPE_GMAIL
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc
    func clickOutlook() {
        let nextVC = CrescentViewController()
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.isModalInPresentation = true
        nextVC.mailType = EmailBean.TYPE_OUTLOOK
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    private func getButton(name: String, act: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(name, for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: act, for: .touchUpInside)
        return button
    }
    
//    var webView: WKWebView!
//
//    override func loadView() {
//        let baseView = UIView()
//        baseView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        self.view = baseView
//
////        let baseView = UIView(frame: .zero);
////        view = baseView;
//        let webConfiguration = WKWebViewConfiguration();
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
////        webView.uiDelegate = self;
//        webView.frame = CGRect(x: 33, y: 100, width: 300, height: 538)
////        baseView.backgroundColor = UIColor.blue
////        view = webView;
//        baseView.addSubview(webView)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5);//UIColor.clear
////        self.modalPresentationStyle = .overFullScreen
////        self.isModalInPresentation = true
//
//        let bundle = Bundle(for: type(of: self))
//        let url = bundle.url(forResource: "oldindex", withExtension: "html", subdirectory: "assets")!
//
////        let url = Bundle.main.url(forResource: "oldindex", withExtension: "html", subdirectory: "assets")!
//        webView.loadFileURL(url, allowingReadAccessTo: url)
////        let request = URLRequest(url: url)
////        webView.load(request)
//        return;
//    }
    
}

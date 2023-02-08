//
//  ViewController.swift
//  Crescent-iOS
//
//  Created by cyh on 2023/2/7.
//

import UIKit
import CrescentSDK

class ViewController: UIViewController, LoginDelegate, SendTransactionDelegate {
    func onLoginSuccess() {
        
    }
    
    func onLoginFail() {
        print("cyh::onLoginFail");
    }
    
    func onSendSuccess() {
        
    }
    
    func onSendFail() {
        print("cyh::onSendFail");
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews();
    }
    
    func setupViews() {
        view.addSubview(initButton)
        view.addSubview(loginButton)
        view.addSubview(logoutButton)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            
            initButton.widthAnchor.constraint(equalToConstant: 192),
            initButton.heightAnchor.constraint(equalToConstant: 50),
            initButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            loginButton.widthAnchor.constraint(equalToConstant: 192),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 192),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),

            sendButton.widthAnchor.constraint(equalToConstant: 192),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400),
        ])
    }

//    private lazy var loginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Login", for: .normal)
//        button.backgroundColor = .black.withAlphaComponent(0.1)
//        button.setTitleColor(UIColor.black, for: .normal)
//        button.layer.cornerRadius = 8
//        button.translatesAutoresizingMaskIntoConstraints = false
////        button.frame = CGRect(x: 100, y: 100, width: 292, height: 50)
//        button.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var initButton: UIButton = getButton(name: "InitSdk", act: #selector(clickInitSdk))
    
    private lazy var loginButton: UIButton = getButton(name: "Login", act: #selector(clickLogin))
    
    private lazy var logoutButton: UIButton = getButton(name: "Logout", act: #selector(clickLogout))
    
    private lazy var sendButton: UIButton = getButton(name: "SendTransaction", act: #selector(clickSend))
    
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
    
    @objc
    func clickInitSdk() {
        let config = CrescentConfigure(style: "")
        CrescentSDK.config(configure: config)
    }
    
    @objc
    func clickLogin() {
        CrescentSDK.login(delegate: self)
    }
    
    @objc
    func clickLogout() {
        CrescentSDK.logout()
    }
    
    @objc
    func clickSend() {
        CrescentSDK.sendTransaction(info: nil, delegate: self)
    }
}


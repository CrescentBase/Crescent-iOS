//
//  ViewController.swift
//  Crescent-iOS
//
//  Created by cyh on 2023/2/7.
//

import UIKit
import CrescentSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.systemBlue
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
        var config = CrescentConfigure()
        config.style = ""
        config.paymasterUrl = "https://wallet.crescentbase.com/api/v1/signOp"
        CrescentSDK.config(configure: config)
    }
    
    @objc
    func clickLogin() {
        CrescentSDK.connect(connectSuccessBlock: { userinfo in
            let email = userinfo.email!;
            let address = userinfo.address!;
        }, connectFailBlock: {
            print("fail")
        })
    }
    
    @objc
    func clickLogout() {
        CrescentSDK.disconnect()
    }
    
    @objc
    func clickSend() {
        var tx = TransactionInfo()
        tx.chainId = "137"
        tx.to = "0x6De6b8B22241A753495ed1C3289aBc9Bf61F5D2e"
        tx.value = "0x2386f26fc10000"
//        tx.data = "0xa9059cbb0000000000000000000000000648cea573a37ad78738c9ed861dd8ad9ca53bec0000000000000000000000000000000000000000000000000000000000002710"
        CrescentSDK.sendTransaction(info: tx, sendSuccessBlock: { transactionResult in
            let hash = transactionResult.hash!;
        }, sendFailBlock: {
            
        })
    }
}


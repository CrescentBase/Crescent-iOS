//
//  ViewController.swift
//  TestWk2
//
//  Created by cyh on 2023/1/16.
//

import UIKit
import WebKit

class CrescentViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    
    var mailType = EmailBean.TYPE_TEST;
    var emailWebView: WKWebView!
    var reactWebView: WKWebView!
    var mailAccount: String?;
    var publicKey: String?;
    
    var minWidth = 0.0;
    var webSize = 0.0;
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "CsCallBack" {
            let content = message.body as! String;
            print("CsCallBack content = ", content);
            
            let mArray = content.components(separatedBy: ";")
            if (mArray.count >= 2) {
                if (mArray[1] == "account") {
                    mailAccount = mArray[2];
                } else if (mArray[1] == "end") {
                    if (mailAccount != nil) {
                        print("请求成功： ", mailAccount!);
                    } else {
                        print("请求失败");
                    }
                    let dict = ["width": webSize, "height": webSize, "initView": "CreateLoading", "emailAccount": mailAccount!] as [String : Any];
                    let dictStr = dictToString(dict: dict);
                    print(dictStr);
                    reactWebView.evaluateJavaScript("loadMain(" + dictStr + ")") { (any, error) in
                        if (error != nil) {
                            print(error ?? "err")
                        }
                    }
                    emailWebView.isHidden = true;
                    reactWebView.isHidden = false;
                } else if (mArray[1] == "begin") {
                    let dict = ["width": webSize, "height": webSize];
                    let dictStr = dictToString(dict: dict);
                    print(dictStr);
                    reactWebView.evaluateJavaScript("loadLoading(" + dictStr + ")") { (any, error) in
                        if (error != nil) {
                            print(error ?? "err")
                        }
                    }
                    emailWebView.isHidden = true;
                    reactWebView.isHidden = false;
                }
            }
//            self.webView.frame = CGRect(x: 33, y: 100, width: 0, height: 0)
        } else if message.name == "ReactCallBack" {
            let content = message.body as! String;
            print("ReactCallBack content = ", content);
            let parts = content.split(separator: ";")
            if (parts.count == 2) {
                let name = parts[0];
                if (name == "gmail") {
                    mailType = EmailBean.TYPE_GMAIL;
                    publicKey = String(parts[1]);
                } else if (name == "outlook") {
                    mailType = EmailBean.TYPE_OUTLOOK;
                    publicKey = String(parts[1]);
                } else {
                    return;
                }
            
                emailWebView.isHidden = false;
                reactWebView.isHidden = true;
                navigatEmailUrl();
            }
//            let content = message.body as! String;
            
        }
    }
    
    func initEmailWebView() {
        let webConfiguration = WKWebViewConfiguration();
        emailWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        emailWebView.translatesAutoresizingMaskIntoConstraints = false
//        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        emailWebView.uiDelegate = self;
        emailWebView.layer.cornerRadius = 10
        emailWebView.layer.masksToBounds = true
        
        view.addSubview(emailWebView)
        
        NSLayoutConstraint.activate([
            emailWebView.widthAnchor.constraint(equalToConstant: webSize),
            emailWebView.heightAnchor.constraint(equalToConstant: webSize),
            emailWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            emailWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let jsLog = "console.log = (" +
            "function(oriLogFunc){" +
                "return function(str){" +
                    "oriLogFunc.call(console,str);\n" +
                    "window.webkit.messageHandlers.CsCallBack.postMessage(str);" +
                "}" +
            "})(console.log);"
        let script = WKUserScript.init(source: jsLog, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        emailWebView.configuration.userContentController.addUserScript(script)
        emailWebView.configuration.userContentController.add(self, name: "CsCallBack")
        emailWebView.navigationDelegate = self;
    }
    
    func navigatEmailUrl() {
        var urlStr = EmailBean.TEST_URL;
        var isPcUA = false;
        if (mailType == EmailBean.TYPE_GMAIL) {
            urlStr = EmailBean.GMAIL_URL;
        } else if (mailType == EmailBean.TYPE_OUTLOOK) {
            urlStr = EmailBean.OUTLOOK_URL;
            isPcUA = true;
        } else if (mailType == EmailBean.TYPE_QQ) {
            urlStr = EmailBean.QQ_URL;
            isPcUA = true;
        }
        if (isPcUA) {
            emailWebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36";
        }
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        emailWebView.load(request)
    }
    
    
    func initReactWebView() {
        let webConfiguration = WKWebViewConfiguration();
        reactWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        reactWebView.translatesAutoresizingMaskIntoConstraints = false
//        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        emailWebView.uiDelegate = self;
        reactWebView.layer.cornerRadius = 10
        reactWebView.layer.masksToBounds = true
        
        view.addSubview(reactWebView)
        
        NSLayoutConstraint.activate([
            reactWebView.widthAnchor.constraint(equalToConstant: webSize),
            reactWebView.heightAnchor.constraint(equalToConstant: webSize),
            reactWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            reactWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let jsLog = "console.log = (" +
            "function(oriLogFunc){" +
                "return function(str){" +
                    "oriLogFunc.call(console,str);\n" +
                    "//这里，在执行自定义console.log的时候，将str传递出去。" +
                    "window.webkit.messageHandlers.ReactCallBack.postMessage(str);" +
                "}" +
            "})(console.log);"
        let script = WKUserScript.init(source: jsLog, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        reactWebView.configuration.userContentController.addUserScript(script)
        reactWebView.configuration.userContentController.add(self, name: "ReactCallBack")
        reactWebView.navigationDelegate = self;
        
        let bundle = Bundle(for: type(of: self))
        let url1 = bundle.url(forResource: "index", withExtension: "html", subdirectory: "assets")!
//        reactWebView.loadFileURL(url1, allowingReadAccessTo: url1)
//        return;
        
//        let url1 = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "assets")!
//        webView.loadFileURL(url1, allowingReadAccessTo: url1)
//        return;
        
        
        let urlStr = "http://192.168.2.43:9590/index.html"
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        reactWebView.load(request)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let scale = UIScreen.main.scale
        let logicalWidth = screenWidth * scale
        
        print(scale, logicalWidth)
        
        minWidth = min(screenWidth, screenHeight);
        webSize = minWidth - 12;
//        let dataStore = WKWebsiteDataStore.default()
//        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
//                // Data has been deleted, continue with your code
//            }
//        }
        initEmailWebView();
        initReactWebView();
        
        emailWebView.isHidden = true;
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView ====", webView.url!);
        if (webView == reactWebView) {
            let dict = ["width": webSize, "height": webSize];//, "emailAccount": "kaixinchen2022@gmail.com"];
            let dictStr = dictToString(dict: dict);
            print(dictStr);
            webView.evaluateJavaScript("initLoad(" + dictStr + ")") { (any, error) in
                if (error != nil) {
                    print(error ?? "err")
                }
            }
            return;
        }
        var injectJs: String = "";
        var receiverEmail = "crescentweb3@gmail.com";
        if (self.mailType == EmailBean.TYPE_GMAIL) {
            if (webView.url?.absoluteString.hasPrefix("https://mail.google.com/mail/mu/mp/") == true) {
                injectJs = EmailBean.GMAIL_JS;
                receiverEmail = "crescentweb3@outlook.com";
            }
        } else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            if (webView.url?.absoluteString.hasPrefix("https://outlook.live.com/mail/0/") == true) {
                injectJs = EmailBean.OUTLOOK_JS
            }
        }  else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            injectJs = EmailBean.TEST_JS
        }
        
        print("webView end ====", webView.url!);
        if (injectJs != "") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 回调到这，页面显示还要300毫秒
                let funcName = "sdk4337Fun(false, '" + receiverEmail + "', '" + self.publicKey! + "');";
                webView.evaluateJavaScript(injectJs + "setTimeout(function() {" + funcName + "}, 1);") { (any, error) in
                    if (error != nil) {
                        print(error ?? "err")
                    }
                }
            }
        }
    }
    
    func dictToString(dict: Dictionary<String, Any>) -> String {
        var result = "";
        result += "{"

        for (key, value) in dict {
            if (value is String) {
                result += ("\(key): '\(value)',")
            } else {
                result += ("\(key): \(value),")
            }
        }
        
        result.removeLast()

        result += "}"
        return result;
    }
    
    func isNumber(str: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"^-?\d+(\.\d+)?$"#)
        let range = NSRange(str.startIndex..., in: str)
        let isNumber = regex.firstMatch(in: str, options: [], range: range) != nil
        return isNumber;
    }
}


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
    var walletKeytore: String?;
    var hasGetAccount: Bool = false;
    var hasInject: Bool = false;
    
    var minWidth = 0.0;
    var webSize = 0.0;
    var reactWebViewBottomConstraint: NSLayoutConstraint?
    var emailWebViewBottomConstraint: NSLayoutConstraint?
    
    var tx: TransactionInfo?;
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "CsCallBack" {
            let content = message.body as! String;
            print("CsCallBack content = ", content);
            
            let mArray = content.components(separatedBy: ";")
            if (mArray.count >= 2) {
                if (mArray[1] == "account") {
                    hasGetAccount = true;
                    mailAccount = mArray[2];
                    let dict = ["width": webSize, "height": webSize, "initView": "CreateLoading", "emailAccount": mailAccount!, "paymasterUrl": CrescentSDK.mConfigure?.paymasterUrl!] as [String : Any];
                    let dictStr = dictToString(dict: dict);
                    print(dictStr);
                    reactWebView.evaluateJavaScript("loadMain(" + dictStr + ")") { (any, error) in
                        if (error != nil) {
                            print(error ?? "err")
                        }
                    }
                    emailWebView.isHidden = true;
                    reactWebView.isHidden = false;
                } else if (mArray[1] == "end") {
//                    if (mailAccount != nil) {
//                        print("请求成功： ", mailAccount!);
//                    } else {
//                        print("请求失败");
//                    }
                } else if (mArray[1] == "begin") {
//                    hasBegan = true;
//                    let dict = ["width": webSize, "height": webSize, "pagmasterUrl": CrescentSDK.mConfigure?.paymasterUrl!] as [String : Any];
//                    let dictStr = dictToString(dict: dict);
//                    reactWebView.evaluateJavaScript("loadLoading(" + dictStr + ")") { (any, error) in
//                        if (error != nil) {
//                            print(error ?? "err")
//                        }
//                    }
//                    emailWebView.isHidden = true;
//                    reactWebView.isHidden = false;
                }
            }
        } else if message.name == "ReactCallBack" {
            let content = message.body as! String;
            print("ReactCallBack content = ", content);
            let parts = content.split(separator: ";", maxSplits: 2)
            if (parts.count == 2) {
                let name = parts[0];
                if (name == "url") {
                    if let url = URL(string: String(parts[1])) {
                        UIApplication.shared.open(url)
                    }
                    return;
                }
                if (name == "error") {
                    let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
                    let dateFrom = NSDate(timeIntervalSince1970: 0)
                    WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date, completionHandler: {})
                    self.toastFail()
                    return;
                }
                if (name == "walletKeystore") {
                    walletKeytore = String(parts[1]);
                    return;
                }
                if (name == "print") {
                    let printInfo = String(parts[1]);
                    print(printInfo)
                    return;
                }
                if (name == "sendTx") {
                    let sendHash = String(parts[1]);
                    if (sendHash != "") {
                        if (CrescentSDK.mSendSuccessBlock != nil) {
                            if let successBlock = CrescentSDK.mSendSuccessBlock {
                                var result = TransactionResult()
                                result.hash = sendHash;
                                successBlock(result)
                            }
                        }
                    }
                }
                if (name == "pasteboard") {
                    let pasteboardInfo = String(parts[1]);
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = pasteboardInfo
                    return;
                }
                if (name == "userInfo") {
                    if let jsonData = String(parts[1]).data(using: .utf8) {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            if let jsonDict = jsonObject as? [String: Any] {
                                // Access individual values in the dictionary
                                let email = jsonDict["email"] as? String
                                let address = jsonDict["address"] as? String
                                UserDefaults.standard.set(email, forKey: EmailBean.SP_EMAIL_KEY)
                                UserDefaults.standard.set(address, forKey: EmailBean.SP_ADDRESS_KEY)
                                let mConnectSuccessBlock = CrescentSDK.mConnectSuccessBlock;
                                if let successBlock = mConnectSuccessBlock {
                                    var userInfo = UserInfo()
                                    userInfo.email = email
                                    userInfo.address = address
                                    successBlock(userInfo)
                                }
                            }
                        } catch {
                            print("Error converting JSON string to object: \(error.localizedDescription)")
                        }
                    }
                    return;
                }
                if (name == "gmail") {
                    if (publicKey != nil) {
                        return;
                    }
                    mailType = EmailBean.TYPE_GMAIL;
                    publicKey = String(parts[1]);
                } else if (name == "outlook") {
                    if (publicKey != nil) {
                        return;
                    }
                    mailType = EmailBean.TYPE_OUTLOOK;
                    publicKey = String(parts[1]);
                } else {
                    return;
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if (!self.hasInject) {
                        self.emailWebView.isHidden = false;
                        self.reactWebView.isHidden = true;
                    }
                }
                
                navigatEmailUrl();
            }
        
        }
    }
    
    func initEmailWebView() {
        let webConfiguration = WKWebViewConfiguration();
        emailWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        emailWebView.translatesAutoresizingMaskIntoConstraints = false
        emailWebView.layer.cornerRadius = 10
        emailWebView.layer.masksToBounds = true
        
        view.addSubview(emailWebView)
        
        NSLayoutConstraint.activate([
            emailWebView.widthAnchor.constraint(equalToConstant: webSize),
            emailWebView.heightAnchor.constraint(equalToConstant: webSize),
            emailWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        emailWebViewBottomConstraint = emailWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        emailWebViewBottomConstraint?.isActive = true
        
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
            
//            let useragentPre = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.";
//            let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
//            let lastFiveDigits = Int(currentTimeMillis % 100000)
//            let useragent = useragentPre + String(lastFiveDigits);
//            print(“==useragent”);
//            emailWebView.customUserAgent = useragent;
        }
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        emailWebView.load(request)
    }
    
    
    func initReactWebView() {
        let webConfiguration = WKWebViewConfiguration();
        reactWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        reactWebView.translatesAutoresizingMaskIntoConstraints = false
        reactWebView.layer.cornerRadius = 10
        reactWebView.layer.masksToBounds = true
        view.addSubview(reactWebView)
        
        NSLayoutConstraint.activate([
            reactWebView.widthAnchor.constraint(equalToConstant: webSize),
            reactWebView.heightAnchor.constraint(equalToConstant: webSize),
            reactWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        reactWebViewBottomConstraint = reactWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        reactWebViewBottomConstraint?.isActive = true
        
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
        reactWebView.loadFileURL(url1, allowingReadAccessTo: url1)
        return;
//
//        let url1 = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "assets")!
//        webView.loadFileURL(url1, allowingReadAccessTo: url1)
//        return;
        
        
//        let urlStr = "http://192.168.2.43:4143/index.html"
////        let urlStr = "https://www.baidu.com"
//        let url = URL(string: urlStr)
//        let request = URLRequest(url: url!)
//        reactWebView.load(request)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        reactWebViewBottomConstraint?.constant = -keyboardHeight
        emailWebViewBottomConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        reactWebViewBottomConstraint?.constant = 0
        emailWebViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if (!hasGetAccount || walletKeytore != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (webView == reactWebView) {
            var dict = ["width": webSize, "height": webSize, "paymasterUrl": CrescentSDK.mConfigure?.paymasterUrl!] as [String : Any];
            let dictStr = dictToString(dict: dict);
            print(dictStr)
            if (CrescentSDK.isConnected()) {
                if (tx != nil) {
                    var txDic = [String: Any]()
                    if let to = tx?.to {
                        txDic["to"] = String(to)
                    }
                    if let chainId = tx?.chainId {
                        txDic["chainId"] = String(chainId)
                    }
                    if let data = tx?.data {
                        txDic["data"] = String(data)
                    }
                    if let value = tx?.value {
                        txDic["value"] = String(value)
                    }
                    dict["tx"] = txDic;
                    webView.evaluateJavaScript("initLoad(" + dictToString(dict: dict) + ")") { (any, error) in
                        if (error != nil) {
                            print(error ?? "err")
                        }
                    }
                } else {
                    webView.evaluateJavaScript("initLoad(" + dictStr + ")") { (any, error) in
                        if (error != nil) {
                            print(error ?? "err")
                        }
                    }
                }
            } else {
                webView.evaluateJavaScript("loadSelectEmail(" + dictStr + ")") { (any, error) in
                    if (error != nil) {
                        print(error ?? "err")
                    }
                }
            }
            return;
        }
        var injectJs: String = "";
        var receiverEmail = "crescentweb3@gmail.com";
        if (self.mailType == EmailBean.TYPE_GMAIL) {
            if (webView.url?.absoluteString.hasPrefix("https://mail.google.com/mail/mu/mp/") == true) {
                injectJs = EmailBean.GMAIL_JS;
                receiverEmail = "crescentweb3@zohomail.cn";
            }
        } else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            if (webView.url?.absoluteString.hasPrefix("https://outlook.live.com/mail/0/") == true) {
                injectJs = EmailBean.OUTLOOK_JS
            }
        }  else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            injectJs = EmailBean.TEST_JS
        }
        if (injectJs != "" && !hasInject) {
            hasInject = true;
            let dict = ["width": webSize, "height": webSize, "pagmasterUrl": CrescentSDK.mConfigure?.paymasterUrl!] as [String : Any];
            let dictStr = dictToString(dict: dict);
            reactWebView.evaluateJavaScript("loadLoading(" + dictStr + ")") { (any, error) in
                if (error != nil) {
                    print(error ?? "err")
                }
            }
            emailWebView.isHidden = true;
            reactWebView.isHidden = false;
            
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
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            fatalError("Failed to convert JSON object to JSON data")
        }
//                    let dictStrNew = dictToString(dict: dictNew);
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            fatalError("Failed to convert JSON data to JSON string")
        }
        return "";
//        var result = "";
//        result += "{"
//
//        for (key, value) in dict {
//            if (value is String) {
//                result += ("\(key): '\(value)',")
//            } else {
//                result += ("\(key): \(value),")
//            }
//        }
//
//        result.removeLast()
//
//        result += "}"
//        return result;
    }
    
    func isNumber(str: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"^-?\d+(\.\d+)?$"#)
        let range = NSRange(str.startIndex..., in: str)
        let isNumber = regex.firstMatch(in: str, options: [], range: range) != nil
        return isNumber;
    }
    
    func toastFail() {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        // 设置UILabel属性
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = "Failed to create wallet, please try again"

        // 将UILabel添加到父视图上
        self.view.addSubview(toastLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toastLabel.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
    }
}


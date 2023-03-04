//
//  ViewController.swift
//  TestWk2
//
//  Created by cyh on 2023/1/16.
//

import UIKit
import WebKit

class MailViewControllerOld: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    private let TEST_URL: String = "https://news.163.com/";
    private let GMAIL_URL: String = "https://mail.google.com/";
    private let QQ_URL: String = "https://mail.qq.com/";
    private let OUTLOOK_URL: String = "https://outlook.live.com/owa/?nlp=1";//"https://outlook.live.com";

    private let TEST_JS_1: String = "" +
            "async function sdk4337Fun() {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*2000+300)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;end');" +
            "}; " +
            "sdk4337Fun();";

    private let TEST_JS: String = "" +
            "async function sdk4337Fun() {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;begin');" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;end');" +
            "}; " +
            "sdk4337Fun();";
    
    private let GMAIL_JS: String = "" +
                "async function sdk4337Fun(isAndroid) {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                "if (window.hasSend4337 != true && (!document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ') || document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ').length <= 0)) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));}" +
                "if (window.hasSend4337 != true && (!document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ') || document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ').length <= 0)) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+4000)));}" +
                "if (window.hasSend4337 != true && document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ') && document.getElementsByClassName('Gl d Pp Ze nm ol Sb  ').length > 0) {" +
                    "if (isAndroid) {prompt('js4337://4337sdk?arg1=gmail&arg2=begin');} else {window.webkit.messageHandlers.CsCallBack.postMessage('gmail;begin');}" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1500)));" +
                    "document.getElementsByClassName('Gl d Pp Ze nm ol kl  ')[0].click();" +
                    "var account = document.getElementsByClassName('il bk KA hf')[0].innerHTML;" +
                    "if (isAndroid) {prompt('js4337://4337sdk?arg1=gmail&arg2=account&arg3=' + account);} else {window.webkit.messageHandlers.CsCallBack.postMessage('gmail;account;' + account);}" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                    "if (!document.getElementsByClassName('oj Vp hf')[0]) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1000)));}" +
                    "if (!document.getElementsByClassName('oj Vp hf')[0]) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+3000)));}" +
                    "if (!document.getElementsByClassName('oj Vp hf')[0]) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+6000)));}" +
                    "document.getElementsByClassName('oj Vp hf')[0].click();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+800)));" +
                    "document.getElementsByClassName(\"Gl d Pp Ze nm ol Sb\")[0].click();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "document.querySelector(\".Mt .Ll.Ou\").value = \"cyh2023@163.com\";" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "document.querySelector(\".Bt.Ut .Ql\").value = \"test1 theme\";" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "document.querySelector(\".Vt .Nl\").innerHTML = \"test1 content…\" + new Date().getTime();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "document.querySelector(\".Gl.d.Pp.Ze.nm.ul.Mb\").click();" +
                    "window.hasSend4337 = true; " +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*2000+300)));" +
                    "if (isAndroid) {prompt('js4337://4337sdk?arg1=gmail&arg2=end');} else {window.webkit.messageHandlers.CsCallBack.postMessage('gmail;end');}" +
                "}" +
            "}; ";
//            "sdk4337Fun();";

    private let QQ_JS: String =
            "async function myFun() {" +
                "if (document.querySelector(\"#composebtn\")) {" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+600)));" +
                    "location.href = document.querySelector(\"#composebtn\").href;" +
                "}" +
            "};" +
            "myFun();";

    private let QQ_JS_2: String =
            "async function myFun() {" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1500)));" +
                    "document.querySelector('#mainFrameContainer iframe').contentDocument.querySelector('#toAreaCtrl .js_input').value = 'cyh2023@163.com';" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+600)));" +
                    "document.querySelector('#mainFrameContainer iframe').contentDocument.querySelector('#subject').value = 'from qq test subject';" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+600)));" +
                    "document.querySelector('#mainFrameContainer iframe').contentDocument.querySelector('#QMEditorArea iframe').contentDocument.body.querySelector('div').innerHTML = 'from qq test content' + new Date().getTime();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+600)));" +
                    "document.querySelector('#mainFrameContainer iframe').contentDocument.querySelector('#toolbar .btn_gray.btn_space').click();" +
                "};" +
            "myFun();";
    
    private let OUTLOOK_JS: String =
            "async function sdk4337Fun(isAndroid) {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                "if (isAndroid) {prompt('js4337://4337sdk?arg1=outlook&arg2=begin');} else {window.webkit.messageHandlers.CsCallBack.postMessage('outlook;begin');}" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+3000)));" +
                "if (!window.hasSend4337 && (!document.getElementById('innerRibbonContainer') || !document.getElementById('innerRibbonContainer').querySelectorAll('button') || document.getElementById('innerRibbonContainer').querySelectorAll('button').length <= 1)) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));}" +
                "if (!window.hasSend4337 && (!document.getElementById('innerRibbonContainer') || !document.getElementById('innerRibbonContainer').querySelectorAll('button') || document.getElementById('innerRibbonContainer').querySelectorAll('button').length <= 1)) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+5000)));}" +
                "if (!window.hasSend4337 && (!document.getElementById('innerRibbonContainer') || !document.getElementById('innerRibbonContainer').querySelectorAll('button') || document.getElementById('innerRibbonContainer').querySelectorAll('button').length <= 1)) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+7000)));}" +
                "if (!window.hasSend4337 && document.getElementById('innerRibbonContainer') && document.getElementById('innerRibbonContainer').querySelectorAll('button') && document.getElementById('innerRibbonContainer').querySelectorAll('button').length > 1) {" +
                    "document.getElementById('O365_MainLink_Me').click();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                    "if (!document.getElementById('mectrl_currentAccount_secondary')) {await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+4000)));};" +
                    "var account = document.getElementById('mectrl_currentAccount_secondary').innerHTML;" +
                    "if (isAndroid) {prompt('js4337://4337sdk?arg1=outlook&arg2=account&arg3=' + account);} else {window.webkit.messageHandlers.CsCallBack.postMessage('outlook;account;' + account);}" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "document.getElementById('innerRibbonContainer').querySelectorAll('button')[1].click();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                    "document.querySelector('.EditorClass').innerHTML = '514124773@qq.com';" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1300)));" +
                    "document.querySelector('[id^=editorParent] div').innerHTML = 'from outlook test content' + new Date().getTime();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1300)));" +
                    "document.getElementById('ReadingPaneContainerId').querySelectorAll('[role=\"button\"]')[1].click();" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+1500)));" +
                    "document.querySelector('[id^=ok-]').click();" +
                    "window.hasSend4337 = true; " +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+500)));" +
                    "if (isAndroid) {prompt('js4337://4337sdk?arg1=outlook&arg2=end');} else {window.webkit.messageHandlers.CsCallBack.postMessage('outlook;end');}" +
                "}" +
            "};";
    
    var mailType = EmailBean.TYPE_TEST;
    var webView: WKWebView!
    var mailAccount: String?;
    
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
                }
            }
//            self.webView.frame = CGRect(x: 33, y: 100, width: 0, height: 0)
        };
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let dataStore = WKWebsiteDataStore.default()
//        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
//                // Data has been deleted, continue with your code
//            }
//        }
        setupView()
        
        let bundle = Bundle(for: type(of: self))
        let url1 = bundle.url(forResource: "index", withExtension: "html", subdirectory: "assets")!
//        webView.loadFileURL(url1, allowingReadAccessTo: url1)
//        let url1 = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "assets")!
//        webView.loadFileURL(url1, allowingReadAccessTo: url1)
//        return;
        
        var urlStr = TEST_URL;
        var isPcUA = false;
        if (mailType == EmailBean.TYPE_GMAIL) {
            urlStr = GMAIL_URL;
        } else if (mailType == EmailBean.TYPE_OUTLOOK) {
            urlStr = OUTLOOK_URL;
            isPcUA = true;
        } else if (mailType == EmailBean.TYPE_QQ) {
            urlStr = QQ_URL;
            isPcUA = true;
        }
        urlStr = "http://192.168.2.43:5849/index.html"
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        self.webView.navigationDelegate = self;
        self.webView.load(request)
        
        if (isPcUA) {
//            webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36";
        }
        
        let jsLog = "console.log = (" +
            "function(oriLogFunc){" +
                "return function(str){" +
                    "oriLogFunc.call(console,str);\n" +
                    "//这里，在执行自定义console.log的时候，将str传递出去。" +
                    "window.webkit.messageHandlers.CsCallBack.postMessage(str);" +
                "}" +
            "})(console.log);"
        let script = WKUserScript.init(source: jsLog, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "CsCallBack")
    }
    
    func setupView() {
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let minWidth = min(screenWidth, screenHeight);
        
        view.backgroundColor = UIColor.white
        let webConfiguration = WKWebViewConfiguration();
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        webView.uiDelegate = self;
        webView.layer.cornerRadius = 10
        webView.layer.masksToBounds = true
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalToConstant: minWidth - 12),
            webView.heightAnchor.constraint(equalToConstant: minWidth - 12),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

//    override func loadView() {
//        view.backgroundColor = UIColor.blue
//        return;
//        let webConfiguration = WKWebViewConfiguration();
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self;
//        view.addSubview(webView)
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("webView ====", webView.url!);
        var injectJs: String = "";
        if (self.mailType == EmailBean.TYPE_GMAIL) {
            if (webView.url?.absoluteString.hasPrefix("https://mail.google.com/mail/mu/mp/") == true) {
                injectJs = self.GMAIL_JS;
            }
        } else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            if (webView.url?.absoluteString.hasPrefix("https://outlook.live.com/mail/0/") == true) {
                injectJs = self.OUTLOOK_JS
            }
        }  else if (self.mailType == EmailBean.TYPE_OUTLOOK) {
            injectJs = self.TEST_JS
        }
        
        print("webView end ====", webView.url!);
        if (injectJs != "") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 回调到这，页面显示还要300毫秒
                webView.evaluateJavaScript(injectJs + "setTimeout(function() {sdk4337Fun(false)}, 1);") { (any, error) in
                    if (error != nil) {
                        print(error ?? "err")
                    }
                }
            }
        }
    }

}


//
//  EmailBean.swift
//  CrescentSDK
//
//  Created by cyh on 2023/3/4.
//

import Foundation

public class EmailBean {
    public static let TYPE_TEST: Int = 0x10000;
    public static let TYPE_GMAIL: Int = 0x1;
    public static let TYPE_OUTLOOK: Int = 0x2;
    public static let TYPE_QQ: Int = 0x3;
    
    public static let TEST_URL: String = "https://news.163.com/";
    public static let GMAIL_URL: String = "https://mail.google.com/";
    public static let QQ_URL: String = "https://mail.qq.com/";
    public static let OUTLOOK_URL: String = "https://outlook.live.com/owa/?nlp=1";//"https://outlook.live.com";

    public static let TEST_JS_1: String = "" +
            "async function sdk4337Fun() {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*2000+300)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;end');" +
            "}; " +
            "sdk4337Fun();";

    public static let TEST_JS: String = "" +
            "async function sdk4337Fun() {" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;begin');" +
                "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+2000)));" +
                "window.webkit.messageHandlers.CsCallBack.postMessage('test;end');" +
            "}; " +
            "sdk4337Fun();";
    
    public static let GMAIL_JS: String = "" +
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

    public static let QQ_JS: String =
            "async function myFun() {" +
                "if (document.querySelector(\"#composebtn\")) {" +
                    "await new Promise(r => setTimeout(r, Math.floor(Math.random()*500+600)));" +
                    "location.href = document.querySelector(\"#composebtn\").href;" +
                "}" +
            "};" +
            "myFun();";

    public static let QQ_JS_2: String =
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
    
    public static let OUTLOOK_JS: String =
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
    
}

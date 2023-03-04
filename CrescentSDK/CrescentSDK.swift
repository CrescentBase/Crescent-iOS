//
//  CrescentSDK.swift
//  CrescentSDK
//
//  Created by cyh on 2023/2/7.
//

import UIKit

public class CrescentSDK {
    public static var mConfigure: CrescentConfigure? = nil;
    public static var mLoginDelegate: LoginDelegate? = nil
    public static var mSendTransactionDelegate: SendTransactionDelegate?

    public static func config(configure: CrescentConfigure?) {
        mConfigure = configure;
    }

    public static func isLogin() -> Bool {
        return false;
    }
    
    public static func login(delegate: LoginDelegate?) -> Void {
        mLoginDelegate = delegate;
        if (delegate != nil) {
            delegate!.onLoginFail();
        }
        
        let nextVC = CrescentViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.isModalInPresentation = true
        let window: UIWindow!;
        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            window = windowScene?.windows.first
        } else {
            window = UIApplication.shared.windows.first
        }
        
        if let rootViewController =
            window.rootViewController {
            rootViewController.present(nextVC, animated: true, completion: nil)
        }
    }
    
    public static func logout() -> Void {
        
    }
    
    public static func sendTransaction(info: TransactionInfo?, delegate: SendTransactionDelegate?) -> Void {
        mSendTransactionDelegate = delegate;
        if (delegate != nil) {
            delegate!.onSendFail();
        }
    }
}

public protocol LoginDelegate {
    func onLoginSuccess();
    func onLoginFail();
}

public protocol SendTransactionDelegate {
    func onSendSuccess();
    func onSendFail();
}

public struct TransactionInfo {
    public init() {
    }
}

public struct CrescentConfigure {
    public var style: String?;
    
    public init(style: String?) {
        self.style = style
    }
}

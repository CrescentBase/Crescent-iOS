//
//  CrescentSDK.swift
//  CrescentSDK
//
//  Created by cyh on 2023/2/7.
//

import UIKit

public class CrescentSDK {
    public static var mConfigure: CrescentConfigure? = nil;
    public static var mLoginDelegate: ConnectDelegate? = nil
    public static var mTransactionDelegate: TransactionDelegate?
    
    public static var  mConnectSuccessBlock: ((UserInfo) -> Void)?
    
    public static func config(configure: CrescentConfigure?) {
        mConfigure = configure;
    }
    
    public static func isConnected() -> Bool {
        return false;
    }
    //
    //    public static func connect(delegate: ConnectDelegate?) -> Void {
    //        mLoginDelegate = delegate;
    //        if (delegate != nil) {
    //            delegate!.onConnectFail();
    //        }
    //
    //        let nextVC = CrescentViewController()
    //        nextVC.modalPresentationStyle = .overCurrentContext
    //        nextVC.isModalInPresentation = true
    //        let window: UIWindow!;
    //        if #available(iOS 15.0, *) {
    //            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    //            window = windowScene?.windows.first
    //        } else {
    //            window = UIApplication.shared.windows.first
    //        }
    //
    //        if let rootViewController =
    //            window.rootViewController {
    //            rootViewController.present(nextVC, animated: true, completion: nil)
    //        }
    //    }
    //
    public static func connect(connectSuccessBlock: @escaping (UserInfo) -> Void, connectFailBlock: @escaping () -> Void) {
        mConnectSuccessBlock = connectSuccessBlock;
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
        
//        if let successBlock = mConnectSuccessBlock {
//            var userInfo = UserInfo()
//            userInfo.email = "example@email.com"
//            userInfo.address = "123 Main St"
//            successBlock(userInfo)
//        }
    }
    


    
    
    public static func disconnect() -> Void {
        
    }
    
    public static func sendTransaction(info: TransactionInfo?, sendSuccessBlock: @escaping (TransactionResult) -> Void, sendFailBlock: @escaping () -> Void) {
        if (info == nil) {
            sendFailBlock();
        }
    }
    
//    public static func sendTransaction(info: TransactionInfo?, delegate: TransactionDelegate?) -> Void {
//        mTransactionDelegate = delegate;
//        if (delegate != nil) {
//            delegate!.onSendFail();
//        }
//    }
}

public protocol ConnectDelegate {
    func onConnectSuccess(info: UserInfo);
    func onConnectFail();
}

public protocol TransactionDelegate {
    func onSendSuccess(result: TransactionResult);
    func onSendFail();
}

public struct TransactionInfo {
    public init() {
    }
    public var from: String = ""
    public var to: String = ""
    public var value: String = ""
    public var data: String = ""
}

public struct UserInfo {
    public var email: String?
    public var address: String?
}

public struct TransactionResult {
    public var hash: String?
}

public struct CrescentConfigure {
    public var style: String?;
    
    public init() {
    }
}

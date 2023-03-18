//
//  CrescentSDK.swift
//  CrescentSDK
//
//  Created by cyh on 2023/2/7.
//

import UIKit
import WebKit
import CoreTelephony
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

public class CrescentSDK {
    public static var mConfigure: CrescentConfigure? = nil;
    
    public static var  mConnectSuccessBlock: ((UserInfo) -> Void)?
    public static var  mSendSuccessBlock: ((TransactionResult) -> Void)?
    public static var  mSendFailBlock: (() -> Void)?
    
    public static func config(configure: CrescentConfigure?) {
        mConfigure = configure;
        checkNetworkPermission()
    }
    
    public static func isConnected() -> Bool {
        if ((UserDefaults.standard.string(forKey: EmailBean.SP_ADDRESS_KEY) != nil) && (UserDefaults.standard.string(forKey: EmailBean.SP_EMAIL_KEY) != nil)) {
            return true;
        }
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
        if (mConfigure == nil || mConfigure?.paymasterUrl == nil) {
            return;
        }
        
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
        UserDefaults.standard.removeObject(forKey: EmailBean.SP_EMAIL_KEY)
        UserDefaults.standard.removeObject(forKey: EmailBean.SP_ADDRESS_KEY)
//
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let dateFrom = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date, completionHandler: {})
    }
    
    public static func sendTransaction(info: TransactionInfo?, sendSuccessBlock: @escaping (TransactionResult) -> Void, sendFailBlock: @escaping () -> Void) {
        if (mConfigure == nil || mConfigure?.paymasterUrl == nil) {
            return;
        }
        mSendSuccessBlock = sendSuccessBlock;
        mSendFailBlock = sendFailBlock;
        let nextVC = CrescentViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.isModalInPresentation = true
        nextVC.tx = info;
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
    
//    public static func sendTransaction(info: TransactionInfo?, delegate: TransactionDelegate?) -> Void {
//        mTransactionDelegate = delegate;
//        if (delegate != nil) {
//            delegate!.onSendFail();
//        }
//    }
    
    static func checkNetworkPermission() {
        if hasWiFiPermission() || hasCellularPermission() {
            print("====有权限")
            // 权限已经被授予
            // 在这里添加你的代码
        } else {
            print("====没有权限")
            requestNetworkPermission()
            
        }
//        requestNetworkPermission()
    }

    static func hasWiFiPermission() -> Bool {
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    return true
                }
            }
        }
        return false
    }


    static func hasCellularPermission() -> Bool {
        let cellData = CTCellularData()
        let status = cellData.restrictedState
        return status == .notRestricted
    }
    
    static func requestNetworkPermission() {
        if let url = URL(string: "https://www.baidu.com") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    if let htmlContent = String(data: data, encoding: .utf8) {
//                        print(htmlContent)
//                    }
//                }
            }
            task.resume()
        }
        return;
//
//        if #available(iOS 13.0, *) {
//            let configuration = NEHotspotConfiguration(ssid: "")
//            configuration.joinOnce = true
//            NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
//                if error != nil {
//                    // 请求权限失败
//                } else {
//                    // 请求权限成功
//                    // 在这里添加你的代码
//                }
//            }
//        } else {
//            let cellData = CTCellularData()
//            cellData.cellularDataRestrictionDidUpdateNotifier = { (state) in
//                if state == .restrictedStateUnknown || state == .notRestricted {
//                    cellData.cellularDataRestrictionDidUpdateNotifier = nil
//                    // 请求权限成功
//                    // 在这里添加你的代码
//                }
//            }
//            cellData.cellularDataRestrictionDidUpdateNotifier = nil
//        }
    }


}

//public protocol ConnectDelegate {
//    func onConnectSuccess(info: UserInfo);
//    func onConnectFail();
//}
//
//public protocol TransactionDelegate {
//    func onSendSuccess(result: TransactionResult);
//    func onSendFail();
//}

public struct TransactionInfo {
    public init() {
    }
    public var to: String = ""
    public var value: String = ""
    public var data: String = ""
    public var chainId: String = ""
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
    public var paymasterUrl: String?;
    
    public init() {
    }
}

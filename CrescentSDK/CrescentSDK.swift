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
//import Security

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
    }
    
    public static func disconnect() -> Void {
        UserDefaults.standard.removeObject(forKey: EmailBean.SP_EMAIL_KEY)
        UserDefaults.standard.removeObject(forKey: EmailBean.SP_ADDRESS_KEY)
        return;
//        
//
//        let outlookService = "outlook.live.com"
//        let outlookAccount = "test2023abc@outlook.com"
//
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassInternetPassword,
//            kSecAttrServer as String: outlookService,
//            kSecAttrAccount as String: outlookAccount,
//            kSecReturnAttributes as String: true,
//            kSecReturnData as String: false
//        ]
//
//        var item: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &item)
//
//        if status == errSecSuccess {
//            let attributes = item as! [String: Any]
//            let itemToDelete: [String: Any] = [
//                kSecClass as String: kSecClassInternetPassword,
//                kSecAttrServer as String: outlookService,
//                kSecAttrAccount as String: outlookAccount,
//                kSecAttrProtocol as String: kSecAttrProtocolHTTPS,
//                kSecAttrAuthenticationType as String: kSecAttrAuthenticationTypeDefault,
//                kSecUseDataProtectionKeychain as String: true,
//                kSecAttrSynchronizable as String: false
//            ]
//            let deleteStatus = SecItemDelete(itemToDelete as CFDictionary)
//            if deleteStatus == errSecSuccess {
//                print("Outlook account credentials have been deleted from Keychain.")
//            } else {
//                print("Error deleting Outlook account credentials from Keychain: \(deleteStatus)")
//            }
//        } else {
//            print("Outlook account credentials not found in Keychain.")
//        }
//
//
//        let storage = HTTPCookieStorage.shared
//        for cookie in storage.cookies ?? [] {
//            storage.deleteCookie(cookie)
//        }
//
//        let cache = URLCache.shared
//        cache.removeAllCachedResponses()
//        cache.diskCapacity = 0


        
        if #available(iOS 11.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
            
            URLCache.shared.removeAllCachedResponses()

        } else {
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = libraryPath + "/Cookies"
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }


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
    
    static func checkNetworkPermission() {
        if hasWiFiPermission() || hasCellularPermission() {
            // 权限已经被授予
            // 在这里添加你的代码
        } else {
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
            }
            task.resume()
        }
        return;
    }


}

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

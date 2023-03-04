//
//  PopupViewController.swift
//  CrescentSDK
//
//  Created by cyh on 2023/2/10.
//
import UIKit

class PopupViewController: UIViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.blue
        view.frame = CGRect(x: 100, y: 100, width: 200, height: 300)
    }
}

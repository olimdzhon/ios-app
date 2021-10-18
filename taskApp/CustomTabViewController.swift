//
//  CustomTabBar.swift
//  taskApp
//
//  Created by Олимджон Садыков on 16.10.2021.
//

import UIKit

class CustomTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Scan" {
            //do your custom actions
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

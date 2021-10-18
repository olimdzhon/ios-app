//
//  ViewController.swift
//  taskApp
//
//  Created by Олимджон Садыков on 14.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapButton() {
        dismiss(animated: true, completion: nil)
    }
    
}

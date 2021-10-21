//
//  ServicePayment.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import UIKit

class ServicePaymentViewController: UIViewController {
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var amount: UITextField!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceName.text = name
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    @IBAction func backButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonTap(_ sender: UIButton) {
    }
}

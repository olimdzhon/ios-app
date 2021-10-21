//
//  ServicePayment.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import UIKit

class ServicePaymentViewController: UIViewController {
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var amount: UITextField!
    
    var service: ServiceTableViewCellViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceName.text = service?.name
        serviceImage.image = UIImage(data: (service?.imageData)!)
        
        let backgroundViewClick = UITapGestureRecognizer(target: self, action: #selector(backgroundClick(_:)))
        view.addGestureRecognizer(backgroundViewClick)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backgroundClick(_ sender:UITapGestureRecognizer) {
        if amount.isEditing {
            view.endEditing(true)
        }
    }
    
    
    @IBAction func backButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonTap(_ sender: UIButton) {
        view.endEditing(true)
        
        if amount.text == "" || amount.text == "0" {
            let alert = UIAlertController(title: "Error", message: "Amount couldn't equal to 0 or empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Success", message: "You successfully paid $\(amount.text!) for \(service!.name)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}

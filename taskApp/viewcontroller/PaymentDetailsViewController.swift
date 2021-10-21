//
//  PaymentDetailsViewController.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import UIKit

class PaymentDetailsViewController: UIViewController {

    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var toValue: UILabel!
    @IBOutlet weak var fromValue: UILabel!
    @IBOutlet weak var costValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    
    var payment: PaymentTableViewCellViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameValue.text = payment?.name
        toValue.text = payment?.to
        fromValue.text = payment?.from
        costValue.text = payment?.cost
        dateValue.text = payment?.date
    }
    

    @IBAction func didBackButtonTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

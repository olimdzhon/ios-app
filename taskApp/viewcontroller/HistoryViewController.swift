//
//  HistoryViewController.swift
//  taskApp
//
//  Created by Олимджон Садыков on 17.10.2021.
//

import UIKit
import PromiseKit

class HistoryViewController: UIViewController {
    
    var viewModel = PaymentListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PaymentTVC.self, forCellReuseIdentifier: "PaymentTVC")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        
        viewModel.payments.bind { [weak self]_ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        firstly {
            return PaymentRepository.shared.getPayments()
        }
        .then { payments -> Promise<Void> in
            return PaymentManager.shared.addAll(payments: payments)
        }
        .then { _ -> Promise<Void> in
            return PaymentManager.shared.loadServices()
        }
        .then { _ -> Promise<Void> in
            return PaymentManager.shared.loadImages()
        }
        .then { _ -> Promise<[PaymentTableViewCellViewModel]> in
            return PaymentManager.shared.loadAll()
        }
        .done { payments in
            self.viewModel.payments.value = payments
        }
        .catch { error in
            print(error.localizedDescription)
        }
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.payments.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTVC") as! PaymentTVC

        let name = viewModel.payments.value?[indexPath.row].name
        let data = viewModel.payments.value?[indexPath.row].imageData ?? UIImage(named: "topup")?.pngData()
        let date = viewModel.payments.value?[indexPath.row].date
        let cost = viewModel.payments.value?[indexPath.row].cost
        let image = UIImage(data: data!)
        cell.name = name
        cell.image = image
        cell.date = date
        cell.cost = cost
        cell.layoutSubviews()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentDetailsViewController") as! PaymentDetailsViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.payment = viewModel.payments.value?[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    
}

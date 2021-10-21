//
//  HomeViewController.swift
//  taskApp
//
//  Created by Олимджон Садыков on 17.10.2021.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {
    
    var viewModel = ServiceListViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ServiceTVC.self, forCellReuseIdentifier: "ServiceTVC")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        viewModel.services.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
//        firstly {
//            return ServiceManager.shared.delete()
//        }
//        .then { _ in
//            return PaymentManager.shared.delete()
//        }
//        .done { _ in
//            print("deleted")
//        }
//        .catch { error in
//            print(error)
//        }
        
        firstly {
            return ServiceRepository.shared.getServices()
        }
        .then { services -> Promise<Void> in
            return ServiceManager.shared.addAll(services: services)
        }
        .then { _ -> Promise<Void> in
            return ServiceManager.shared.loadServices()
        }
        .then { _ -> Promise<Void> in
            return ServiceManager.shared.loadImages()
        }
        .then { _ -> Promise<[ServiceTableViewCellViewModel]> in
            return ServiceManager.shared.loadAll()
        }
        .done { services in
            self.viewModel.services.value = services
        }
        .catch { error in
            print(error.localizedDescription)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.services.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTVC") as! ServiceTVC

        let name = viewModel.services.value?[indexPath.row].name
        let data = viewModel.services.value?[indexPath.row].imageData
        let image = UIImage(data: data!)
        cell.name = name
        cell.image = image
        cell.layoutSubviews()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ServicePaymentViewController") as! ServicePaymentViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.name = (viewModel.services.value?[indexPath.row].name) ?? ""
        present(vc, animated: true, completion: nil)
    }
    
}

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
        tableView.showsVerticalScrollIndicator = false
        
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
        
        NetworkUtils.shared.online { (err) in
            
            if !err {
                
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
                
            } else {
                ServiceManager.shared.loadAll()
                    .done { services in
                        self.viewModel.services.value = services
                    }
                    .catch { error in
                        print(error.localizedDescription)
                    }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func didScanTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
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
        
        let service = viewModel.services.value?[indexPath.row]
        
        let name = service?.name
        let data = service?.imageData ?? UIImage(named: "placeholder")?.pngData()
        let image = UIImage(data: data!)
        cell.image = image
        cell.name = name
        cell.layoutSubviews()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = viewModel.services.value?[indexPath.row]
        if service?.name == "More" {
            return
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ServicePaymentViewController") as! ServicePaymentViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.service = service
            present(vc, animated: true, completion: nil)
        }
    }
    
}

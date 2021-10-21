//
//  PaymentRepository.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import PromiseKit
import Alamofire

class PaymentRepository {
    static let shared = PaymentRepository()
    
    private init(){}
    
    func getPayments() -> Promise<[PaymentTableViewCellViewModel]> {
        return Promise { seal in
            let request = URLRequest(url: URL(string: "\(Config.SERVER_URL)/getPaymentHistory")!)
            AF.request(request).validate().responseJSON { response in
                switch response.result {
                case .success(_):
                    
                    let paymentModels = try! JSONDecoder().decode([Payment].self, from: response.data!)
                    
                    let payments = paymentModels.compactMap({
                        PaymentTableViewCellViewModel(id: $0.id, name: $0.name, to: $0.to, from: $0.from, cost: $0.cost, date: $0.date)
                    })
                    seal.fulfill(payments)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

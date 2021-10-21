//
//  ServiceRepository.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import PromiseKit
import Alamofire

class ServiceRepository {
    static let shared = ServiceRepository()
    
    private init(){}
    
    func getServices() -> Promise<[ServiceTableViewCellViewModel]> {
        return Promise { seal in
            let request = URLRequest(url: URL(string: "\(Config.SERVER_URL)/getServices")!)
            AF.request(request).validate().responseJSON { response in
                switch response.result {
                case .success(_):
                    
                    let serviceModels = try! JSONDecoder().decode([Service].self, from: response.data!)
                    
                    let services = serviceModels.compactMap({
                        ServiceTableViewCellViewModel(id: $0.id, name: $0.name, image: $0.image)
                    })
                    seal.fulfill(services)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

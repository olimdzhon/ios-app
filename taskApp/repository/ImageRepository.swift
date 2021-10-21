//
//  ImageRepository.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import PromiseKit
import Alamofire

class ImageRepository {
    static let shared = ImageRepository()
    
    private init(){}
    
    func getImage(name: String) -> Promise<Data> {
        return Promise { seal in
            var request = URLRequest(url: URL(string: "\(Config.SERVER_IMAGES)/\(name)")!, cachePolicy: .returnCacheDataElseLoad)
            
            request.timeoutInterval = 10.0
            
            AF.request(request).validate(statusCode:  200..<600)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        seal.fulfill(response.data!)
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}

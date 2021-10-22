//
//  NetworkUtils.swift
//  taskApp
//
//  Created by Олимджон Садыков on 22.10.2021.
//

import Foundation
import Network

class NetworkUtils {
    
    static let shared = NetworkUtils()
    
    private init(){}
    
    func online(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
          var err = true
          defer {
            completion(err)
            monitor.cancel()
          }
          if path.status == .satisfied {
            err = false
          } else {
            err = true
          }
        }
    }
}

//
//  Config.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
class Config {
    static let shared = Config()
    private init(){}

    static let SERVER_ADDRESS = "localhost"
    static let SERVER_PORT = ":3000"
    static let SERVER_URL = "http://\(SERVER_ADDRESS)\(SERVER_PORT)"
    static let SERVER_IMAGES = "http://\(SERVER_ADDRESS)\(SERVER_PORT)/assets/images/"
    
}

//
//  Payment.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation

struct Payment: Codable {
    let id: String
    let name: String
    let to: String
    let from: String
    let cost: String
    let date: String
}

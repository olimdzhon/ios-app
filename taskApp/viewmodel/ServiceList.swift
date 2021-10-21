//
//  ServiceList.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
struct ServiceListViewModel {
    var services: Observable<[ServiceTableViewCellViewModel]> = Observable([])
}

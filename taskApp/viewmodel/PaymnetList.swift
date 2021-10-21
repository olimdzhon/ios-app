//
//  UserList.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation

struct PaymentListViewModel {
    var payments: Observable<[PaymentTableViewCellViewModel]> = Observable([])
}

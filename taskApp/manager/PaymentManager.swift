//
//  PaymentManager.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import CoreStore
import PromiseKit

class PaymentManager {
    
    static let shared = PaymentManager()
    
    private init(){}
    
    private var tempServices: [ServiceTableViewCellViewModel] = []
    
    func addAll(payments: [PaymentTableViewCellViewModel]) -> Promise<Void> {
        return Promise { seal in
            payments.forEach({ payment in
                dataStack.perform(
                    asynchronous: { (transaction) -> Void in
                        let paymentsFromDB = try transaction.fetchAll(From<PaymentEntity>())
                        let samePayment = paymentsFromDB.filter{$0.id == payment.id}.first
                        if (samePayment == nil) {
                            let newPayment = transaction.create(Into<PaymentEntity>())
                            newPayment.id = payment.id
                            newPayment.name = payment.name
                            newPayment.to = payment.to
                            newPayment.from = payment.from
                            newPayment.cost = payment.cost
                            newPayment.date = payment.date
                        }
                    },
                    success: { _ in
                        seal.fulfill_()
                    },
                    failure: { (error) -> Void in
                        seal.reject(error)
                    })
            })
        }
    }
    
    func loadAll() -> Promise<[PaymentTableViewCellViewModel]> {
        return Promise { seal in
            dataStack.perform(
                asynchronous: { (transaction) -> [PaymentTableViewCellViewModel] in
                    let payments = try transaction.fetchAll(From<PaymentEntity>())
                    return payments.map{
                        PaymentTableViewCellViewModel(id: $0.id!,  name: $0.name!, to: $0.to!, from: $0.from!, cost: $0.cost!, date: $0.date!, imageData: $0.imageData)
                    }
                },
                success: { payments in
                    seal.fulfill(payments)
                },
                failure: { (error) -> Void in
                    seal.reject(error)
                })
        }
    }
    
    func loadServices() -> Promise<Void> {
        return Promise { seal in
            dataStack.perform(
                asynchronous: { (transaction) -> Void in
                    let services = try transaction.fetchAll(From<ServiceEntity>())
                    self.tempServices = services.map{
                        ServiceTableViewCellViewModel(id: $0.id!,  name: $0.name!, image: $0.image!, imageData: $0.imageData)
                    }
                },
                success: { _ in
                    seal.fulfill_()
                },
                failure: { (error) -> Void in
                    seal.reject(error)
                })
        }
    }
    
    func loadImages() -> Promise<Void> {
        return Promise { seal in
            self.tempServices.forEach({ service in
                dataStack.perform(
                    asynchronous: { (transaction) -> Void in
                        let updatePayment = try transaction.fetchOne(
                            From<PaymentEntity>()
                                .where(\.name == service.name)
                        )
                        updatePayment?.imageData = service.imageData
                    },
                    success: { _ in
                        seal.fulfill_()
                    },
                    failure: { (error) -> Void in
                        seal.reject(error)
                    })
            })
        }
    }
    
    func delete() -> Promise<Void> {
        return Promise { seal in
            dataStack.perform(
                asynchronous: { (transaction) -> Void in
                    let paymentsFromDB = try transaction.fetchAll(From<PaymentEntity>())
                    transaction.delete(paymentsFromDB)
                },
                success: { _ in
                    seal.fulfill_()
                },
                failure: { (error) -> Void in
                    seal.reject(error)
                })
        }
    }
}

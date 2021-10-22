//
//  ServiceManager.swift
//  taskApp
//
//  Created by Олимджон Садыков on 20.10.2021.
//

import Foundation
import CoreStore
import PromiseKit

class ServiceManager {
    
    static let shared = ServiceManager()
    
    private init(){}
    
    private var tempServices: [ServiceTableViewCellViewModel] = []
    
    func addAll(services: [ServiceTableViewCellViewModel]) -> Promise<Void> {
        return Promise { seal in
            services.forEach({ service in
                dataStack.perform(
                    asynchronous: { (transaction) -> Void in
                        let servicesFromDB = try transaction.fetchAll(From<ServiceEntity>())
                        let sameService = servicesFromDB.filter{$0.id == service.id}.first
                        if (sameService == nil) {
                            let newService = transaction.create(Into<ServiceEntity>())
                            newService.id = service.id
                            newService.name = service.name
                            newService.image = service.image
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
    
    func loadAll() -> Promise<[ServiceTableViewCellViewModel]> {
        return Promise { seal in
            dataStack.perform(
                asynchronous: { (transaction) -> [ServiceTableViewCellViewModel] in
                    let services = try transaction.fetchAll(From<ServiceEntity>())
                    return services.map{
                        ServiceTableViewCellViewModel(id: $0.id!,  name: $0.name!, image: $0.image!, imageData: $0.imageData)
                    }
                },
                success: { services in
                    seal.fulfill(services)
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
                        ServiceTableViewCellViewModel(id: $0.id!,  name: $0.name!, image: $0.image!)
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
                firstly {
                    return ImageRepository.shared.getImage(name: service.image)
                }
                .done { data in
                    dataStack.perform(
                        asynchronous: { (transaction) -> Void in
                            let newService = try transaction.fetchOne(
                                From<ServiceEntity>()
                                    .where(\.id == service.id)
                            )
                            newService!.imageData = data
                        },
                        success: { _ in
                            seal.fulfill_()
                        },
                        failure: { (error) -> Void in
                            seal.reject(error)
                        })
                }
                .catch { error in
                    print(error)
                }
            })
        }
    }
    
    func delete() -> Promise<Void> {
        return Promise { seal in
            dataStack.perform(
                asynchronous: { (transaction) -> Void in
                    let servicesFromDB = try transaction.fetchAll(From<ServiceEntity>())
                    transaction.delete(servicesFromDB)
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

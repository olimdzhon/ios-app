//
//  ServiceEntity+CoreDataProperties.swift
//  
//
//  Created by Олимджон Садыков on 20.10.2021.
//
//

import Foundation
import CoreData


extension ServiceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceEntity> {
        return NSFetchRequest<ServiceEntity>(entityName: "ServiceEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?

}

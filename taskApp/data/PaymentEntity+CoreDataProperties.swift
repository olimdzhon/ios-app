//
//  PaymentEntity+CoreDataProperties.swift
//  
//
//  Created by Олимджон Садыков on 20.10.2021.
//
//

import Foundation
import CoreData


extension PaymentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentEntity> {
        return NSFetchRequest<PaymentEntity>(entityName: "PaymentEntity")
    }

    @NSManaged public var cost: String?
    @NSManaged public var date: String?
    @NSManaged public var from: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var to: String?
    @NSManaged public var imageData: Data?

}

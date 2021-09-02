//
//  Person+CoreDataProperties.swift
//  swift-028-CWC_coredata_demo
//
//  Created by Luiz Carlos da Silva Araujo on 02/09/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var family: Family?

}

extension Person : Identifiable {

}

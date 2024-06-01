//
//  VenueCD+CoreDataClass.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//
//

import Foundation
import CoreData

@objc(VenueCD)
public class VenueCD: NSManagedObject {

}
extension VenueCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VenueCD> {
        return NSFetchRequest<VenueCD>(entityName: "VenueCD")
    }

    @nonobjc class func deleteAll() -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<VenueCD>(entityName: "\(VenueCD.self)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        return deleteRequest
    }
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var displayLocation: String?

}

extension VenueCD : Identifiable {

}

extension VenueCD {
    func convertToVenue() -> Venue {
        return Venue(name: name ?? "", id: Int(id), displayLocation: displayLocation ?? "")
    }
}

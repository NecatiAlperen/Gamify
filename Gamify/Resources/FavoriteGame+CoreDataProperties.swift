//
//  FavoriteGame+CoreDataProperties.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 25.05.2024.
//
//

import Foundation
import CoreData


extension FavoriteGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteGame> {
        return NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
    }

    @NSManaged public var backgroundImageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?

}

extension FavoriteGame : Identifiable {

}

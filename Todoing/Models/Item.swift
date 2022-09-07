//
//  Item.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/7/22.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // reverse relationship
    var parentList = LinkingObjects(fromType: UserList.self, property: "items")
}

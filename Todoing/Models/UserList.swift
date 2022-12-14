//
//  UserList.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/7/22.
//

import Foundation
import RealmSwift

class UserList: Object {
    // @objc dynamic allows you to monitor for changes while app runs
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    
    // forward relationship
    let items = List<Item>()
}

//
//  UserList.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/7/22.
//

import Foundation
import RealmSwift

class UserList: Object {
    @objc dynamic var name: String = ""
    // forward relationship
    let items = List<Item>()
}

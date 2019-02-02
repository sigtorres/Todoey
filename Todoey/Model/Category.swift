//
//  Category.swift
//  Todoey
//
//  Created by Nelson Torres on 1/27/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var cellBackgroundHex : String = ""
    
    let items = List<Item>()
    
}

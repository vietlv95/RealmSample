//
//  People.swift
//  RealmSample
//
//  Created by ngo van do on 18/07/2021.
//

import Foundation
import RealmSwift

class People: Object {
    @objc dynamic var id: String!
    @objc dynamic var name: String!
    @objc dynamic var phone: String!
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

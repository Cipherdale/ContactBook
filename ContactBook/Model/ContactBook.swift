//
//  ContactBook.swift
//  ContactBook
//
//  Created by Andrian Yohanes on 8/6/17.
//  Copyright © 2017 episquare. All rights reserved.
//

import Foundation
import RealmSwift

class ContactBook: Object {
    @objc dynamic var name: String?
    @objc dynamic var phoneNumber: String?
    
    convenience init(name: String, phoneNumber: String) {
        self.init()
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

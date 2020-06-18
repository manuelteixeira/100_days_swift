//
//  Note.swift
//  Projects 19-21
//
//  Created by Manuel Teixeira on 18/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import Foundation

class Note: Codable {
    let id: String
    var title: String?
    var date: Date?
    var body: String?
    
    init(title: String?, date: Date?, body: String?) {
        self.id = UUID().uuidString
        self.title = title
        self.date = date
        self.body = body
    }
    
    convenience init() {
        self.init(title: nil, date: Date(), body: nil)
    }
}

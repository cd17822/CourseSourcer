//
//  Assignment.swift
//  CourseSourcer
//
//  Created by Charlie on 6/10/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object {
    dynamic var id: String = ""
    dynamic var created_at: Date?
    dynamic var title: String = ""
    dynamic var type: String = ""
    dynamic var time_begin: Date = Date() // also due date
    dynamic var time_end: Date? // will be nil for assignments but not exams
    dynamic var notes: String?
    dynamic var score: Int = 0
    dynamic var user_handle: String?
    
    dynamic var course: Course?
    
    override static func primaryKey() -> String {
        return "id"
    }
}

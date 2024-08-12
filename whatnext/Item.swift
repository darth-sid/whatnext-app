//
//  Item.swift
//  whatnext
//
//  Created by Sid Ajay on 8/11/24.
//

import Foundation
import SwiftData

@Model
class Task {
    @Attribute(.unique) let id = UUID()
    var content: String
    var timed: Bool = false
    var alarm: Bool = false
    var time: Date
    
    init(content: String="", time: Date = Date.now){
        self.content = content
        self.time = time
    }
    
    func toggleTime(){
        self.timed = !self.timed
    }
    
    func toggleAlarm(){
        self.alarm = !self.alarm
    }
}

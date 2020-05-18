//
//  WorkoutExerciseStruct.swift
//  Workouts
//
//  Created by Hubert Choo on 8/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import Foundation

class WorkoutExerciseStruct: NSObject, NSCoding {
    
    var name : String = ""
    var sets: String?
    var reps : String?
    var rest : String?
    
    init(name: String, sets: String?, reps: String?, rest: String?) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.rest = rest
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(sets, forKey: "sets")
        coder.encode(reps, forKey: "reps")
        coder.encode(rest, forKey: "rest")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        sets = coder.decodeObject(forKey: "sets") as? String ?? ""
        reps = coder.decodeObject(forKey: "reps") as? String ?? ""
        rest = coder.decodeObject(forKey: "rest") as? String ?? ""
        }
}

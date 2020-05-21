//
//  ExerciseModel.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

struct ExerciseModel {
    var index: Int
    let name: String
    var date: Date?
    
    init(index: Int, name: String, date: Date?) {
        self.index = index
        self.name = name
        self.date = date
    }
    
    init(copy: ExerciseModel) {
        self.name = copy.name
        self.date = copy.date
        self.index = copy.index
    }
    
    //MARK: - Public
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .short
        
        guard let exerciseDate = self.date else { return "" }
        
        return dateFormatter.string(from: exerciseDate)
    }
}

extension ExerciseModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date && lhs.index == rhs.index
    }
}

//
//  MyExercisesModelView.swift
//  MVVM
//
//  Created by admin on 20.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

protocol MyExercisesModelViewProtocol: class {
    
    var title: String { get }
    var viewModelDidChanged: ((MyExercisesModelViewProtocol) -> Void)? {get set}
    
    func numberOfMyExercises() -> Int
    func updateUI() -> Void
    func updateTableViewIfNeeded() -> Void
    func getExerciseModelView(at index: Int) -> ExerciseModelView
    func removeExercise(byIndex index: Int) -> Void
    
}

class MyExercisesModelView: NSObject, MyExercisesModelViewProtocol {
    
    var title: String {
        get {
            return "My Exercises"
        }
    }
    var viewModelDidChanged: ((MyExercisesModelViewProtocol) -> Void)?
    
    private var myExercises: [ExerciseModel]
    
    override init() {
        self.myExercises = CoreDataService.shared.fetchMyExercises()
        
        super.init()
    }

    func updateUI() {
        self.viewModelDidChanged?(self)
    }
    
    func updateTableViewIfNeeded() {
        let newMyExercises = CoreDataService.shared.fetchMyExercises()
        if newMyExercises != self.myExercises {
            self.myExercises = newMyExercises
            self.viewModelDidChanged?(self)
        }
    }
    
    func numberOfMyExercises() -> Int {
        return self.myExercises.count
    }
    
    func getExerciseModelView(at index: Int) -> ExerciseModelView {
        return ExerciseModelView(exerciseModel: self.myExercises[index])
    }
    
    func removeExercise(byIndex index: Int) -> Void {
        self.myExercises.remove(at: index)
        CoreDataService.shared.removeMyExercise(byIndex: index)
        
        for i in index..<self.myExercises.count {
            self.myExercises[i].index -= 1
        }
    }
    
}

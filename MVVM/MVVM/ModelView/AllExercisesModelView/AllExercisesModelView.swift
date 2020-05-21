//
//  AllExercisesModelView.swift
//  MVVM
//
//  Created by admin on 20.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol AllExercisesModelViewProtocol {
    
    var title: String { get }
    var viewModelDidChanged: ((AllExercisesModelViewProtocol) -> Void)? {get set}
    
    func numberOfAllExercises() -> Int
    func nameOfExercises(by index: Int) -> String
    func addExercise(atIndex index: Int) -> Void
    func filterAllExercises(byText text: String) -> Void
}

class AllExercisesModelView: NSObject, AllExercisesModelViewProtocol {
    
    var title: String {
        return "All exercises"
    }
    
    var viewModelDidChanged: ((AllExercisesModelViewProtocol) -> Void)?
    
    private var allExercises: [ExerciseModel]
    private var filterAllExercises: [ExerciseModel] {
        didSet {
            self.viewModelDidChanged?(self)
        }
    }
    
    override init() {
        self.allExercises = CoreDataService.shared.fetchAllExercises()
        self.filterAllExercises = self.allExercises
        
        super.init()
    }
    
    func numberOfAllExercises() -> Int {
        return self.filterAllExercises.count
    }
    
    func nameOfExercises(by index: Int) -> String {
        return self.filterAllExercises[index].name
    }
    

    func filterAllExercises(byText text: String) -> Void {
        if text.count == 0 {
            self.filterAllExercises = self.allExercises
        } else {
            self.filterAllExercises = self.allExercises.filter({ (exerciseModel) -> Bool in
                return exerciseModel.name.lowercased().contains(text.lowercased())
            })
        }
    }
    
    func addExercise(atIndex index: Int) -> Void {
        var exerciseModel = self.filterAllExercises[index]
        exerciseModel.date = Date()
        
        CoreDataService.shared.addToMyExercise(exerciseModel: exerciseModel)
    }
}

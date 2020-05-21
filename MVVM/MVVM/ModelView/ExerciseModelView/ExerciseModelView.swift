//
//  ExerciseModelView.swift
//  MVVM
//
//  Created by admin on 20.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol ExerciseViewModelProtocol {
    
    var index: String { get set }
    var name: String { get }
    var date: String { get }
    var viewModelDidChanged: ((ExerciseViewModelProtocol) -> Void)? {get set}
    
    init (exerciseModel: ExerciseModel)
}

class ExerciseModelView: ExerciseViewModelProtocol {
    
    var viewModelDidChanged: ((ExerciseViewModelProtocol) -> Void)?
    
    private var exerciseModel: ExerciseModel
    
    var index: String {
        get {
            return String(self.exerciseModel.index)
        }
        set {
            self.viewModelDidChanged?(self)
        }
    }
    var name: String {
        return self.exerciseModel.name
    }
    var date: String {
        return self.exerciseModel.getFormattedDate()
    }
    
    required init(exerciseModel: ExerciseModel) {
        self.exerciseModel = exerciseModel
    }
}

//
//  CoreDataService.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import CoreData
import UIKit

class CoreDataService: NSObject {
    
    static let shared = CoreDataService()
    
    let appDelegate: AppDelegate?
    let persistentContainer: NSPersistentContainer?
    
    private var allExercises = [ExerciseModel]()
    private var myExercises = [ExerciseModel]()
    
    private override init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
            self.persistentContainer = appDelegate.persistentContainer
        } else {
            self.appDelegate = nil
            self.persistentContainer = nil
        }
        
        super.init()
    }
    
    //MARK: - Public
    
    func allExercise(byIndex index: Int) -> ExerciseModel {
        return self.allExercises[index]
    }
    
    func myExercise(byIndex index: Int) -> ExerciseModel {
        return self.myExercises[index]
    }
    
    func fetchMyExercises() -> [ExerciseModel] {
        if !self.myExercises.isEmpty {
            return self.myExercises
        }
        
        let fetchRequest: NSFetchRequest<MyExercise> = MyExercise.fetchRequest()
        var exercises: [MyExercise]?
        do {
            if let allExercise = try self.persistentContainer?.viewContext.fetch(fetchRequest) {
                exercises = allExercise
            } else {
                exercises = [MyExercise]()
            }

        } catch let error {
            print(error.localizedDescription)
            return [ExerciseModel]()
        }
        
        var preparedModels = [ExerciseModel]()
        var index = 1
        for exercise in exercises! {
            preparedModels.append(ExerciseModel(index: index, name: exercise.name!, date: exercise.date))
            index += 1
        }
        
        self.myExercises = preparedModels
        return preparedModels
    }
    
    func addToMyExercise(exerciseModel: ExerciseModel) -> Void {
        if let context = self.persistentContainer?.viewContext {
            let myExercise = MyExercise(context: context)
            myExercise.date = exerciseModel.date
            myExercise.name = exerciseModel.name
            
            var newExerciseModel = ExerciseModel(copy: exerciseModel)
            newExerciseModel.index = self.myExercises.count + 1
            self.myExercises.append(newExerciseModel)
            
            self.appDelegate?.saveContext()
        }
    }
    
    func removeMyExercise(byIndex index: Int) -> Void {
        let exerciseModel: ExerciseModel = self.myExercise(byIndex: index)
        let fetchRequest: NSFetchRequest<MyExercise> = MyExercise.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", exerciseModel.date! as NSDate)
        
        do {
            let exercises = try self.persistentContainer?.viewContext.fetch(fetchRequest)
            guard let exercise = exercises?.first else { return }
            self.persistentContainer?.viewContext.delete(exercise)
            self.myExercises.remove(at: index)
            self.appDelegate?.saveContext()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllExercises() -> [ExerciseModel] {
        if !self.allExercises.isEmpty {
            return self.allExercises
        }
        
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        var exercises: [Exercise]?
        do {
            if let allExercise = try self.persistentContainer?.viewContext.fetch(fetchRequest) {
                exercises = allExercise
                if allExercise.isEmpty {
                    exercises = try self.fillExerciseCoreData()
                }
            } else {
                exercises = [Exercise]()
            }

        } catch let error {
            print(error.localizedDescription)
            return [ExerciseModel]()
        }
        
        var preparedModels = [ExerciseModel]()
        for exercise in exercises! {
            preparedModels.append(ExerciseModel(index: -1, name: exercise.name!, date: nil))
        }
        
        self.allExercises = preparedModels
        return preparedModels
    }
    
    //MARK: - Fill core data
    
    func fillExerciseCoreData() throws -> [Exercise] {
        guard let context = self.persistentContainer?.viewContext else { fatalError("Cant found context") }
        
        let listOfExercises = [
            "Back Fly",
            "Squat",
            "Leg press",
            "Deadlift",
            "Leg extension",
            "Wall sit",
            "Leg curl",
            "Stiff-Legged Deadlift",
            "Snatch",
            "Standing calf raise",
            "Seated calf raise",
            "Back extension",
        ]
        
        var exercises = [Exercise]()
        for exerciseName in listOfExercises {
            let exercise = Exercise(context: context)
            exercise.name = exerciseName
            exercises.append(exercise)
        }
        
        self.appDelegate?.saveContext()
        
        return exercises
    }
}

//
//  RouterService.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RouterService: NSObject {
    
    static let shared = RouterService()
    let navigationController: UINavigationController
    
    private override init() {
        self.navigationController = UINavigationController()
        
        super.init()
        
        self.prepareUINavigationController(navigationController: self.navigationController)
    }
    
    //MARK: - Private
    
    private func prepareUINavigationController(navigationController: UINavigationController) -> Void {
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.barTintColor = UIColor(red: 10.0 / 255.0, green: 132.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        navigationController.navigationBar.tintColor = UIColor.white
    }
    
    //MARK: - Public
    
    func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifier)
    }
    
    func pushMyExercisesViewController() -> Void {
        let myExercisesViewController =
            self.getViewController(withIdentifier: NSStringFromClass(MyExercisesViewController.self)) as! MyExercisesViewController
        myExercisesViewController.modelView = MyExercisesModelView()
        
        self.navigationController.pushViewController(myExercisesViewController, animated: true)
    }
    
    func presentAllExercisesViewController() -> Void {
        let allExercisesViewController = self.getViewController(withIdentifier: NSStringFromClass(AllExercisesViewController.self)) as! AllExercisesViewController
        allExercisesViewController.modelView = AllExercisesModelView()
        let navigationControllerForModalView = UINavigationController(rootViewController: allExercisesViewController)
        self.prepareUINavigationController(navigationController: navigationControllerForModalView)
        
        navigationControllerForModalView.modalPresentationStyle = .fullScreen
        navigationControllerForModalView.modalTransitionStyle = .coverVertical
        self.navigationController.present(navigationControllerForModalView, animated: true, completion: nil)
    }
    
}

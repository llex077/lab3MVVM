//
//  ViewController.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol MyExercisesViewControllerProtocol: class {
    
    func setEmptySate() -> Void
    func removeEmptyState() -> Void
    func updateTableView() -> Void
}

class MyExercisesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIControl!
    
    var modelView: MyExercisesModelViewProtocol! {
        didSet {
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                guard let self = self else { return }
                if viewModel.numberOfMyExercises() > 0 {
                    self.removeEmptyState()
                    self.updateTableView()
                } else {
                    self.setEmptySate()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.modelView.title
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        
        self.prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.modelView.updateTableViewIfNeeded()
        
    }
    
    //MARK: - Private
    
    private func prepareUI() -> Void {
        self.modelView.updateUI()
        self.addExerciseButton.layer.cornerRadius = self.addExerciseButton.bounds.height / 2.0
        self.addExerciseButton.clipsToBounds = true
    }
    
    private func removeEmptyState() {
        self.tableView.superview!.bringSubviewToFront(self.tableView)
    }
    
    private func setEmptySate() -> Void {
        self.tableView.superview!.sendSubviewToBack(self.tableView)
    }
    
    private func updateTableView() -> Void {
        self.tableView.reloadData()
    }
    
    //MARK: - Action
    
    @IBAction func tapToAddButton(_ sender: Any) {
        RouterService.shared.presentAllExercisesViewController()
    }
    
}

extension MyExercisesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelView.numberOfMyExercises()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.reuseIdentifier) as! ExerciseTableViewCell
        cell.modelView = self.modelView.getExerciseModelView(at: indexPath.row)
        
        return cell
    }
    
}

extension MyExercisesViewController: UITableViewDelegate {
    
    static let visibleCellInTable:CGFloat = 9
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / MyExercisesViewController.visibleCellInTable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.modelView.removeExercise(byIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            self.updateTableView()
        }
    }
    
}


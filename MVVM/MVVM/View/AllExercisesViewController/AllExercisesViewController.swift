//
//  AllExercisesViewController.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class AllExercisesViewController: UIViewController {
    
    var modelView: AllExercisesModelViewProtocol! {
        didSet {
            self.title = self.modelView.title
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                self?.tableView.reloadData()
            }
        }
    }
    
    private let cellReuseIdentifier = "cellOfExercise"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.modelView.title
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.setupNavigationBar()
        self.prepareUI()
    }
    
    //MARK: - Private
    
    private func prepareUI() -> Void {
        
    }
    
    private func setupNavigationBar() -> Void {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapToCancelButton(_:)))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
    }
    
    @objc
    private func tapToCancelButton(_: UIBarButtonItem?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllExercisesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelView.numberOfAllExercises()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!
        cell.textLabel?.text = self.modelView.nameOfExercises(by: indexPath.row)

        return cell
    }
}

extension AllExercisesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.modelView.addExercise(atIndex: indexPath.row)
        self.tapToCancelButton(nil)
    }

}

extension AllExercisesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.modelView.filterAllExercises(byText: searchText)
    }

}

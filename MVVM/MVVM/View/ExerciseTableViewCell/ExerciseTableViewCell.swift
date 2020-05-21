//
//  WorkoutTableViewCell.swift
//  MVP
//
//  Created by admin on 19.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "cellOfExercise"
    var modelView: ExerciseViewModelProtocol! {
        didSet {
            self.indexLabel.text = self.modelView.index
            self.nameLabel.text = self.modelView.name
            self.dateLabel.text = self.modelView.date
            self.modelView.viewModelDidChanged = { [unowned self] viewModel in
                self.indexLabel.text = viewModel.index
            }
        }
    }
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateCellUI()
    }
    
    //MARK: - Private
    
    private func updateCellUI() -> Void {
        self.indexLabel.layer.cornerRadius = self.indexLabel.bounds.height / 2.0
        self.indexLabel.clipsToBounds = true
    }
}

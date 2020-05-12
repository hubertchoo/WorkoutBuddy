//
//  ExSelectedTableViewCell.swift
//  Workouts
//
//  Created by Hubert Choo on 6/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit


class ExSelectedTableViewCell: UITableViewCell {


    @IBOutlet weak var ExNameField: UITextField!
    @IBOutlet weak var SetsField: UITextField!
    @IBOutlet weak var RestField: UITextField!
    @IBOutlet weak var RepsField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        RestField.addDoneButtonToKeyboard(myAction:  #selector(self.RestField.resignFirstResponder))
        RepsField.addDoneButtonToKeyboard(myAction:  #selector(self.RepsField.resignFirstResponder))
        SetsField.addDoneButtonToKeyboard(myAction:  #selector(self.SetsField.resignFirstResponder))
    }

}

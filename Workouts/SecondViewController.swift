//
//  SecondViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 5/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var ExTableView: UITableView!
    var ex_names = ["Chest Press", "Situp", "Pull ups"]

    override func viewDidLoad() {
        super.viewDidLoad()
        ExTableView.delegate = self
        ExTableView.dataSource = self
        // Do any additional setup after loading the view.

    }
    // MARK: TABLEVIEW functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ex_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExTableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = ex_names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        ex_names.remove(at: indexPath.row)
        ExTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Add exercise functions
        
    @IBAction func add_exercise(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Insert Exercise", message: nil, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Exercise Name"
        }

        // TODO: Input validation for strings
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let result : String = textField!.text!
            self.ex_names.append(result)
            self.ExTableView.reloadData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    

}



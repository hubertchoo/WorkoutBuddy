//
//  ThirdViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 6/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    //ex_selected is an array of struct WorkoutExerciseStruct

    var ex_selected = [WorkoutExerciseStruct]()
    @IBOutlet weak var WorkoutNameField: UITextField!
    @IBOutlet weak var ExSelectedTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ExSelectedTable.delegate = self
        ExSelectedTable.dataSource = self
        ExSelectedTable.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
        // Do any additional setup after loading the view.
        self.WorkoutNameField.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ex_selected.count+1)
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ex_selected.count{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewExerciseCell", for: indexPath)
            return cell
        } else {
            let cell = ExSelectedTable.dequeueReusableCell(withIdentifier: "ExSelectedCell", for: indexPath) as! ExSelectedTableViewCell
           
           // Configure the cell...
            cell.ExNameField?.text = ex_selected[indexPath.row].name
            cell.SetsField?.text = ex_selected[indexPath.row].sets
            cell.RepsField?.text = ex_selected[indexPath.row].reps
            cell.RestField?.text = ex_selected[indexPath.row].rest
            
            cell.selectionStyle = .none
            return cell
        }
       }
       
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           ex_selected.remove(at: indexPath.row)
           ExSelectedTable.deleteRows(at: [indexPath], with: .fade)
           }
       }
    
    @IBAction func unwindToThirdView(segue: UIStoryboardSegue){
        if segue.identifier == "unwindToThirdView"{
            let dest = segue.source as! FourthViewController
//            let indexPath = dest.ExForSelectionTable.indexPathForSelectedRow
            let new_ex = WorkoutExerciseStruct(name: dest.selectedExercise, sets: nil, reps: nil, rest: nil)
            ex_selected.append(new_ex)
            ExSelectedTable.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == ex_selected.count {
            ExSelectedTable.deselectRow(at: indexPath, animated: true)
        }
    }
        

    @IBAction func CreateWorkout(_ sender: Any) {
        //Validate that all fields are filled
        var validateSuccess = true
        var cells = ExSelectedTable.visibleCells
        cells.removeLast()
        let new_cells: [ExSelectedTableViewCell] = cells.map { $0 as! ExSelectedTableViewCell }
        var currCellIndex = 0
        for cell in new_cells{
            if cell.SetsField.text == ""{
                validateSuccess = false
                break
            } else{
                ex_selected[currCellIndex].sets = cell.SetsField.text
            }
            if cell.RepsField.text == ""{
                validateSuccess = false
                break
            } else{
                ex_selected[currCellIndex].reps = cell.RepsField.text
            }
            if cell.RestField.text == ""{
                validateSuccess = false
                break
            } else{
                ex_selected[currCellIndex].rest = cell.RestField.text
            }
            currCellIndex += 1
        }
        if validateSuccess{
            //if all fields are filled
            //edit ex_selected to update sets, reps, rest amounts
            performSegue(withIdentifier: "unwindToFirst", sender: sender)
        } else {
            //show alert for all cells to be filled
            let alert = UIAlertController(title: "Creation Failed", message: "Not all fields are filled", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExerciseSegue"{
            
            //save info of the previous added exercises
            var tempCells = ExSelectedTable.visibleCells
            tempCells.removeLast()
            let new_cells: [ExSelectedTableViewCell] = tempCells.map { $0 as! ExSelectedTableViewCell }
            var currCellIndex = 0
            for cellA in new_cells{
                ex_selected[currCellIndex].sets = cellA.SetsField.text
                ex_selected[currCellIndex].reps = cellA.RepsField.text
                ex_selected[currCellIndex].rest = cellA.RestField.text
                currCellIndex += 1
            }
            
            //prepare available exercises for FourthViewController
            let dest = segue.destination as! FourthViewController
            let tabBarViewControllers = tabBarController?.viewControllers
            let vc2 = tabBarViewControllers?[1] as! SecondViewController
            dest.exercises = vc2.ex_names
            dest.prevView = "Third"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

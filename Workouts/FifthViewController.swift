//
//  FifthViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 8/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//
import UIKit

class FifthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    


    @IBOutlet weak var StartWorkoutButton: UIButton!
    @IBOutlet weak var NavItem: UINavigationItem!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var WorkoutNameField: UITextField!
    @IBOutlet weak var ExInWorkoutTable: UITableView!
    var backButton : UIBarButtonItem? = nil
    var prevSelExercises = [WorkoutExerciseStruct]()
    //newSelExercises is the latests edits
    //selExercises is the last save.
    var selExercises =  [WorkoutExerciseStruct]()
    var workoutName: String = ""
    var workoutIndex = 0
    //workoutIndex is the index of the current selected workout in the array of all workouts, 'workouts' in FirstViewController
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExInWorkoutTable.delegate = self
        ExInWorkoutTable.dataSource = self
        WorkoutNameField.text = workoutName
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        WorkoutNameField.delegate = self
        ExInWorkoutTable.allowsSelectionDuringEditing = true
        
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        prevSelExercises = selExercises
        SaveButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.showSaveButton), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func showSaveButton() {
        if hasUnsavedChanges(){
            SaveButton.isHidden = false
        } else {
            SaveButton.isHidden = true
        }
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem){
        if hasUnsavedChanges(){
            let alert = UIAlertController(title: "Unsaved Changes!", message: "Save before exit or all changes will be lost.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Exit without save", style: .default, handler: {(a) in self.navigationController?.popViewController(animated: true)}))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindSaveChanges", sender: self)
            //self.navigationController?.popViewController(animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if ExInWorkoutTable.isEditing{
            return selExercises.count + 1
        }
        return selExercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ExInWorkoutTable.isEditing && indexPath.row == selExercises.count{
            let cell = ExInWorkoutTable.dequeueReusableCell(withIdentifier: "AddNewExerciseCell", for: indexPath)
            return cell
        }
        let cell = ExInWorkoutTable.dequeueReusableCell(withIdentifier: "ExSelectedCell", for: indexPath) as! ExSelectedTableViewCell

        // Configure the cell...
        cell.ExNameField?.text = selExercises[indexPath.row].name
        cell.SetsField?.text = selExercises[indexPath.row].sets
        cell.RepsField?.text = selExercises[indexPath.row].reps
        cell.RestField?.text = selExercises[indexPath.row].rest
    
        cell.showsReorderControl = true
        cell.selectionStyle = .none
        
        if ExInWorkoutTable.isEditing{
            cell.RepsField.isHidden = true
            cell.RestField.isHidden = true
            cell.SetsField.isHidden = true
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == selExercises.count{
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = selExercises[sourceIndexPath.row]
        selExercises.remove(at: sourceIndexPath.row)
        selExercises.insert(itemToMove, at: destinationIndexPath.row)
    }
    

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == selExercises.count{
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
 

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        selExercises.remove(at: indexPath.row)
        ExInWorkoutTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if ExInWorkoutTable.isEditing{
            return .delete
        }
        return .none
    }


    @IBOutlet weak var EditButton: UIButton!
    
    var unsavedChangesBeforeEditMode = false
    
    @IBAction func editMode(){
        
        if ExInWorkoutTable.isEditing{
            //starts timer for save button check again
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.showSaveButton), userInfo: nil, repeats: true)
            if unsavedChangesBeforeEditMode{
               SaveButton.isHidden = false
            }
            
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.navigationItem.leftBarButtonItem = backButton
            EditButton.setTitle("Edit", for: .normal)
            StartWorkoutButton.setTitle("Start Workout", for: .normal)
            var cells = ExInWorkoutTable.visibleCells
            cells.removeLast()
            let new_cells: [ExSelectedTableViewCell] = cells.map { $0 as! ExSelectedTableViewCell }
            for cell in new_cells {
                cell.SetsField.isHidden = false
                cell.RepsField.isHidden = false
                cell.RestField.isHidden = false
            }


        } else {
            //edits to data of view. remember all previously made edits before the 'edit' click
            //without this, previous edits to textfields will not be remembered
            unsavedChangesBeforeEditMode = hasUnsavedChanges()
            //shuts down timer for save button check as save button will be hidden in edit mode anyways
            timer.invalidate()
            timer = Timer()
            let cells = ExInWorkoutTable.visibleCells as! Array<ExSelectedTableViewCell>
            var currCellIndex = 0
            for cell in cells{
                selExercises[currCellIndex].sets = cell.SetsField.text
                selExercises[currCellIndex].reps = cell.RepsField.text
                selExercises[currCellIndex].rest = cell.RestField.text
                currCellIndex += 1
                
                
                //visual edit
                cell.SetsField.isHidden = true
                cell.RepsField.isHidden = true
                cell.RestField.isHidden = true
            }
            
            //edits to visual of view
            SaveButton.isHidden = true
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            EditButton.setTitle("Done", for: .normal)
            StartWorkoutButton.setTitle("Delete Workout", for: .normal)
        }
        ExInWorkoutTable.isEditing = !ExInWorkoutTable.isEditing
        ExInWorkoutTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == selExercises.count{
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExerciseSegue"{
            
            //save info of the previous added exercises
            var tempCells = ExInWorkoutTable.visibleCells
            tempCells.removeLast()
            let new_cells: [ExSelectedTableViewCell] = tempCells.map { $0 as! ExSelectedTableViewCell }
            var currCellIndex = 0
            for cellA in new_cells{
                selExercises[currCellIndex].sets = cellA.SetsField.text
                selExercises[currCellIndex].reps = cellA.RepsField.text
                selExercises[currCellIndex].rest = cellA.RestField.text
                currCellIndex += 1
            }
            
            //prepare available exercises for FourthViewController
            let dest = segue.destination as! FourthViewController
            let tabBarViewControllers = tabBarController?.viewControllers
            let vc2 = tabBarViewControllers?[1] as! SecondViewController
            dest.exercises = vc2.ex_names
            dest.prevView = "Fifth"
        }
        
        if segue.identifier == "startWorkoutSegue" {
            let dest = segue.destination as! FirstViewController
            dest.workoutToStart = workoutIndex
        }
    }
    
    @IBAction func unwindToWorkoutPage(segue: UIStoryboardSegue){
        if segue.identifier == "unwindToWorkoutPage"{
            let dest = segue.source as! FourthViewController
            let indexPath = dest.ExForSelectionTable.indexPathForSelectedRow
            let new_ex = WorkoutExerciseStruct(name: dest.exercises[indexPath!.row], sets: nil, reps: nil, rest: nil)
            selExercises.append(new_ex)
            ExInWorkoutTable.reloadData()
        }
    }

    func validateFieldsFilled() -> Bool {
        var validateSuccess = true
        //first validate workoutname
        if WorkoutNameField.text == ""{
            validateSuccess = false
        }
        workoutName = WorkoutNameField.text!
        //validate cell inputs
        let cells = ExInWorkoutTable.visibleCells as! Array<ExSelectedTableViewCell>
        var currCellIndex = 0
        for cell in cells{
            if cell.SetsField.text == ""{
                validateSuccess = false
                break
            } else{
                selExercises[currCellIndex].sets = cell.SetsField.text
            }
            if cell.RepsField.text == ""{
                validateSuccess = false
                break
            } else{
                selExercises[currCellIndex].reps = cell.RepsField.text
            }
            if cell.RestField.text == ""{
                validateSuccess = false
                break
            } else{
                selExercises[currCellIndex].rest = cell.RestField.text
            }
            currCellIndex += 1
        }
        return validateSuccess
    }
    
    @IBAction func saveChanges(){
    //Validate that all fields are filled
        
        if validateFieldsFilled(){
            //if all fields are filled
            //edit ex_selected to update sets, reps, rest amounts
            prevSelExercises = selExercises
            let alert = UIAlertController(title: "Save Successful", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
              // your code with delay
              alert.dismiss(animated: true, completion: nil)
            }
        } else {
            //show alert for all cells to be filled
            let alert = UIAlertController(title: "Save Failed", message: "Not all fields are filled!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
              // your code with delay
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //returns true is any changes are yet to be saved. Does so by comparing between the current state and the previous saved state
    func hasUnsavedChanges() -> Bool {
        var result = false
        if WorkoutNameField.text != workoutName{
            result = true
        }
        if result{
            return result
        }
        //validate cell inputs
        let cells = ExInWorkoutTable.visibleCells as! Array<ExSelectedTableViewCell>
        var currCellIndex = 0
        for cell in cells{
            if cell.ExNameField.text != prevSelExercises[currCellIndex].name{
                result = true
                break
            }
            if cell.SetsField.text != prevSelExercises[currCellIndex].sets{
                result = true
                break
            }
            if cell.RepsField.text != prevSelExercises[currCellIndex].reps{
                result = true
                break
            }
            if cell.RestField.text != prevSelExercises[currCellIndex].rest{
                result = true
                break
            }
            currCellIndex += 1
        }
        return result
    }
    
    // this is the function for the button that acts as both start workout and delete workout while in edit mode
    @IBAction func startWorkoutPressed(){
        if StartWorkoutButton.titleLabel?.text == "Start Workout"{
            startWorkout()
        } else if StartWorkoutButton.titleLabel?.text == "Delete Workout"{
            deleteWorkout()
        }
    }
    
    func startWorkout(){
        if validateFieldsFilled(){
            prevSelExercises = selExercises
            performSegue(withIdentifier: "startWorkoutSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Start Workout Failed", message: "Not all fields are filled!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
              // your code with delay
              alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func deleteWorkout(){
        let alert = UIAlertController(title: "All data will be lost once deleted.", message: "Are you sure you want to proceed?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(a) in self.performSegue(withIdentifier: "deleteWorkoutSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
  /*
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
*/

}


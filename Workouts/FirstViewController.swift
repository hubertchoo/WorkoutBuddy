//
//  FirstViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 5/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var WorkoutsTable: UITableView!
    var workouts = [[WorkoutExerciseStruct]]()
    // workoutNames is a mapping for the names of workouts with array workouts
    var workoutNames = [String]()
    var workoutToStart = 0
    //workoutToStart is the index for which workout to trigger begin
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkoutsTable.delegate = self
        WorkoutsTable.dataSource = self
        // Do any additional setup after loading the view.
        workouts.append([WorkoutExerciseStruct(name: "Bench Press", sets: "5", reps: "10", rest: "5"), WorkoutExerciseStruct(name: "Push Ups", sets: "3", reps: "5", rest: "10")])
        workoutNames.append("Example Workout")
        
        let defaults = UserDefaults.standard
        if let storedWorkouts = defaults.object(forKey: "workouts") as? Data {
            if let decodedWorkouts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedWorkouts) as? [[WorkoutExerciseStruct]] {
                workouts = decodedWorkouts
            }
        }
        if let storedNames = defaults.object(forKey: "workoutNames") as? Data {
            if let decodedNames = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedNames) as? [String] {
                workoutNames = decodedNames
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // func unwinds from third view controller
    @IBAction func unwindToThis(sender:UIStoryboardSegue){
        let senderView = sender.source as! ThirdViewController
        
        workouts.append(senderView.ex_selected)
        workoutNames.append(senderView.WorkoutNameField.text!)
        
        WorkoutsTable.reloadData()
    }
    
    @IBAction func unwindSaveChanges(sender:UIStoryboardSegue){
        let senderView = sender.source as! FifthViewController
        let workoutIndex = senderView.workoutIndex
        workouts[workoutIndex] = senderView.selExercises
        workoutNames[workoutIndex] = senderView.WorkoutNameField.text!
        
        WorkoutsTable.reloadData()
        self.save()
    }
    
    @IBAction func startWorkoutSegue(sender: UIStoryboardSegue){
        let senderView = sender.source as! FifthViewController
        let workoutIndex = senderView.workoutIndex
        workouts[workoutIndex] = senderView.selExercises
        workoutNames[workoutIndex] = senderView.WorkoutNameField.text!
        WorkoutsTable.reloadData()
        self.save()
        DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "beginWorkoutSegue", sender: nil)
        }
        
        
    }
    
    @IBAction func deleteWorkoutSegue(sender: UIStoryboardSegue){
        let senderView = sender.source as! FifthViewController
        let workoutIndex = senderView.workoutIndex
        workouts.remove(at: workoutIndex)
        workoutNames.remove(at: workoutIndex)
        self.save()
        WorkoutsTable.reloadData()
    }
        
    // MARK: UITableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WorkoutsTable.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath)
        cell.textLabel?.text = workoutNames[indexPath.row]
        cell.selectionStyle = .none
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFifthView"{
            let dest = segue.destination as! FifthViewController
            let indexPath = WorkoutsTable.indexPathForSelectedRow
            dest.selExercises = workouts[indexPath!.row]
            dest.workoutName = workoutNames[indexPath!.row]
            dest.workoutIndex = indexPath!.row
            dest.allWorkouts = workouts
            dest.allWorkoutNames = workoutNames
        }
        if segue.identifier == "beginWorkoutSegue" {
            let dest = segue.destination as! SixthViewController
            dest.exInWorkout = workouts[workoutToStart]
            
        }
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }

    
    @IBAction func unwindEndWorkout(segue: UIStoryboardSegue){
        return
    }

    func save() {
        // save workouts
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: workouts, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "workouts")
        }
        // save workout names
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: workoutNames, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "workoutNames")
        }
    }
    
}


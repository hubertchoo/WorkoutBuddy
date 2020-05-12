//
//  SixthViewController.swift
//  
//
//  Created by Hubert Choo on 11/5/20.
//

import UIKit

class SixthViewController: UIViewController {

    @IBOutlet weak var CurrentExerciseLabel: UILabel!
    @IBOutlet weak var CurrentSetLabel: UILabel!
    @IBOutlet weak var RepsLabel: UILabel!
    @IBOutlet weak var RestLabel: UILabel!
    @IBOutlet weak var WorkoutProgressBar: UIProgressView!
    @IBOutlet weak var NextButton: UIButton!
    
    var exInWorkout = [WorkoutExerciseStruct]()
    var currExerciseIndex = 0
    //currExerciseIndex stores the index of the exercise the user is currently going through in the workout
    var currSetIndex = 1
    //currSetIndex stores the index of the current set user is going through in the exercise
    var totalSets = 0
    //total number of sets for progress bar
    var setsCompleted = 0
    var workoutComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let currExercise = exInWorkout[currExerciseIndex]
        CurrentExerciseLabel.text = currExercise.name
        CurrentSetLabel.text = "Set " + String(currSetIndex) + " of " + String(currExercise.sets!)
        RepsLabel.text = String(currExercise.reps!) + " Reps"
        RestLabel.text = String(currExercise.rest!) + "s Rest"
        
        for exerciseStruct in exInWorkout{
            totalSets += Int(exerciseStruct.sets!)!
            WorkoutProgressBar.progress = 0.0
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !workoutComplete {
            let currExercise = exInWorkout[currExerciseIndex]
            CurrentExerciseLabel.text = currExercise.name
            CurrentSetLabel.text = "Set " + String(currSetIndex) + " of " + String(currExercise.sets!)
            RepsLabel.text = String(currExercise.reps!) + " Reps"
            RestLabel.text = String(currExercise.rest!) + "s Rest"
            WorkoutProgressBar.progress = Float(setsCompleted)/Float(totalSets)
        } else {
            CurrentExerciseLabel.text = "Workout Completed"
            CurrentSetLabel.text = ""
            RepsLabel.text = ""
            RestLabel.text = ""
            WorkoutProgressBar.progress = 1.0
            NextButton.isHidden = true
            
        }
    }
    
    @IBAction func goToRestTimer(){
        //have yet to catch workout ended
        //exercise completed
        performSegue(withIdentifier: "GoToRestTimer", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToRestTimer"{
            let dest = segue.destination as! SeventhViewController
            dest.restPeriod = Int(exInWorkout[currExerciseIndex].rest!)!
            if String(currSetIndex) == exInWorkout[currExerciseIndex].sets{
                currSetIndex = 1
                currExerciseIndex += 1
            } else {
                currSetIndex += 1
            }
            if currExerciseIndex == exInWorkout.count{
                workoutComplete = true
            }
        }
    }
    
    @IBAction func unwindAfterRest(segue: UIStoryboardSegue){
        setsCompleted += 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

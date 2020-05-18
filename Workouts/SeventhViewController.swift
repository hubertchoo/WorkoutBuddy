//
//  SeventhViewController.swift
//  
//
//  Created by Hubert Choo on 11/5/20.
//

import UIKit
import Foundation

class SeventhViewController: UIViewController {

    var restPeriod = 0
    var nextExerciseLabelText = ""
    @IBOutlet weak var nextExerciseLabel: UILabel!
    @IBOutlet weak var RestCountdownTimer: SRCountdownTimer!
    @IBOutlet weak var PauseResume: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCountdownTimer.start(beginingValue: restPeriod, interval: 1)
        RestCountdownTimer.lineColor = .systemBlue
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.backToWorkout), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        nextExerciseLabel.text = nextExerciseLabelText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
 
    
    //send back to workout if timer ended
    @objc func backToWorkout(){
        if RestCountdownTimer.timerEnded{
            performSegue(withIdentifier: "unwindAfterRest", sender: self)
        }
    }
    
    @IBAction func PauseResumeButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Pause"{
            RestCountdownTimer.pause()
            sender.setTitle("Resume", for: .normal)
        } else {
            RestCountdownTimer.resume()
            sender.setTitle("Pause", for: .normal)
        }
    }
    @IBAction func SkipRest(_ sender: Any) {
        performSegue(withIdentifier: "unwindAfterRest", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FourthViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 7/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit

extension FourthViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}

class FourthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ExForSelectionTable: UITableView!
    var exercises = [String]()
    var selectedExercise = ""
    var prevView = ""
    var filteredExercises = [String]()
    
    // search bar vars
    @IBOutlet weak var ExerciseSearchBar: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExForSelectionTable.delegate = self
        ExForSelectionTable.dataSource = self
        // Do any additional setup after loading the view.
        
        // code below is for exercises search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        definesPresentationContext = true
        ExerciseSearchBar.addSubview(searchController.searchBar)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredExercises.count
        }
        return exercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExForSelectionTable.dequeueReusableCell(withIdentifier: "ExerciseForSelection", for: indexPath)

        if isFiltering {
            cell.textLabel?.text = filteredExercises[indexPath.row]
        } else {
            cell.textLabel?.text = exercises[indexPath.row]
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        func unwindSegue(){
            if prevView == "Fifth" {
                performSegue(withIdentifier: "unwindToWorkoutPage", sender: self)
            } else if prevView == "Third" {
                performSegue(withIdentifier: "unwindToThirdView", sender: self)
            }
        }
        if isFiltering {
            selectedExercise = filteredExercises[indexPath.row]
            searchController.dismiss(animated: true, completion: unwindSegue)
        } else {
            selectedExercise = exercises[indexPath.row]
            unwindSegue()
        }
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
            filteredExercises = exercises.filter {$0.lowercased().contains(searchText.lowercased())}
            ExForSelectionTable.reloadData()
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

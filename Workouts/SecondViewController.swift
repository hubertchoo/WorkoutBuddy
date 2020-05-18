//
//  SecondViewController.swift
//  Workouts
//
//  Created by Hubert Choo on 5/5/20.
//  Copyright © 2020 Hubert Choo. All rights reserved.
//

import UIKit

extension SecondViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var ExTableView: UITableView!
    var ex_names = ["Bench Press", "Shoulder Press", "Push Ups"]
    var filteredExercises = [String]()
    
    // search bar vars
    @IBOutlet weak var SearchBarView: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ExTableView.delegate = self
        ExTableView.dataSource = self
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if let storedExercises = defaults.object(forKey: "exercises") as? Data {
            if let decodedExercises = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedExercises) as? [String] {
                ex_names = decodedExercises
            }
        }
        // code below is for exercises search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        definesPresentationContext = true
        SearchBarView.addSubview(searchController.searchBar)
    }
    // MARK: TABLEVIEW functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredExercises.count
        }
        return ex_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExTableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = filteredExercises[indexPath.row]
        } else {
            cell.textLabel?.text = ex_names[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        if isFiltering{
            ex_names.remove(at: ex_names.firstIndex(of: filteredExercises[indexPath.row])!)
            filteredExercises.remove(at: indexPath.row)
            ExTableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            ex_names.remove(at: indexPath.row)
            ExTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        }
    }
    
    // MARK: Add exercise functions
        
    @IBAction func add_exercise(){
        let alert = UIAlertController(title: "Insert Exercise", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Exercise Name"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let result : String = textField!.text!
            self.ex_names.append(result)
            self.save()
            self.ExTableView.reloadData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func save() {
        // save workouts
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: ex_names, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "exercises")
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredExercises = ex_names.filter {$0.lowercased().contains(searchText.lowercased())}
        ExTableView.reloadData()
    }

}



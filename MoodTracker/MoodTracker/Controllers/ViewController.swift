//
//  ViewController.swift
//  MoodTracker
//
//  Created by Medi Assumani on 11/8/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    var entries = [MoodEntry](){
        didSet{
            moondEntriesTableView.reloadData()
        }
    }
    @IBOutlet weak var moondEntriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let goodEntry = MoodEntry(mood: .good, date: Date())
        let badEntry = MoodEntry(mood: .bad, date: Date())
        let neutralEntry = MoodEntry(mood: .neutral, date: Date())
        
        entries = [goodEntry, badEntry, neutralEntry]
        moondEntriesTableView.reloadData()
        
        self.moondEntriesTableView.delegate = self as? UITableViewDelegate
        self.moondEntriesTableView.dataSource = self as? UITableViewDataSource
        
        // Apple watch connectivity
        if WCSession.isSupported(){
            WCSession.default.delegate = self as? WCSessionDelegate
            WCSession.default.activate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = moondEntriesTableView.indexPathForSelectedRow {
            moondEntriesTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    
    @IBAction func pressAddEntry(_ sender: UIBarButtonItem) {
        
        let now = Date()
        let newMood = MoodEntry(mood: .amazing, date: now)
        entries.insert(newMood, at: 0)
        moondEntriesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    
    
    func createEntry(mood: Mood, date: Date) {
        let newEntry = MoodEntry(mood: mood, date: date)
        entries.insert(newEntry, at: 0)
        moondEntriesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    
    func updateEntry(mood: Mood, date: Date, at index: Int) {
        entries[index].mood = mood
        entries[index].date = date
        moondEntriesTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteEntry(at index: Int) {
        entries.remove(at: index)
        moondEntriesTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show entry details":
                guard
                    let selectedCell = sender as? UITableViewCell,
                    let indexPath = moondEntriesTableView.indexPath(for: selectedCell) else {
                    return print("failed to locate index path from sender")
                }
                
                guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                    return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'MoodDetailedViewController'")
                }
                
                let entry = entries[indexPath.row]
                entryDetailsViewController.mood = entry.mood
                entryDetailsViewController.date = entry.date
                entryDetailsViewController.isEditingEntry = true
                
            case "show new entry":
                guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                    
                    //NOTE: error handling
                    return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'MoodDetailedViewController'")
            }
            
            default: break
        }
        
    }
  }
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue){
        
        guard let identifier = segue.identifier else {return}
        guard let detailedEntryViewController = segue.source as? MoodDetailedViewController else {
            return print("storyboard unwind segue not set up correctly")
        }
        
        switch identifier{
            
        case "unwind from save":
            let newMood: Mood = detailedEntryViewController.mood
            let newDate: Date = detailedEntryViewController.date
            if detailedEntryViewController.isEditingEntry {
                guard let selectedIndexPath = moondEntriesTableView.indexPathForSelectedRow else { return }
                print("from save button and editing an existing entry")
                updateEntry(mood: newMood, date: newDate, at: selectedIndexPath.row)
            }
            else {
                createEntry(mood: newMood, date: newDate)
                print("from save button and adding a new entry")
            }
        case "unwind from cancel":
            print("from cancel button")
        default:
            break
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            print("This is the user info \(userInfo)")
            
            guard let mood = userInfo["mood"] as? String, let date =  userInfo["date"] as? Date else{ return}
            let newEntry : MoodEntry!
            
            switch mood {
            case "Amazing":
                newEntry = MoodEntry(mood: .amazing, date: date)
            case "Good":
                newEntry = MoodEntry(mood: .good, date: date)
            case "Bad":
                newEntry = MoodEntry(mood: .bad, date: date)
            case "Terrible":
                newEntry = MoodEntry(mood: .terrible, date: date)
            case "Neutral":
                newEntry = MoodEntry(mood: .neutral, date: date)
            default:
                return
            }
            
            self.entries.append(newEntry)
            self.moondEntriesTableView.reloadData()
        }
        
    }
        
    
    // WatchConnectiviry delegate function
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("Error: \(error)")
        }else{
            print("Ready to communicate with apple watch.")
        }
    }
}
        
        
extension ViewController: UITableViewDataSource, UITableViewDelegate{
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return entries.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mood entry cell", for: indexPath) as! MoodEntryTableViewCell
            let entry = entries[indexPath.row]
            cell.configure(entry.mood)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedEntry = entries[indexPath.row]
            let destinationVC = MoodDetailedViewController()
            destinationVC.mood = selectedEntry.mood
            destinationVC.date = selectedEntry.date
            
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            switch editingStyle{
            case .delete:
                deleteEntry(at: indexPath.row)
                
            default:
                break
            }
        }

}
    


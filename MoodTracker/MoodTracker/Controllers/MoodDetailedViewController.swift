//
//  MoodDetailedViewController.swift
//  MoodTracker
//
//  Created by Medi Assumani on 11/18/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import UIKit

class MoodDetailedViewController: UIViewController {

    var date: Date!
    var mood: Mood!
    var isEditingEntry = false
    
    @IBOutlet weak var buttonAmazingMood: UIButton!
    @IBOutlet weak var buttonGoodMood: UIButton!
    @IBOutlet weak var buttonNeutralMood: UIButton!
    @IBOutlet weak var buttonBadMood: UIButton!
    @IBOutlet weak var buttonTerribleMood: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    
    private func updateUI() {
        
        guard let unwrappedMood = self.mood, let unwrappedDate = self.date else {return}
        updateMood(to: unwrappedMood)
        datePicker.date = unwrappedDate
    }
    
    
    private func updateMood(to newMood: Mood) {
        let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        guard let unwrappedAmazingButton = self.buttonAmazingMood, let unwrappedGoodButton = buttonGoodMood, let unwrappedNeutralButton = self.buttonNeutralMood, let unwrappedBadButton = buttonBadMood, let unwrappedTerribleButton = buttonTerribleMood else {return}
        switch newMood {
        case .none:
            buttonAmazingMood.backgroundColor = unselectedColor
            buttonGoodMood.backgroundColor = unselectedColor
            buttonNeutralMood.backgroundColor = unselectedColor
            buttonBadMood.backgroundColor = unselectedColor
            buttonTerribleMood.backgroundColor = unselectedColor
        case .amazing:
            buttonAmazingMood.backgroundColor = newMood.colorValue
            buttonGoodMood.backgroundColor = unselectedColor
            buttonNeutralMood.backgroundColor = unselectedColor
            buttonBadMood.backgroundColor = unselectedColor
            buttonTerribleMood.backgroundColor = unselectedColor
        case .good:
            unwrappedAmazingButton.backgroundColor = unselectedColor
            buttonGoodMood.backgroundColor = newMood.colorValue
            buttonNeutralMood.backgroundColor = unselectedColor
            buttonBadMood.backgroundColor = unselectedColor
            buttonTerribleMood.backgroundColor = unselectedColor
        case .neutral:
            buttonAmazingMood.backgroundColor = unselectedColor
            buttonGoodMood.backgroundColor = unselectedColor
            buttonNeutralMood.backgroundColor = newMood.colorValue
            buttonBadMood.backgroundColor = unselectedColor
            buttonTerribleMood.backgroundColor = unselectedColor
        case .bad:
            buttonAmazingMood.backgroundColor = unselectedColor
            buttonGoodMood.backgroundColor = unselectedColor
            buttonNeutralMood.backgroundColor = unselectedColor
            buttonBadMood.backgroundColor = newMood.colorValue
            buttonTerribleMood.backgroundColor = unselectedColor
        case .terrible:
            buttonAmazingMood.backgroundColor = unselectedColor
            buttonGoodMood.backgroundColor = unselectedColor
            buttonNeutralMood.backgroundColor = unselectedColor
            buttonBadMood.backgroundColor = unselectedColor
            buttonTerribleMood.backgroundColor = newMood.colorValue
        }
        
        mood = newMood
    }
    
    
    @IBAction func datePickerDidChangeValueChange(_ sender: UIDatePicker){
        date = datePicker.date
    }
    
    @IBAction func pressMood(_ button: UIButton){
        switch button.tag {
        case 0:
            updateMood(to: .amazing)
        case 1:
            updateMood(to: .good)
        case 2:
            updateMood(to: .neutral)
        case 3:
            updateMood(to: .bad)
        case 4:
            updateMood(to: .terrible)
        default:
            
            //NOTE: error handling
            print("unhandled button tag")
        }
    }
    
    @IBAction func pressSave(_ sender: Any) {
        isEditingEntry = true
        performSegue(withIdentifier: "unwind from save", sender: nil)
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        performSegue(withIdentifier: "unwind from cancel", sender: nil)
    }
    
}

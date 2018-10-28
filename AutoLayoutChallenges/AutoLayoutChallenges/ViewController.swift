//
//  ViewController.swift
//  AutoLayoutChallenges
//
//  Created by Medi Assumani on 10/28/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blueView)
        view.addSubview(greenView)
        setUpBlueView()
        setUpGreenView()
        
    }
    
    let blueView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let greenView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private func setUpBlueView(){
        
        NSLayoutConstraint.activate([blueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                     blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     blueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     blueView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 100),
                                     blueView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
                                     blueView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)])
        

    }
    
    private func setUpGreenView(){
        
        NSLayoutConstraint.activate([greenView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
                                    greenView.leadingAnchor.constraint(equalToSystemSpacingAfter: blueView.trailingAnchor, multiplier: 10),
                                    greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                    greenView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 100),
                                    greenView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
                                    greenView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)])
    }
}


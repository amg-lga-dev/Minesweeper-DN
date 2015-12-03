//
//  IntroViewController.swift
//  MineSweeperPractice
//
//  Created by Andrew Grossfeld on 11/28/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var gameTypeSelect: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame (sender: UIButton) {
        let gameVC = GameViewController()
        let type = gameTypeSelect.selectedSegmentIndex
        var gameType = 0
        
        if type == 0 { gameType  =  8}
        else if (type == 1) { gameType = 10 }
        else { gameType = 12 }
        
        gameVC.gameSize = gameType
        self.navigationController?.pushViewController(gameVC, animated: true)
        
    }

}

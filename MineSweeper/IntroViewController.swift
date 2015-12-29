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
    @IBOutlet weak var gameLevelSelect: UISegmentedControl!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var developersText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let currentTheme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        themeButton.setTitle(currentTheme, forState: .Normal)
        
        layoutTheme()
    }
    
    func layoutTheme() { // set background and text colors according to theme
        self.view.backgroundColor = Style.foundationColor
        for view in self.view.subviews {
            (view as? UILabel)?.textColor = Style.textColor
        }
        if Style.foundationColor == UIColor.blackColor(){
            developersText.textColor = UIColor(red: 255/255, green: 251/255, blue: 81/255, alpha: 1)
        }
    }
    
    @IBAction func changeTheme(sender: UIButton) {
        let oldTheme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        var newTheme = "Day"
        if oldTheme == "Night" { newTheme = "Day" }
        else { newTheme = "Night" }
        NSUserDefaults.standardUserDefaults().setValue(newTheme, forKey: "theme")
        Style.changeTheme()
        self.viewWillAppear(true)
        themeButton.setTitle(newTheme, forState: .Normal)
    }
    
    @IBAction func startGame (sender: UIButton) {
        let gameVC = GameViewController()
        let type = gameTypeSelect.selectedSegmentIndex
        let gameLevel = gameLevelSelect.selectedSegmentIndex
        var gameType = 0
        
        
        if type == 0 { gameType  =  8}
        else if (type == 1) { gameType = 10 }
        else { gameType = 12 }
        
        gameVC.gameSize = gameType
        gameVC.gameLevel = gameLevel
        self.navigationController?.pushViewController(gameVC, animated: true)
        
    }
    
    @IBAction func showScores (sender: UIButton) {
        let svc = HighScoreViewController()
        presentViewController(svc, animated: true, completion: nil)
    }

    @IBAction func showHowToPlay(sender: UIButton) {
        let htpvc = HowToPlayViewController()
        presentViewController(htpvc, animated: true, completion: nil)
    }
}

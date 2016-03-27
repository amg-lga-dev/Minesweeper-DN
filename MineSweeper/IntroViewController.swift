//
//  IntroViewController.swift
//  MineSweeperPractice
//
//  Created by Andrew Grossfeld & Logan Allen on 11/28/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

@objc
protocol IntroViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class IntroViewController: UIViewController, Dimmable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var topBarImage: UIImageView!
    @IBOutlet weak var leftBarIcon: UIButton!
    @IBOutlet weak var rightBarIcon: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleMineImage: UIImageView!
    @IBOutlet weak var mainMineImage: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    var gameType: Int = 0
    var gameLevel: Int = 0
    let dimLevel: CGFloat = 0.7
    let dimSpeed: Double = 0.5
    
    var delegate: IntroViewControllerDelegate?
    var containerVC: ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set shadows for top bar buttons
        for button in self.view.subviews{
            (button as? UIButton)?.layer.shadowColor = UIColor.blackColor().CGColor
            (button as? UIButton)?.layer.shadowOffset = CGSizeMake(2,1)
            (button as? UIButton)?.layer.shadowOpacity = 0.8
            (button as? UIButton)?.layer.shadowRadius = 1
        }
        topBarImage.layer.shadowOffset = CGSizeMake(0,2)
        topBarImage.layer.shadowRadius = 4
        
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSizeMake(2,1)
        titleLabel.layer.shadowRadius = 1
        
        startButton.layer.shadowOffset = CGSizeMake(4,4)
        startButton.layer.shadowRadius = 4
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundPressed(_:)))
        tapGestureRecognizer!.delegate = self
        tapGestureRecognizer!.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer!)
        
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        layoutTheme()
    }
    
     // Set background and text colors according to theme
    func layoutTheme() {
        self.view.backgroundColor = Style.foundationColor
        if Style.foundationColor == UIColor.blackColor(){
            topBarImage.image = UIImage(named: "nightSkyBar.png")
            startButton.setBackgroundImage(UIImage(named: "nightSkyBar.png"), forState: .Normal)
            startButton.layer.shadowOpacity = 0.3
            topBarImage.layer.shadowOpacity = 0.3
        }else{
            topBarImage.image = UIImage(named: "skyBar.png")
            startButton.setBackgroundImage(UIImage(named: "skyBar.png"), forState: .Normal)
            startButton.layer.shadowOpacity = 0.5
            topBarImage.layer.shadowOpacity = 0.4
        }
        startButton.layer.shadowColor = Style.textColor.CGColor
        topBarImage.layer.shadowColor = Style.textColor.CGColor
        titleLabel.textColor = Style.textColor
    }
    
    // Button to start minesweeper game
    @IBAction func startGame (sender: UIButton) {
        let gameVC = GameViewController()
        
        gameVC.gameSize = 8 + 2*gameType
        gameVC.gameLevel = gameLevel
        gameVC.introVC = self as IntroViewController
        containerVC?.currentState = .GameSimulation
        self.navigationController?.pushViewController(gameVC, animated: true)
        
    }
    
    func backgroundPressed(sender: UITapGestureRecognizer){
        if containerVC?.currentState != .IntroShowing{ delegate?.collapseSidePanels?() }
    }
    
    @IBAction func sideTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func scoreTapped(sender: UIButton) {
        delegate?.toggleRightPanel?()
    }
}

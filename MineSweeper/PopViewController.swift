//
//  PopViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 1/4/16.
//  Copyright © 2016 A.G. & L.A. All rights reserved.
//

import UIKit

let content = ["Step 1", "Step 2", "Step 3", "Step 5"]
class PopViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var selectedContent: String!
    var smallView: UIView!
    var topImage: UIImageView!
    var titleLabel: UILabel!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var textView: UITextView!
    var imageViews: [UIView]!
    var backButton: UIButton!
    var parentVC: InfoPanelViewController!
    var introVC: IntroViewController!
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        smallView = UIView(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 150
            , width: 300, height: 300))
        smallView.backgroundColor = UIColor.whiteColor()
        smallView.layer.borderColor = UIColor.blackColor().CGColor
        smallView.layer.borderWidth = 1
        self.view.addSubview(smallView)
        self.view.bringSubviewToFront(smallView)
        
        initTopImage()
        initTitle()
        initText()
        initButtons()
        initGraphic()
        setContent()
        
        smallView.userInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PopViewController.handlePan(_:)))
        smallView.addGestureRecognizer(panGesture)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dimmedBackgroundTapped(_:)))
        tapGestureRecognizer?.delegate = self
        tapGestureRecognizer?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    func dimmedBackgroundTapped(sender: UITapGestureRecognizer){
        let tapPoint = sender.locationInView(self.view)
        let hitView = self.view.hitTest(tapPoint, withEvent: nil)
        
        if hitView == view{
            let pvc = self.parentVC as InfoPanelViewController
            let ivc = self.introVC as IntroViewController
            pvc.dim(.Out, speed: pvc.dimSpeed)
            ivc.dim(.Out, speed: ivc.dimSpeed)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func initTopImage(){
        topImage = UIImageView(frame: CGRect(x: smallView.bounds.origin.x, y: smallView.bounds.origin.y, width: smallView.bounds.width, height: 47))
        if Style.foundationColor == UIColor.blackColor(){
            topImage.image = UIImage(named: "nightSkyBar.png")
        }else{
            topImage.image = UIImage(named: "skyBar.png")
        }
        topImage.layer.shadowOpacity = 0.5
        topImage.layer.shadowColor = UIColor.blackColor().CGColor
        topImage.layer.shadowOffset = CGSizeMake(0,2)
        topImage.layer.shadowRadius = 4
        smallView.addSubview(topImage)
    }
    
    func initTitle(){
        titleLabel = UILabel(frame: CGRect(x: smallView.bounds.origin.x, y: smallView.bounds.origin.y + 10, width: smallView.bounds.width, height: 30))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "Gill Sans", size: 24)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOffset = CGSizeMake(2,1)
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 4
        smallView.addSubview(titleLabel)
    }
    
    func initText(){
        textView =  UITextView(frame: CGRect(x: smallView.bounds.origin.x, y: titleLabel.bounds.origin.y + 70, width: smallView.bounds.width, height: smallView.bounds.height-130))
        textView.textColor = UIColor.blackColor()
        textView.font = UIFont(name: "Gill Sans", size: 16)
        textView.textAlignment = NSTextAlignment.Center
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false
        smallView.addSubview(textView)
    }
    
    func initButtons() {
        nextButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x + smallView.bounds.width - 86, y: smallView.bounds.origin.y + smallView.bounds.height - 45, width: 62, height: 28))
        prevButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x + 24, y: smallView.bounds.origin.y + smallView.bounds.height - 45, width: 62, height: 28))
        backButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x + smallView.bounds.width/2 - 31, y: smallView.bounds.origin.y + smallView.bounds.height - 45, width: 62, height: 28))
        nextButton.setTitle("Next", forState: .Normal)
        prevButton.setTitle("Prev", forState: .Normal)
        backButton.setTitle("Done", forState: .Normal)
        nextButton.addTarget(self, action: #selector(PopViewController.nextPressed(_:)), forControlEvents: .TouchUpInside)
        prevButton.addTarget(self, action: #selector(PopViewController.prevPressed(_:)), forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: #selector(PopViewController.backToVC(_:)), forControlEvents: .TouchUpInside)
        setupButtonAttributes(nextButton, done: false)
        setupButtonAttributes(prevButton, done: false)
        setupButtonAttributes(backButton, done: true)
    }
    
    func setupButtonAttributes(button: UIButton, done: Bool){
        button.titleLabel?.font = UIFont(name: "Gill Sans", size: 16)
        button.setTitleColor(UIColor(red: 128/255, green: 172/255, blue: 248/255, alpha: 1), forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        button.backgroundColor = UIColor.blackColor()
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(2, 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.layer.cornerRadius = 5
        smallView.addSubview(button)
    }
    
    func setContent() {
        switch selectedContent {
        case "Step 1": stepOne()
        case "Step 2": stepTwo()
        case "Step 3": stepThree()
        case "Step 4": stepFour()
        case "Step 5": stepFive()
        default: stepOne()
        }
    }
    
    func stepOne() {
        selectedContent = "Step 1"
        titleLabel.text = selectedContent
        prevButton.hidden = true
        nextButton.hidden = false
        textView.text = "Select a board size and difficulty.\n\nThe higher the difficulty, the more hidden mines."
        hideGraphic()
    }
    func stepTwo() {
        selectedContent = "Step 2"
        titleLabel.text = selectedContent
        nextButton.hidden = false
        prevButton.hidden = false
        textView.text = "Click on tiles to uncover what is underneath.\n\nClick and hold to place a flag."
        hideGraphic()
        
    }
    func stepThree() {
        selectedContent = "Step 3"
        titleLabel.text = selectedContent
        nextButton.hidden = false
        prevButton.hidden = false
        textView.text = "Once uncovered, the tile's number corresponds to the number of mines nearby.\n\nIf you click a tile with a mine underneath, you lose.\n\nWatch Out!"
        hideGraphic()
    }
    
    func stepFour() {
        selectedContent = "Step 4"
        titleLabel.text = "Example"
        nextButton.hidden = false
        prevButton.hidden = false
        textView.text = ""
        showGraphic()
    }
    
    func stepFive() {
        selectedContent = "Step 5"
        titleLabel.text = selectedContent
        nextButton.hidden = true
        prevButton.hidden = false
        textView.text = "Uncovered all the tiles without mines?\n\nYou Win! :)"
        hideGraphic()
        
    }
    
    func initGraphic() {
        let centerP = CGPoint(x: smallView.bounds.width/2 - 20, y: smallView.bounds.height/2 - 20)
        let center = UILabel(frame: CGRect(x: centerP.x, y: centerP.y, width: 40, height: 40))
        center.backgroundColor = UIColor.grayColor()
        center.layer.borderColor = Style.textColor.CGColor
        center.layer.borderWidth = 1
        center.text = "#"
        center.font = UIFont(name: "Gill Sans", size: 20)
        center.textColor = Style.foundationColor
        center.textAlignment = NSTextAlignment.Center
        let topL = Tile(frame: CGRect(x: centerP.x - 45, y: centerP.y - 45, width: 40, height: 40))
        let top = Tile(frame: CGRect(x: centerP.x, y: centerP.y - 45, width: 40, height: 40))
        let topR = Tile(frame: CGRect(x: centerP.x + 45, y: centerP.y - 45, width: 40, height: 40))
        let r = Tile(frame: CGRect(x: centerP.x + 45, y: centerP.y, width: 40, height: 40))
        let l = Tile(frame: CGRect(x: centerP.x - 45, y: centerP.y, width: 40, height: 40))
        let botL = Tile(frame: CGRect(x: centerP.x - 45, y: centerP.y + 45, width: 40, height: 40))
        let bot = Tile(frame: CGRect(x: centerP.x, y: centerP.y + 45, width: 40, height: 40))
        let botR = Tile(frame: CGRect(x: centerP.x + 45, y: centerP.y + 45, width: 40, height: 40))
        imageViews = [center, topL, top, topR, r, l, botL, bot, botR]
        for view in imageViews {
            guard let temp = view as? Tile
                else {continue}
            temp.backgroundColor = Style.textColor
            let image1: UIImage = UIImage(named: "landmine")!
            let image2: UIImage = UIImage(named: "flag")!
            temp.setImage(image1, forState: .Normal)
            let size = temp.frame.width
            temp.imageEdgeInsets = UIEdgeInsets(top: size/8, left: size/8, bottom: size/8, right: size/8)
            temp.imageView!.animationImages = [image1, image2]
            temp.imageView!.animationDuration = 2.5
            temp.imageView!.animationRepeatCount = 0
            temp.imageView!.startAnimating()
//            temp.imageEdgeInsets = UIEdgeInsets(top: size/6, left: size/5, bottom: size/6, right: size/6)
            temp.contentMode = .ScaleAspectFit
        }
        for view in imageViews {
            smallView.addSubview(view)
        }
        
    }
    
    func showGraphic() {
        for view in imageViews {
            view.hidden = false
        }
    }
    
    func hideGraphic() {
        for view in imageViews {
            view.hidden = true
        }
    }
    
    @IBAction func backToVC(sender:UIButton) {
        let pvc = self.parentVC as InfoPanelViewController
        let ivc = self.introVC as IntroViewController
        pvc.dim(.Out, speed: pvc.dimSpeed)
        ivc.dim(.Out, speed: ivc.dimSpeed)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        switch selectedContent {
        case "Step 1": stepTwo()
        case "Step 2": stepThree()
        case "Step 3": stepFour()
        case "Step 4": stepFive()
        case "Step 5": stepOne()
        default: stepOne()
        }
    }
    
    @IBAction func prevPressed(sender: UIButton) {
        switch selectedContent {
        case "Step 1": stepFive()
        case "Step 2": stepOne()
        case "Step 3": stepTwo()
        case "Step 4": stepThree()
        case "Step 5": stepFour()
        default: stepOne()
        }
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            let velocity = sender.velocityInView(smallView)
            if (velocity.y > 0 && abs(velocity.x) < 200) { backToVC(backButton) }
            else if (velocity.x > 0 && selectedContent != "Step 1") { prevPressed(prevButton) }
            else if (velocity.x < 0 && selectedContent != "Step 5") { nextPressed(nextButton) }
            else { }
        }
    }


}

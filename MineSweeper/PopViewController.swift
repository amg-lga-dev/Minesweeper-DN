//
//  PopViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld on 1/4/16.
//  Copyright © 2016 Andrew Grossfeld. All rights reserved.
//

import UIKit

let content = ["Step 1", "Step 2", "Step 3", "Step 5"]
class PopViewController: UIViewController {

    var selectedContent: String!
    var smallView: UIView!
    var titleLabel: UILabel!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var textView: UITextView!
    var imageViews: [UIView]!
    var backButton: UIButton!
    var parentVC: InfoPanelViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        smallView = UIView(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 150
            , width: 300, height: 300))
        smallView.backgroundColor = Style.foundationColor
        self.view.addSubview(smallView)
        titleLabel = UILabel(frame: CGRect(x: smallView.bounds.origin.x, y: smallView.bounds.origin.y + 15, width: smallView.bounds.width, height: 20))
        titleLabel.textColor = Style.textColor
        titleLabel.textAlignment = NSTextAlignment.Center
        smallView.addSubview(titleLabel)
        textView =  UITextView(frame: CGRect(x: smallView.bounds.origin.x, y: titleLabel.bounds.origin.y + 50, width: smallView.bounds.width, height: 150))
        textView.textColor = Style.textColor
        textView.textAlignment = NSTextAlignment.Center
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false
        smallView.addSubview(textView)
        initButtons()
        initGraphic()
        setContent()
    }
    
    func initButtons() {
        nextButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x + smallView.bounds.width - 50, y: smallView.bounds.origin.y + smallView.bounds.height - 15, width: 50, height: 15))
        prevButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x, y: smallView.bounds.origin.y + smallView.bounds.height - 15, width: 50, height: 15))
        backButton = UIButton(frame: CGRect(x: smallView.bounds.origin.x + smallView.bounds.width/2 - 25, y: smallView.bounds.origin.y + smallView.bounds.height - 15, width: 50, height: 15))
        nextButton.setTitle("Next", forState: .Normal)
        prevButton.setTitle("Prev", forState: .Normal)
        backButton.setTitle("Back", forState: .Normal)
        nextButton.titleLabel?.textColor = UIColor.blackColor()
        prevButton.titleLabel?.textColor = UIColor.blackColor()
        backButton.titleLabel?.textColor = UIColor.blackColor()
        nextButton.addTarget(self, action: "nextPressed:", forControlEvents: .TouchUpInside)
        prevButton.addTarget(self, action: "prevPressed:", forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: "backToVC:", forControlEvents: .TouchUpInside)
        nextButton.backgroundColor = UIColor.blueColor()
        prevButton.backgroundColor = UIColor.blueColor()
        backButton.backgroundColor = UIColor.blueColor()
        smallView.addSubview(prevButton)
        smallView.addSubview(nextButton)
        smallView.addSubview(backButton)
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
        textView.text = "Select a board size and difficulty"
        hideGraphic()
    }
    func stepTwo() {
        selectedContent = "Step 2"
        titleLabel.text = selectedContent
        nextButton.hidden = false
        prevButton.hidden = false
        textView.text = "Click on tiles to uncover what is underneath.\nClick and hold to place a flag"
        hideGraphic()
        
    }
    func stepThree() {
        selectedContent = "Step 3"
        titleLabel.text = selectedContent
        nextButton.hidden = false
        prevButton.hidden = false
        textView.text = "The number on the tile corresponds to the number of mines nearby.\n\nIf you click a tile with a mine underneath, you lose\nWatch Out!"
        hideGraphic()
    }
    
    func stepFour() {
        selectedContent = "Step 4"
        titleLabel.text = ""
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
        textView.text = "Uncovered all the tiles without bombs?\nYou Win! :)"
        hideGraphic()
        
    }
    
    func initGraphic() {
        let centerP = CGPoint(x: smallView.bounds.width/2 - 20, y: smallView.bounds.height/2 - 20)
        let center = UILabel(frame: CGRect(x: centerP.x, y: centerP.y, width: 40, height: 40))
        center.backgroundColor = UIColor.blueColor()
        center.text = "#"
        center.textColor = UIColor.whiteColor()
        center.textAlignment = NSTextAlignment.Center
        let topL = UIImageView(frame: CGRect(x: centerP.x - 45, y: centerP.y - 45, width: 40, height: 40))
        topL.backgroundColor = UIColor.redColor()
        let top = UIImageView(frame: CGRect(x: centerP.x, y: centerP.y - 45, width: 40, height: 40))
        top.backgroundColor = UIColor.redColor()
        let topR = UIImageView(frame: CGRect(x: centerP.x + 45, y: centerP.y - 45, width: 40, height: 40))
        topR.backgroundColor = UIColor.redColor()
        let r = UIImageView(frame: CGRect(x: centerP.x + 45, y: centerP.y, width: 40, height: 40))
        r.backgroundColor = UIColor.redColor()
        let l = UIImageView(frame: CGRect(x: centerP.x - 45, y: centerP.y, width: 40, height: 40))
        l.backgroundColor = UIColor.redColor()
        let botL = UIImageView(frame: CGRect(x: centerP.x - 45, y: centerP.y + 45, width: 40, height: 40))
        botL.backgroundColor = UIColor.redColor()
        let bot = UIImageView(frame: CGRect(x: centerP.x, y: centerP.y + 45, width: 40, height: 40))
        bot.backgroundColor = UIColor.redColor()
        let botR = UIImageView(frame: CGRect(x: centerP.x + 45, y: centerP.y + 45, width: 40, height: 40))
        botR.backgroundColor = UIColor.redColor()
        imageViews = [center, topL, top, topR, r, l, botL, bot, botR]
        for view in imageViews {
            guard let temp = view as? UIImageView
                else {continue}
            let image1:UIImage = UIImage(named: "landmine")!
            let image2:UIImage = UIImage(named: "flag")!
            temp.image = image1
            temp.animationImages = [image1, image2]
            temp.animationDuration = 2.0
            temp.animationRepeatCount = 0
            temp.startAnimating()
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
        pvc.dim(.Out, speed: pvc.dimSpeed)
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


}

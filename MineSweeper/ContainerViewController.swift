//
//  ContainerViewController.swift
//  MineSweeper
//
//  Created by Andrew Grossfeld & Logan Allen on 12/29/15.
//  Copyright © 2015 A.G. & L.A. All rights reserved.
//

import UIKit

enum SlideOutState {
    case LeftPanelExpanded
    case RightPanelExpanded
    case IntroShowing
    case GameSimulation
}

class ContainerViewController: UIViewController {
    
    var introNav: UINavigationController!
    var introVC: IntroViewController!
    var leftVC: SidePanelViewController?
    var rightVC: InfoPanelViewController?
    
    var introPanelExpandedOffset: CGFloat!
    
    var currentState: SlideOutState = .IntroShowing{
        didSet {
            let shouldShowShadow = (currentState != .IntroShowing)
            // Show shadow only when left panel is showing
            showShadowForIntroViewController(shouldShowShadow)
        }
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize intro view controller (central view)
        introVC = IntroViewController()
        introVC.delegate = self
        introVC.containerVC = self
        
        introPanelExpandedOffset = self.view.bounds.width/5
        
        // Wrap the introViewController in a navigation controller and add to parent
        introNav = UINavigationController(rootViewController: introVC)
        view.addSubview(introNav.view)
        addChildViewController(introNav)
        
        introNav.didMoveToParentViewController(self)
        
        // Add gestures to navigation controller
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        introNav.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
}

// IntroViewController delegate
extension ContainerViewController: IntroViewControllerDelegate {
    
    // Toggle left settings & scores panel
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
    
    // Toggle right information panel
    func toggleRightPanel(){
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        animateRightPanel(notAlreadyExpanded)
    }
    
    // Collapse side panels to show intro screen
    func collapseSidePanels() {
        if currentState == .LeftPanelExpanded{
            animateLeftPanel(false)
        }else{
            animateRightPanel(false)
        }
    }
    
    // Add left panel if not instantiated already
    func addLeftPanelViewController() {
        if (leftVC == nil) {
            leftVC = SidePanelViewController()
            let introFrame = self.introVC.view.frame
            leftVC?.view.frame = introFrame
            leftVC!.view.backgroundColor = UIColor(red: 120/255, green: 139/255, blue: 148/255, alpha: 0.8)
            leftVC!.introVC = self.introVC
            
            view.insertSubview(leftVC!.view, atIndex: 0)
            addChildViewController(leftVC!)
            leftVC!.didMoveToParentViewController(self)
        }
        self.currentState = .LeftPanelExpanded
    }
    
    // Add right panel if not instantiated already
    func addRightPanelViewController() {
        if (rightVC == nil) {
            rightVC = InfoPanelViewController()
            let introFrame = self.introVC.view.frame
            rightVC?.view.frame = introFrame
            rightVC!.view.backgroundColor = UIColor(red: 120/255, green: 139/255, blue: 148/255, alpha: 0.8)
            rightVC!.introVC = self.introVC
            
            view.insertSubview(rightVC!.view, atIndex: 0)
            addChildViewController(rightVC!)
            rightVC!.didMoveToParentViewController(self)
        }
        self.currentState = .RightPanelExpanded
    }
    
    // Animate transition between introVC and left panel
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            animateIntroPanelXPosition(introNav.view.frame.width - introPanelExpandedOffset)
        } else {
//            self.introNav.view.layer.opacity = 1.0
            animateIntroPanelXPosition(0) { finished in
                self.currentState = .IntroShowing
                self.leftVC!.view.removeFromSuperview()
                self.leftVC = nil
            }
        }
    }
    
    // Animate transition between introVC and right panel
    func animateRightPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            animateIntroPanelXPosition(-introNav.view.frame.width + introPanelExpandedOffset)
        } else {
//            self.introNav.view.layer.opacity = 1.0
            animateIntroPanelXPosition(0) { _ in
                self.currentState = .IntroShowing
                self.rightVC!.view.removeFromSuperview()
                self.rightVC = nil
            }
        }
    }
    
    // Animate introVC to target position
    func animateIntroPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: {
            self.introNav.view.frame.origin.x = targetPosition
            }) { (finished) -> Void in
                if (self.introNav.view.center.x == UIScreen.mainScreen().bounds.width/2){
                    if self.currentState == .LeftPanelExpanded{
                        self.leftVC!.view.removeFromSuperview()
                        self.leftVC = nil
                    }else if self.currentState == .RightPanelExpanded{
                        self.rightVC!.view.removeFromSuperview()
                        self.rightVC = nil
                    }
                    self.currentState = .IntroShowing
                }
        }
    }

        
    // Show shadow for introVC when panels are expanded
    func showShadowForIntroViewController(shouldShowShadow: Bool) {
        // let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        if (shouldShowShadow) {
            introNav.view.layer.shadowOpacity = 0.9
        } else {
            introNav.view.layer.shadowOpacity = 0.0
        }
    }
    
}
    
// Gesture recognizer delegate
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        // Only recognize gestures when not running the game
        if currentState != .GameSimulation{
            let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
            
            switch(recognizer.state) {
            case .Began:
                if (currentState == .IntroShowing) {
                    if (gestureIsDraggingFromLeftToRight) {
                        addLeftPanelViewController()
                    } else {
                        addRightPanelViewController()
                    }
                    showShadowForIntroViewController(true)
                }
            case .Changed:
                var location = recognizer.view!.center.x + recognizer.translationInView(view).x
                let center = recognizer.view!.frame.width/2
                if currentState == .LeftPanelExpanded{
                    if location < center{
                        location = center
                    }
                }else if currentState == .RightPanelExpanded{
                    if location > center{
                        location = center
                    }
                }
                recognizer.view!.center.x = location
                recognizer.setTranslation(CGPointZero, inView: view)
            case .Ended:
                var hasMovedPastOffset: Bool = false;
                if (leftVC != nil) {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    if gestureIsDraggingFromLeftToRight{
                        hasMovedPastOffset = (recognizer.view!.center.x + recognizer.view!.bounds.width/4) > view.bounds.size.width
                    }else{
                        hasMovedPastOffset = recognizer.view!.center.x > view.bounds.size.width
                    }
                    animateLeftPanel(hasMovedPastOffset)
                } else if (rightVC != nil) {
                    if !gestureIsDraggingFromLeftToRight{
                        hasMovedPastOffset = (recognizer.view!.center.x - recognizer.view!.bounds.width/4) < 0
                    }else{
                        hasMovedPastOffset = recognizer.view!.center.x < 0
                    }
                    animateRightPanel(hasMovedPastOffset)
                }
            default:
                break
            }
        }
    }
    
}

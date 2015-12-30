//
//  ContainerViewController.swift
//  MineSweeper
//
//  Created by Logan Allen on 12/29/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

enum SlideOutState {
    case LeftPanelExpanded
    case IntroShowing
    case GameSimulation
}

class ContainerViewController: UIViewController {
    
    var introNav: UINavigationController!
    var introVC: IntroViewController!
    var leftVC: SidePanelViewController?
    
    var currentState: SlideOutState = .IntroShowing{
        didSet {
            let shouldShowShadow = (currentState != .IntroShowing)
            // Show shadow only when left panel is showing
            showShadowForIntroViewController(shouldShowShadow)
        }
    }
    
    var introPanelExpandedOffset: CGFloat!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        introVC = IntroViewController()
        introVC.delegate = self
        introVC.containerVC = self
        
        introPanelExpandedOffset = self.view.bounds.width/4
        
        // wrap the introViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        introNav = UINavigationController(rootViewController: introVC)
        view.addSubview(introNav.view)
        addChildViewController(introNav)
        
        introNav.didMoveToParentViewController(self)
        
        // Add gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        introNav.view.addGestureRecognizer(panGestureRecognizer)
    }
    
}

    // MARK: IntroViewController delegate
    extension ContainerViewController: IntroViewControllerDelegate {
        
        func toggleLeftPanel() {
            print("Toggle left")
            let notAlreadyExpanded = (currentState == .IntroShowing)
            
            if notAlreadyExpanded {
                addLeftPanelViewController()
            }
            
            animateLeftPanel(notAlreadyExpanded)
        }
        
        // Add left panel if not instantiated already
        func addLeftPanelViewController() {
            if (leftVC == nil) {
                print("Add left")
                leftVC = SidePanelViewController()
                leftVC!.view.backgroundColor = UIColor(red: 120/255, green: 139/255, blue: 148/255, alpha: 0.8)
                leftVC!.introVC = self.introVC
                addChildSidePanelController(leftVC!)
            }
        }
        
        // Add left panel as child side panel to view
        func addChildSidePanelController(sidePanelController: SidePanelViewController) {
            print("Add child")
            view.insertSubview(sidePanelController.view, atIndex: 0)
            print("FUUFUUFDSU")
            addChildViewController(sidePanelController)
            sidePanelController.didMoveToParentViewController(self)
        }
        
        // Animate transition between introVC and left panel
        func animateLeftPanel(shouldExpand: Bool) {
            print("Animate")
            if (shouldExpand) {
                currentState = .LeftPanelExpanded
                animateIntroPanelXPosition(CGRectGetWidth(introNav.view.frame) - introPanelExpandedOffset)
            } else {
                animateIntroPanelXPosition(0) { finished in
                    self.currentState = .IntroShowing
                    self.leftVC!.view.removeFromSuperview()
                    self.leftVC = nil;
                }
            }
        }
        
        // Expanding animation of left panel VC
        func animateIntroPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.introNav.view.frame.origin.x = targetPosition
                }, completion: completion)
        }
        
        // Show shadow for introVC when left panel is expanded
        func showShadowForIntroViewController(shouldShowShadow: Bool) {
            if (shouldShowShadow) {
                introNav.view.layer.shadowOpacity = 0.8
            } else {
                introNav.view.layer.shadowOpacity = 0.0
            }
        }
        
    }
    
    // MARK: Gesture recognizer delegate
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
                        }
                        showShadowForIntroViewController(true)
                    }
                case .Changed:
                    recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                    recognizer.setTranslation(CGPointZero, inView: view)
                case .Ended:
                    if (leftVC != nil) {
                        // animate the side panel open or closed based on whether the view has moved more or less than halfway
                        let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                        animateLeftPanel(hasMovedGreaterThanHalfway)
                    }
                default:
                    break
                }
            }
        }
        
    }

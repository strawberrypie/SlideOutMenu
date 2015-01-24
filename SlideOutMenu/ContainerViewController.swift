//
//  ContainerViewController.swift
//  SlideOutMenu
//
//  Created by Kj Drougge on 2015-01-23.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState{
    case Collapsed
    case LeftPanelExpanded
}

class ContainerViewController: UIViewController, SchemaViewControllerDelegate {

    var schemaNavigationController: UINavigationController!
    var schemaViewController: SchemaViewController!
    
    var leftViewController: LeftViewController?
    let schemaPanelExpandedOffset: CGFloat = 60
    
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForSchemaViewController(shouldShowShadow)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        schemaViewController = UIStoryboard.viewController()
        schemaViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        
        schemaNavigationController = UINavigationController(rootViewController: schemaViewController)
        view.addSubview(schemaNavigationController.view)
        
        schemaNavigationController.didMoveToParentViewController(self)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        schemaNavigationController.view.addGestureRecognizer(panGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if leftViewController == nil {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(leftPanelController: LeftViewController) {
        //sidePanelController.delegate = centerViewController
        
        view.insertSubview(leftPanelController.view, atIndex: 0)
        
        addChildViewController(leftPanelController)
        leftPanelController.didMoveToParentViewController(self)
    }
    
    
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if shouldExpand.boolValue {
            currentState = .LeftPanelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(schemaNavigationController.view.frame) - schemaPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .Collapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.schemaNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForSchemaViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            schemaNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            schemaNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    


func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .Collapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                }
                
                showShadowForSchemaViewController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (leftViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }



}
    private extension UIStoryboard {
        class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
        
        class func leftViewController() -> LeftViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController
        }
        
        class func viewController() -> SchemaViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("SchemaViewController") as? SchemaViewController
        }
}
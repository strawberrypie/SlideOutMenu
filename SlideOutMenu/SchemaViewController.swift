//
//  SchemaViewController.swift
//  SlideOutMenu
//
//  Created by Kj Drougge on 2015-01-24.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

protocol SchemaViewControllerDelegate{
    func toggleLeftPanel()
    func collapseSidePanels()
}

class SchemaViewController: UIViewController, LeftViewControllerDelegate {
    
    var delegate: SchemaViewControllerDelegate?
    
    @IBAction func settings_clicked(sender: AnyObject) {
        delegate?.toggleLeftPanel()
    }
}
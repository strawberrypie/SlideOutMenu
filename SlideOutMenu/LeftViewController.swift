//
//  LeftViewController.swift
//  SlideOutMenu
//
//  Created by Kj Drougge on 2015-01-24.
//  Copyright (c) 2015 kj. All rights reserved.
//

import UIKit

protocol LeftViewControllerDelegate{
    
}

class LeftViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: LeftViewControllerDelegate?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let pickerTestData = ["Hej", "Hello", "Bonjour", "Hallo", "Hi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTestData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerTestData[row]
    }

}

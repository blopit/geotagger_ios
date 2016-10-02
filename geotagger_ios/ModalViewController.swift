//
//  ModalViewController.swift
//  geotagger_ios
//
//  Created by Shrenil Patel on 2016-10-02.
//  Copyright © 2016 ___SHRENILPATEL___. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    weak var parent  : ViewController?
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var okay: UIButton!
    
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var subcatField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func okay(sender: UIButton) {
        okayReturn();
    }
    
    func okayReturn() -> Bool
    {
        firstViewController?.colourLabel.text = nameEntry.text
        nameEntry.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //create list
    var list = ["Service","Structure","Scenery","Shop","Food & Drink","Emergency"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryField.text = self.list[row]
        self.dropDown.hidden = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.categoryField {
            self.dropDown.hidden = false
            //if you dont want the users to se the keyboard type:
            textField.endEditing(true)
        }
    }
    
    
}

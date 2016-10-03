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
        dismissViewControllerAnimated(true, completion: nil)
        parent?.name = nameField.text!
        parent?.cat = categoryField.text!
        parent?.subcat = subcatField.text!
        parent?.desc = descField.text!
        parent?.sendValue()
        return true
    }
    
    func clearParent () {
        parent?.name = ""
        parent?.cat = ""
        parent?.subcat = ""
        parent?.desc = ""
    }
    
    override func viewDidLoad() {
        clearParent()
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var list = ["Service","Structure","Scenery","Shop","Food & Drink","Emergency"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func hide(hide:Bool) {
        self.dropDown.hidden = hide
        self.nameField.hidden = !hide
        self.descField.hidden = !hide
        self.subcatField.hidden = !hide
        self.categoryField.hidden = !hide
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryField.text = self.list[row]
        hide(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.categoryField {
            hide(false);
            textField.endEditing(true)
        }
    }
    
    
}

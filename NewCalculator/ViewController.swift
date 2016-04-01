//
//  ViewController.swift
//  NewCalculator
//
//  Created by Derex on 3/25/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    var caculatorBrain = CaculatorBrain()
    
    var userIsInMiddleOfTypingNumbers = false
    
    var userHasnotInputDot = true
    
    @IBOutlet weak var historyOfCaculator: UILabel!
    
    @IBOutlet weak var display: UILabel!
   
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingNumbers {
        display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTypingNumbers = true
        }
    }
    
    @IBAction func appendDot(sender: UIButton) {
        if userHasnotInputDot {
            display.text = display.text! + "."
            userHasnotInputDot = false
            userIsInMiddleOfTypingNumbers = true
        }
    }
    @IBAction func pi() {
        if userIsInMiddleOfTypingNumbers {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInMiddleOfTypingNumbers = false
        }
    }
    @IBAction func operation(sender: UIButton) {
       let operate = sender.currentTitle!
        historyOfCaculator.text! += operate
        if userIsInMiddleOfTypingNumbers {
            enter()
        }
        if let result = caculatorBrain.performOperation(operate){
            displayValue = result
        }else {
            displayValue = 0
        }
       
    }
    
    @IBAction func clear() {
        caculatorBrain.clearStack()
        display.text = "0"
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true
        historyOfCaculator.text = ""
    }


    @IBAction func enter() {
        if let result = caculatorBrain.pushOperand(displayValue) {
            displayValue = result
        }else {
            displayValue = 0
        }
        historyOfCaculator.text! += "\(displayValue)  "
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true

    }
    
}


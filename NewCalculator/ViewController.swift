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
    
    var numberHasSign = false
    
    var evaluationStack = [Double]()
    
    @IBOutlet weak var historyOfCaculator: UILabel!
    
    @IBOutlet weak var display: UILabel!
   
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingNumbers {
        display.text = display.text! + digit
        } else {
            if numberHasSign {
                display.text = "−" + digit
                userIsInMiddleOfTypingNumbers = true
            }
            else{display.text = digit
                userIsInMiddleOfTypingNumbers = true
            }
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
    var displayValue: Double? {
        get{
            let displayNumber = NSNumberFormatter().numberFromString(display.text!)!.doubleValue ?? 0
            return displayNumber
        }
        set {
            display.text = "\(newValue)"
            userIsInMiddleOfTypingNumbers = false
        }
    }
    @IBAction func operation(sender: UIButton) {
       let operate = sender.currentTitle!
        if userIsInMiddleOfTypingNumbers {
            enter()
        }
        if let result = caculatorBrain.performOperation(operate){
            displayValue = result
            historyOfCaculator.text = ("\(evaluationStack.removeAtIndex(evaluationStack.count - 2)) \(operate) \(evaluationStack.removeLast()) = \(result)")
            evaluationStack.append(result)
        }else {
            displayValue = nil
        }
       
    }
    
    @IBAction func addSign(sender: UIButton) { // I am typing this function
        if numberHasSign {
            let displayString = display.text!
            display.text = String(displayString.characters.dropFirst())
            numberHasSign = false
        } else {
            display.text = "−" + display.text!
            numberHasSign = true
        }
    }
    @IBAction func backspace() {   // add backspace function
        if userIsInMiddleOfTypingNumbers {
            let textString = display.text!
            display.text = String(textString.characters.dropLast())
            if display.text!.characters.count == 0 {
                display.text = "0"
                userIsInMiddleOfTypingNumbers = false
            }
        }
        
    }
    @IBAction func clear() {
        caculatorBrain.clearStack()
        display.text = "0"
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true
        historyOfCaculator.text = ""
        numberHasSign = false
    }


    @IBAction func enter() {
        if let result = caculatorBrain.pushOperand(displayValue!) {
            displayValue = result
            evaluationStack.append(displayValue!)
        }else {
            displayValue = nil
        }
        historyOfCaculator.text! += "\(displayValue)  "
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true
        numberHasSign = false

    }
    
}


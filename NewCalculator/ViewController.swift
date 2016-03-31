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
    var operandStack = [Double]()
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
//        switch operate {
//        case "×":   performOperation(*)
//        case "÷":   performOperation{$1 / $0}
//        case "+":   performOperation(+)
//        case "−":   performOperation{$1 - $0}
//        case "sin": performOperationBinary{sin($0 * M_PI / 180)}
//        case "cos": performOperationBinary{cos($0 * M_PI / 180)}
//        default:
//            break
//        }
       
    }
    
    @IBAction func clear() {
        operandStack = []
        display.text = "0"
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true
        historyOfCaculator.text = ""
    }
//    func performOperationBinary(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }
//    func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            display.text! += " "
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }

    @IBAction func enter() {
        if let result = caculatorBrain.pushOperand(displayValue) {
            displayValue = result
        }else {
            displayValue = 0
        }
//        operandStack.append(displayValue)
        historyOfCaculator.text! += "\(displayValue)  "
        userIsInMiddleOfTypingNumbers = false
        userHasnotInputDot = true
//        print("operand: \(operandStack)")
    }
    
}


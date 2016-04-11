//
//  CaculatorBrain.swift
//  NewCalculator
//
//  Created by Derex on 3/30/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import Foundation

class CaculatorBrain {
    
    private var opStack = [Op]()  // create a stack for caculation
    
    private enum Op:CustomStringConvertible {    // create a enum for oparand and operation
        case operand(Double)
        //operand is a double type
        case UnaryOperation(String,Double -> Double)
        // unary operantion conbined a string (oparation symbol) and a function with a double parameter which return a double
        case BinaryOperation(String,(Double,Double) -> Double)
        // binary operation conbined a string (oparation symbol) and a function with two double parameter which return a double
        var description:String {
        // read-only computered propety return the op type as string
            get{
                switch self{
                case .operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }

    
    private var knownOps = [String: Op]()
    // give a dictionary as matching relationship between symbol and op function 
    
    init(){
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        // init a function for creatation the known operation and fill the learnOp dictionary
        learnOp(Op.UnaryOperation("sin"){sin($0 * M_PI / 180)})
        learnOp(Op.UnaryOperation("cos"){cos($0 * M_PI / 180)})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−"){$1 - $0})
        learnOp(Op.BinaryOperation("÷"){$1 / $0})
        learnOp(Op.BinaryOperation("×", *))
        
      
        
    }
    var varieableValue = [String: Double]()

    func pushOperand(operand: Double) -> Double?{
        // function for pushing a operand to opStack, otherwise get a optional double as return
        opStack.append(Op.operand(operand))
        // insert a operand into the opStack
        return evaluate()
        //return result of evalute fuction
    }
//    func pushOperand(symbol: String) -> Double? {  //push vaireable
//        if let varieableNumber = varieableValue[symbol]{
//            opStack.append(Op.operand(varieableNumber))
//        } else {
//            let operand = opStack.removeLast()
//            varieableValue[symbol] = operand
//        }
//        return evaluate()
//    }
//    func pushOperand(symbol: String) -> Double? {
//        
//    }
    func performOperation(symbol: String) -> Double? {
        // function for pushing a operation to opStack, and get the result of evaluation
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    func evaluate() -> Double? {
        // evluation function for getting the result and get a optional double as return
        let (result, reminder) = evaluate(opStack) // call for the another evalute function and assign a tuple to (result, reminder)
        print("\(opStack) : \(result) with \(reminder) left over")
        return result
        
    }
    
    func clearStack() { // clear the opStack by removeAll method
        opStack.removeAll()
    }
    private func evaluate(ops:[Op]) -> (result:Double?, remaingsOps:[Op]) {
        if !ops.isEmpty {
            var remaingsOps = ops
            let op = remaingsOps.removeLast()
            switch op {
            case .operand(let operand):
                return (operand, remaingsOps)
            case .UnaryOperation(_,let operation):
                let evluatioinOperation = evaluate(remaingsOps)
                if let operand = evluatioinOperation.result {
                return (operation(operand), evluatioinOperation.remaingsOps)
                }
            case .BinaryOperation(_,let operation):
                let evluationOperation1 = evaluate(remaingsOps)
                if let operand1 = evluationOperation1.result{
                    let evluationOperation2 = evaluate(evluationOperation1.remaingsOps)
                    if let operand2 = evluationOperation2.result {
                        return (operation(operand1,operand2), evluationOperation2.remaingsOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
   
}
//
//  CaculatorBrain.swift
//  NewCalculator
//
//  Created by Derex on 3/30/16.
//  Copyright © 2016 Derex. All rights reserved.
//

import Foundation

class CaculatorBrain {
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init() {
        knownOps["sin"] = Op.UnaryOperation("sin", {sin($0 * M_PI / 180)})
        knownOps["cos"] = Op.UnaryOperation("cos", {cos($0 * M_PI / 180)})
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-"){$1 - $0}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", *)
    }
    
    private enum Op {
        case operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    }
    
    func pushOperand(operand: Double){
        opStack.append(Op.operand(operand))
    }
//    func performOperation(symbol: String) {
//        
//    }
}
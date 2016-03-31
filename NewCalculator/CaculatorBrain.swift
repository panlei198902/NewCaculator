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
    func evaluate() -> Double? {
        let (result, reminder) = evaluate(opStack)
        print("remainingOps: \(reminder)")
        return result
        
    }
    private func evaluate(ops:[Op]) -> (result:Double?, remaingsOps:[Op]) {
        if !ops.isEmpty {
            var remaingsOps = ops
            let op = remaingsOps.removeLast()
            switch op {
            case .operand(let operand):
                return (operand, remaingsOps)
            case .UnaryOperation(_, let operation):
                let evluatioinOperation = evaluate(remaingsOps)
                if let operand = evluatioinOperation.result {
                return (operation(operand), evluatioinOperation.remaingsOps)
                }
            case .BinaryOperation(_, let operation):
                let evluationOperation = evaluate(remaingsOps)
                if let operand1 = evluationOperation.result{
                    let evluationOperation1 = evaluate(evluationOperation.remaingsOps)
                    if let operand2 = evluationOperation1.result {
                        return (operation(operand1,operand2), evluationOperation1.remaingsOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    private enum Op {
        case operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    }
    
    func pushOperand(operand: Double){
        opStack.append(Op.operand(operand))
    }
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
        opStack.append(operation)
        }
    }
}
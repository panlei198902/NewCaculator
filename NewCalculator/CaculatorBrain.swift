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
    
    private enum Op:CustomStringConvertible {
        case operand(Double)
        case UnaryOperation(String,Double -> Double)
        case BinaryOperation(String,(Double,Double) -> Double)
        var description:String {
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
    
    init(){
        func learnOp(op:Op){
            knownOps[op.description] = op   //需要理解下
        }
        knownOps["sin"] = Op.UnaryOperation("sin"){sin($0 * M_PI / 180)}
        knownOps["cos"] = Op.UnaryOperation("cos"){cos($0 * M_PI / 180)}
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["-"] = Op.BinaryOperation("-"){$1 - $0}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+",*)
    }
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    func evaluate() -> Double? {
        let (result, reminder) = evaluate(opStack)
        print("\(opStack) : \(result) with \(reminder) left over")
        return result
        
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
  
    
 
}
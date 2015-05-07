//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Rafael Munhoz on 06/05/15.
//  Copyright (c) 2015 Rafael Munhoz. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    //here Printable is a protocol, so the enum is not enhirent from nothing
    //just implementing the protocl
    private enum Op:Printable{
        case Operand(Double)
        case UnaryOperation(String,Double -> Double)
        case BinaryOperation(String,(Double,Double) -> Double)
        // it will override the like toString method
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = Array<Op>() // could be [Op]() is the same
    private var knowOps = Dictionary<String,Op>() // [String:Op]() can be used in the same way
    
    init(){ // the constructor or initializer
        
        func learnOp(op:Op){
            knowOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("ⅹ", *))
        
        //knowOps["ⅹ"] = Op.BinaryOperation("ⅹ",*) // function represented by a closure
        knowOps["+"] = Op.BinaryOperation("+",+) // function represented by a closure
        knowOps["÷"] = Op.BinaryOperation("÷",/) // function represented by a closure
        knowOps["-"] = Op.BinaryOperation("-",-) // function represented by a closure
        //knowOps["√"] = Op.UnaryOperation("√", {sqrt($0)}) // function represented by a closure
        //as sqrt function is a Double -> Double function the closure is not required
        //all swift operators are functions so * is a function too
        knowOps["√"] = Op.UnaryOperation("√", sqrt) // function represented by a closure
    }

    func pushOperand(operand:Double) -> Double!{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
            //let operation = knowOps[symbol] // dictionary always return an optional
        
        if let operation = knowOps[symbol]{ // dictionary always return an optional
                opStack.append(operation)
        }
        
        return evaluate()
        
    }
    // return a tuple
    private func evaluate(ops:[Op]) -> (result: Double?, remainingOps: [Op] ) {
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation): // _ ignores the first argument, _ is kind of ignore in swift
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                    
                }
            //no default:break is required because all possible values of Op where handled
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result,reminder) = evaluate(opStack)
        println("\(opStack) - \(result) with \(reminder) left over")
        return result
    }
    
}
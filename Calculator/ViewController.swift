//
//  ViewController.swift
//  Calculator
//
//  Created by Rafael Munhoz on 04/05/15.
//  Copyright (c) 2015 Rafael Munhoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var display: UILabel!
    var userIsInAMiddleOfTypingNumber = false
    var operandStack = Array<Double>()
    // to convert a string lets say "33.3" to double 33.3 
    // when the cell phone locale is pt_BR it is required to change to en_US as did below
    
    let locale = NSLocale(localeIdentifier: "en_US")
    let formater = NSNumberFormatter()
    
    
    var displayValue: Double {
        
        get{
            formater.locale = locale
            return formater.numberFromString(display.text!)!.doubleValue
        }
        
        set{//implicity newValue
            
            
            display.text = "\(newValue)"
            userIsInAMiddleOfTypingNumber = false
        }
    
    }
    
    @IBAction func operate(sender: UIButton) {
        
        
        let operation = sender.currentTitle!
        
        if userIsInAMiddleOfTypingNumber {
            enter()
        }
        
        switch operation{
            case "ⅹ":performOperation {$0 * $1} // closure very simplified
            case "+":performOperation {$0 + $1}
            case "÷":performOperation {$1 / $0}
            case "-":performOperation {$1 - $0}
            case "√":performOperation {sqrt($0)}
            default:break
        }
    }
    
    private func performOperation(operation: Double -> Double){
        
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast() , operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func enter() {
        userIsInAMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        println("Operand stack = \(operandStack)")
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        println("Digit \(digit)")
        
        if userIsInAMiddleOfTypingNumber {
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInAMiddleOfTypingNumber = true
        }
        
        
    
    }
}


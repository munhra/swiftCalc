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
    var brain = CalculatorBrain()
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
        
        
        if userIsInAMiddleOfTypingNumber {
            enter()
        }
        
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
            
        }
    }
    
    @IBAction func enter() {
        userIsInAMiddleOfTypingNumber = false
        //operandStack.append(displayValue)
        //println("Operand stack = \(operandStack)")
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            //????? optional value
            displayValue = 0
        }
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


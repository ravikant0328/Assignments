//
//  ViewController.swift
//  Calculator
//
//  Created by Ravi on 16/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var displayNumber:Double = 0.0
    var previousdisplayNumber:Double = 0.0
    var doingOperation = false
    var currentOperation = ""
    var dotCount = false
    
    @IBOutlet weak var displayScreen: UILabel!
    
    enum arithematicOperations : String {
        case Addition = "+"
        case Subtraction = "-"
        case Multiplication = "X"
        case Division = "/"
        case Percentage = "%"
    }
    
    func switchOperation(operation:String){
        switch operation{
        case "+":
            displayScreen.text = String(previousdisplayNumber + displayNumber)
        case "-":
            displayScreen.text = String(previousdisplayNumber - displayNumber)
        case "/":
            displayScreen.text = String(previousdisplayNumber / displayNumber)
        case "X":
            displayScreen.text = String(previousdisplayNumber * displayNumber)
        case "%":
            displayScreen.text = String(previousdisplayNumber*100)
        default :
            print("0")
        }
        displayNumber = Double (displayScreen.text!)!
    }
    
    
    
    /* Storing and printing numerals */
    
    @IBAction func numerals(_ sender: UIButton){
        if doingOperation == true && dotCount == false{
            displayScreen.text = sender.titleLabel!.text
            displayNumber = Double(displayScreen.text!)!
            doingOperation = false
        }
        else{
            displayScreen.text = displayScreen.text! + sender.titleLabel!.text!
            displayNumber = Double(displayScreen.text!)!
        }
    }
    
    
    @IBAction func operations(_ sender: UIButton){
        
        /* Storing and printing operations with ignoring some exception cases */
        
        if (displayScreen.text != ""  && sender.titleLabel!.text != "=" && sender.titleLabel!.text != "AC" && sender.titleLabel!.text != "." && sender.titleLabel!.text != "+/-" ) {
            previousdisplayNumber = displayNumber
            dotCount = false
            displayScreen.text = sender.titleLabel!.text
            currentOperation = (sender.titleLabel!.text)!
            doingOperation = true
        }
            
        /* Calculating & Displaying the computed values */
            
        else if sender.titleLabel!.text == "=" {
            if  currentOperation == arithematicOperations.Percentage.rawValue{
                switchOperation(operation:arithematicOperations.Percentage.rawValue)
            }
            else if  currentOperation == arithematicOperations.Division.rawValue{
                switchOperation(operation:arithematicOperations.Division.rawValue)
            }
            else if  currentOperation == arithematicOperations.Multiplication.rawValue{
                switchOperation(operation:arithematicOperations.Multiplication.rawValue)
            }
            else if  currentOperation == arithematicOperations.Subtraction.rawValue{
                switchOperation(operation:arithematicOperations.Subtraction.rawValue)
            }
            else if  currentOperation == arithematicOperations.Addition.rawValue{
                switchOperation(operation:arithematicOperations.Addition.rawValue)
            }
        }
            
        /* Resetting the Calculator */
            
        else if sender.titleLabel!.text == "AC" {
            displayScreen.text = ""
            currentOperation = ""
            previousdisplayNumber = 0
            displayNumber = 0
            dotCount = false
        }
            
        /* Unary operations */
            
        else if sender.titleLabel!.text == "+/-" {
            displayNumber = -displayNumber
            if displayScreen.text != "" && displayNumber != 0.0 && dotCount == false{                     //Non Decimal Unary operation
                displayScreen.text = String(String(displayNumber).dropLast(2))
                displayNumber = Double(displayScreen.text!)!
            }
            else if displayScreen.text != "" && displayNumber != 0.0 && dotCount == true{                 //Decimal Unary operation
                displayScreen.text = String(displayNumber)
            }
        }
            
        /* Decimal Operations */
            
        else if sender.titleLabel!.text == "." {
            if dotCount == false{
                if displayScreen.text == currentOperation{
                    displayNumber = 0
                }
            displayNumber = displayNumber + 0.0
            displayScreen.text = String(String(displayNumber).dropLast())
            displayNumber = Double(displayScreen.text!)!
            dotCount = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var inputs: [String] = []
    var resLabelString: String = "0"
    var charLimitReached: Bool = false
    var arg1: String = ""
    var op: String = ""
    var arg2: String = ""
    var latestInput = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
        updateResultLabel("0")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        resultLabel.text = content
    }
    
    
    func calculate() -> String {
        var resString: String = ""
        
        if (arg1.contains(".") || arg2.contains(".") || op == "/") {
            let calculated: Double = doubleCalculate(a: Double(arg1)!, b: Double(arg2)!, operation: op)
            let possibleInt: Int? = Int(calculated)
            if (possibleInt != nil) {
                resString = String(possibleInt!)
            } else {
                resString = String(calculated)
            }
        } else {
            let calculated: Int = intCalculate(a: Int(arg1)!, b: Int(arg2)!, operation: op)
            resString = String(calculated)
        }
//        inputs.append(resString)
        return resString
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        //let operators = ["/", "*", "-", "+", "="]
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
            case "/": return a/b
            case "*": return a*b
            case "-": return a-b
            case "+": return a+b
        default: return 0
        }
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func doubleCalculate(a: Double, b:Double, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
        case "/": return a/b
        case "*": return a*b
        case "-": return a-b
        case "+": return a+b
        default: return 0
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        print("The number \(sender.content) was pressed")
        latestInput = sender.content
        //  || op.contains(latestInput)
        if (!charLimitReached) {
            if (resLabelString == "0") {
                resLabelString = sender.content
            } else {
                resLabelString.append(sender.content)
            }
            updateResultLabel(resLabelString)
        }
        if (resLabelString.characters.count >= 7) {
            charLimitReached = true
        }
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        let ops = ["/", "*", "-", "+"]
        print("The operator \(sender.content) was pressed")

        switch sender.content {
        case "C":
            resLabelString = "0"
            arg1 = ""
            arg2 = ""
            op = ""
            latestInput = ""
            updateResultLabel(resLabelString)
        case "+/-":
            resLabelString = flipSign(resLabelString)
            updateResultLabel(resLabelString)
        case "=":
            arg2 = resLabelString
            if (shouldCalculate()) {
                resLabelString = calculate()
                arg1 = resLabelString
                op = ""
                arg2 = ""
                updateResultLabel(resLabelString)
            }
        default:
            insertNumArg(resLabelString)
            if (shouldCalculate() && ops.contains(latestInput)) { //if you're pressing ops consecutively.
                op = sender.content //ignore previous op.
                resLabelString = "0"

            } else if (shouldCalculate()) {
                resLabelString = calculate()
                op = sender.content
                arg1 = resLabelString
                arg2 = ""
                updateResultLabel(resLabelString)
                resLabelString = "0"

            } else {
                op = sender.content
                resLabelString = "0"
            }
        }
        latestInput = sender.content
    }
    
    func shouldCalculate() -> Bool {
        return arg1 != "" && op != "" && arg2 != ""
    }
    
    func insertNumArg(_ newarg: String) {
        if (newarg == "") {
            return
        }
        if (arg1 == "") {
            arg1 = newarg
        } else {
            arg2 = newarg
        }
    }
    
    func flipSign(_ resultString: String) -> String {
        var res = resultString
        if (resultString[resultString.startIndex] == "-") {
            res.remove(at: resultString.startIndex)
        } else {
            res.insert("-", at: resultString.startIndex)
        }
        return res
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        latestInput = sender.content
        if (!charLimitReached) {
            resLabelString.append(sender.content)
            updateResultLabel(resLabelString)
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}


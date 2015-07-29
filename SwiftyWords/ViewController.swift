//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Mac Bellingrath on 7/29/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func submitTapped(sender: AnyObject) {
        if let solutionPosition = solutions.indexOf(currentAnswer.text!){
            activatedButtons.removeAll()
            
            var splitClues = answersLabel.text!.componentsSeparatedByString("\n")
            splitClues[solutionPosition] = currentAnswer.text!
            answersLabel.text = "\n".join(splitClues)
            currentAnswer.text = ""
            ++score
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
                presentViewController(ac, animated: true, completion: nil)
            }
            
        }
    }
    @IBAction func clearTapped(sender: AnyObject) {
        currentAnswer.text = ""
        for btn in activatedButtons{
            btn.hidden = false
        }
        activatedButtons.removeAll()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for subview in view.subviews {
            if subview.tag == 1001 {
                let btn = subview as! UIButton
                letterButtons.append(btn)
                btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
                
            }
        }
      
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        do{
            let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt")
            let levelContents = try NSString(contentsOfFile: levelFilePath!, usedEncoding: nil)
            var lines = levelContents.componentsSeparatedByString("\n")
            lines.shuffle()
           
            for (index, line) in lines.enumerate() {
                let parts = line.componentsSeparatedByString(": ")
                let answer = parts[0]
                let clue = parts[1]
                clueString += "\(index + 1). \(clue)\n"
               
                let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                solutionString += "\((solutionWord.characters.count)) letters\n"
                solutions.append(solutionWord)
                print(answer)
                let bits = answer.componentsSeparatedByString("|")
                print("bits: \(bits)")
                letterBits += bits
                cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
                answersLabel.text = solutionString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
               
                letterBits.shuffle()
                letterButtons.shuffle()
                
                if letterBits.count != letterButtons.count {
                    for i in 0..<letterBits.count {
                        letterButtons[i].setTitle(letterBits[i], forState: .Normal)
                        
                        
                    }
                }

            }
        } catch let error {
            print(error)
        }
    }
    func letterTapped(btn: UIButton) {
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.hidden = true
    }
    
    func levelUp(action: UIAlertAction!) {
        ++level
        solutions.removeAll(keepCapacity: true)
        loadLevel()
        for btn in letterButtons {
            btn.hidden = false
        }
    }
}






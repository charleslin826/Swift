//
//  ViewController.swift
//  PaperScissorRock
//
//  Created by charles on 2018/5/8.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

class ChoiceVC: UIViewController {

    @IBAction private func playRock(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultsVC") as! ResultsVC
        vc.userChoice = getUserShape(sender)
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: Segue with Code Approach
    
    @IBAction private func playPaper(_ sender: UIButton) {
        performSegue(withIdentifier: "play", sender: sender)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play" {
            let vc = segue.destination as! ResultsVC
            vc.userChoice = getUserShape(sender as! UIButton)
        }
    }
    
    // MARK: Utilities
    
    // The enum "Shape" represents a play or move
    private func getUserShape(_ sender: UIButton) -> Shape {
        // Titles are set to one of: Rock, Paper, or Scissors
        let shape = sender.title(for: UIControlState())!
        return Shape(rawValue: shape)!
    }
}



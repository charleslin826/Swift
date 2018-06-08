//
//  MemoryCampThemeChooserViewController.swift
//  MemoryCamp
//
//  Created by Charles on 2018/2/26.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit

class MemoryCampThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports" : "⚽️🏀🎱🏈⚾️🎾🏐🏉🏓🏸🏏⛳️🎯", //
        "Animals" : "🐶🦁🐮🐨🐯🐥🐒🐔🐤🐸🦊🐼", //
        "Faces" : "🤩😋😛😝😅😂😡😱🤥😘😇😑", //
        ]
    
    override func awakeFromNib() {  //belong to UISplitViewControllerDelegate (Obj-c protocal)
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let vc = secondaryViewController as? MemoryCampViewController {
            if vc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let vc = splitViewDetailMemoryCampViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                vc.theme = theme
            }
        } else if let vc = lastSeguedToMemoryCampViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                vc.theme = theme
                }
                navigationController?.pushViewController(vc, animated: true)
            }else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
        
    }
    
    private var splitViewDetailMemoryCampViewController: MemoryCampViewController? {
        return splitViewController?.viewControllers.last as? MemoryCampViewController
    }
    
    private var lastSeguedToMemoryCampViewController: MemoryCampViewController?
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            //if let button == sender as? UIButton{
                //if let themeName = button.currentTitle{
                    //if let theme = themes[themeName]
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{ //THIS IS OPTIONAL CHAIN
                if let vc = segue.destination as? MemoryCampViewController {
                    vc.theme = theme     //above two "as?" means downcasting(to see if its childclass is belong to UIButton/ConcentrationViewController)
                    lastSeguedToMemoryCampViewController = vc
                }
            }
        }
    }
    

}

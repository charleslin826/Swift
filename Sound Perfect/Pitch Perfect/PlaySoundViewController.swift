//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by user on 2018/4/26.
//  Copyright © 2018年 Charlie. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
  
    //var
    var recordedAudioURL: URL!
    var audioFile : AVAudioFile!
    var audioEngine : AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer : Timer!
    
    enum ButtonType : Int {
        case slow = 0, fast, lowPitch, highPitch,  echo, reverb
    }
    
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch: //chipmunk
            playSound(pitch: 1000)
        case .lowPitch: //vader
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
   // Note: The view hierarchy in the video may look different from the one you built. That's OK. The video was recorded with an earlier version of UIStackView. Your layout is correct.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  MusicPlayer
//
//  Created by COMATOKI on 2018-05-15.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import UIKit
import Foundation // to use timer
import AVFoundation // to add AVFramework

class ViewController: UIViewController, AVAudioPlayerDelegate // add AVAudioPlayerDelegate to use its delegates
    {
    
    //////////////////////////Set essential properties//////////////////////////
    var audioPlayer:AVAudioPlayer! // Define audioPlayer as AVAudioPlayer
    var timer = Timer() // Set timer to calculate playing time
    var min:Int = 0 // minute to display a Label text that I have already made
    var sec:Int = 0 // Second to display a Label text that I have already made
    ////////////////////////////////////////////////////////////////////////////

    ///////////////////////Properties from Main.storyboar///////////////////////
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    ////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get a sound's url
        let path = Bundle.main.url(forResource: "sound", withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path!)
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = 0
            timerLabel.text = "\(audioPlayer.currentTime)"
            audioSlider.maximumValue = Float(audioPlayer.duration)
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
        audioSlider.value = 0
        audioPlayer.stop()
        
        //slider
        audioSlider.minimumValue = 0
        audioSlider.maximumValue =  Float(audioPlayer.duration)
        self.audioPlayer.delegate = self
        

        runTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //////////////////////////////Action Method//////////////////////////////
    //Call when a user clicks the button to play or pause
    @IBAction func clicktoChangeStatus(_ sender: Any) {
        //Check a condition whether the audioPlayer is playing or not
        if(audioPlayer.isPlaying){
            audioPlayer.pause()
            controlButton.setImage(UIImage(named: "button_play"), for: UIControlState.normal)
        }else{
            audioPlayer.play()
            controlButton.setImage(UIImage(named: "button_pause"), for: UIControlState.normal)
        }
    }
    
    //Call when a user manipulates the slider's value
    @IBAction func changeSliderValue(_ sender: Any) {
        //Set a value the slider has to audioPlayer's currentTime
        audioPlayer.currentTime = TimeInterval(audioSlider.value)
    }

    //To set timer
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //It will be Called from the timer
    @objc func updateTimer(){
        //Get audioPlayer's current play time
        let strTime:Double = audioPlayer.currentTime
        
        //Define time to calculate a time to display on the label
        var time:Int
        
        //If the player is playing, it will be set audioPlayer's current playing time to time variable
        //or time variable will be set 0
        if(Int(strTime) <= 0){
            time = 0
        }else{
            time = Int(strTime)
        }
        
        //Control time
        //if the time is over 60
        //this logic adds min's value and sets sec's value to 0
        if(time >= 60){
            let num:Int = (Int)(time / 60)
            min = num
            sec = time - (num * 60)
        }else{
            sec = time
        }
        
        //to prepare to set the label's text, define timeLabelText variable
        let timeLabelText:String
        
        //Set time to the label
        //Contidion - if a value of sec is below 10, the program adds 0 in front of sec's value.
        if(sec < 10){
            //make label's text more naturally
            timeLabelText = "\(min) : 0\(sec)"
        }else{
            timeLabelText = "\(min) : \(sec)"
        }
        
        //Set text to the timer label
        timerLabel.text = timeLabelText
        //Set slider's value to show a user slider's movement
        audioSlider.value = Float(audioPlayer.currentTime)
    }
    ////////////////////////////////////////////////////////////////////////////
    
    //////////////////////A method of AVAudioPlayerDelegate//////////////////////
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Reset all elements
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        timerLabel.text = "00 : 00"
        audioSlider.value = 0
        controlButton.setImage(UIImage(named: "button_play"), for: UIControlState.normal)
    }
    ////////////////////////////////////////////////////////////////////////////

}


//
//  SermonAudioPlayerViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 14/09/2022.
//

import UIKit
import SwiftAudio
import AVKit

public var globalPlayerURL: String = ""
public var globalPlayerState: AudioPlayerState = .idle
public var globalAudioPlayer = AudioPlayer()

class SermonAudioPlayerViewController: UIViewController {
    
    var sermonImageURL: String?
    var sermonTitle: String!
    var preacherTitle: String!
    var sermonAudioURL: String!
    
    @IBOutlet var sermonImageView: UIImageView!
    @IBOutlet var sermonTitleLabel: UILabel!
    @IBOutlet var preacherTitleLabel: UILabel!
    @IBOutlet var sermonProgressView: UIProgressView!
    @IBOutlet var sermonPlayButton: UIButton!
    @IBOutlet var sermonProgressSlider: UISlider!
    @IBOutlet var sermonRateButton: UIButton!
    @IBOutlet var sermonOptionsButton: UIButton!
    @IBOutlet var startButtonLabel: UILabel!
    @IBOutlet var endButtonLabel: UILabel!
    
    var audioItem: DefaultAudioItem!
    var currentURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUIOnButtonClick()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        sermonProgressSlider.isHidden = true
        currentURL = sermonAudioURL
        sermonTitleLabel.text = sermonTitle
        preacherTitleLabel.text = preacherTitle
        if let sermonImageURL = sermonImageURL {
            sermonImageView.load(url: URL(string: sermonImageURL)!)//talk to Dara about this
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.3, alpha: 0.3)
            sermonImageView.layer.cornerRadius = 15
        }else{
            sermonImageView.image = UIImage(named: "placeholder")
            sermonImageView.layer.cornerRadius = 15
        }
        tabBarController?.tabBar.isHidden = true
        
        globalAudioPlayer.event.stateChange.addListener(self, handleAudioPlayerStateChange)
        globalAudioPlayer.event.updateDuration.addListener(self, handleAudioPlayerTimeEvent)
        
    }
    
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
        
        switch state {
        case .buffering:
            //print("Audio is  buffering")
            changeUIOnButtonClick()
            return
        case .playing:
            //print("Audio is  playing")
            changeUIOnButtonClick()
            return
        case .paused:
            //print("Audio is paused")
            changeUIOnButtonClick()
            return
        case .idle:
            //print("Engine is idle")
            changeUIOnButtonClick()
            return
        case .ready:
            //print("Engine is ready to start")
            changeUIOnButtonClick()
            return
        case .loading:
            //print("Engine is loading")
            changeUIOnButtonClick()
            return
        }
        
    }
    
    func changeUIOnButtonClick(){
        let playerState = globalPlayerState
        
        if playerState == .paused{
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        }
        else if playerState == .playing{
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            }
        }
        else if playerState == .idle {
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)

            }
        }
        
    }
    
    @IBAction func sermonRewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonForwardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonPlayButtonPressed(_ sender: Any) {
        if globalPlayerState == .idle{
            //print("Starting out initially")
            globalPlayerState = .playing
            globalPlayerURL = currentURL
            loadAudio()
            globalAudioPlayer.play()
        }
        else if globalPlayerState == .playing && globalPlayerURL == currentURL{
            //print("Pausing after having started")
            globalPlayerState = .paused
            globalAudioPlayer.pause()
        }
        else if globalPlayerState == .paused && globalPlayerURL == currentURL{
            //print("Playing after having paused")
            globalPlayerState = .playing
            globalAudioPlayer.play()
        }
        else if globalPlayerState == .playing && globalPlayerURL != currentURL{
            //print("Audio has been changed because of different row click and is now playing new audio")
            globalAudioPlayer.stop()
            loadAudio()
            globalPlayerURL = currentURL
            globalAudioPlayer.play()
    
        }
        else if globalPlayerState == .paused && globalPlayerURL != currentURL{
            //print("Audio has been changed because of different row click with previous audio paused and is now playing new audio")
            globalAudioPlayer.stop()
            loadAudio()
            globalPlayerURL = currentURL
            globalAudioPlayer.play()

        }
            

    }
    
    func handleAudioPlayerTimeEvent(event: AudioPlayer.UpdateDurationEventData){
        DispatchQueue.main.async { [self] in
            var hours: Float = 0
            let seconds: Int = Int(globalAudioPlayer.currentTime)
            let secondsLeft = seconds % 60
            var minutes: Float = Float(seconds/60)
            if minutes >= 60{
                minutes = minutes.remainder(dividingBy: 60)
                hours += 1
            }
            
            func updateTimer(){
                // sort this countdown issue later
                self.startButtonLabel.text = "\(String(format: "%.0f",hours)).\(String(format: "%.0f",minutes)).\(secondsLeft)"
                self.endButtonLabel.text = String(format: "%.0f", (Float(globalAudioPlayer.duration)/60)) + "." + String(Float(Int(globalAudioPlayer.duration)%60))
            }
            
            
            if globalPlayerURL == currentURL{
                self.sermonProgressView.setProgress(Float(globalAudioPlayer.currentTime/globalAudioPlayer.duration), animated: true)
                updateTimer()
            }
            else{
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
            if globalAudioPlayer.rate == 2.0 && globalPlayerURL == currentURL{
                self.sermonRateButton.setTitle("2X", for: .normal)
                updateTimer()
            }
            else{
                self.sermonRateButton.setTitle("1X", for: .normal)
            }
            
            
            
        }
    }
    
    func loadAudio(){
        audioItem = DefaultAudioItem(audioUrl: self.currentURL, sourceType: .stream)
        try! globalAudioPlayer.load(item: audioItem, playWhenReady: true)
    }
        
    @IBAction func sermonRateButtonPressed(_ sender: UIButton) {
        if globalAudioPlayer.rate == 1.0 {
            DispatchQueue.main.async {
                globalAudioPlayer.rate = 2.0
            }
        }
        else{
            DispatchQueue.main.async {
            globalAudioPlayer.rate = 1.0
            }
        }
    }
    
    
    @IBAction func sermonOptionButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func sermonProgressSliderDragged(_ sender: Any) {
        
    }
    
}

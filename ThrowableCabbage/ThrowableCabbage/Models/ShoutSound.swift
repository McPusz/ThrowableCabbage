//
//  ShoutSound.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 16.11.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

class ShoutSound {
    private var player: AVAudioPlayer?
    private let soundId = "UnrelentingForce"
    private let soundFormat = "mp3"
    private var soundURL: URL?
    private let soundDelay: Double = 0.8
    
    init() {
        self.soundURL = Bundle.main.url(forResource: self.soundId, withExtension: self.soundFormat)
        guard let soundURL = self.soundURL else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: soundURL, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print("Player error: \(error.localizedDescription)")
        }
        
    }
    
    func play() -> Single<Void> {
        self.stop()
        self.player?.play()
     
        return Observable<Int>.timer(self.soundDelay, period: self.soundDelay, scheduler: MainScheduler.instance).take(1)
            .map{ _ in return }
            .asSingle()
    }
    
    func stop() {
        self.player?.stop()
    }
}

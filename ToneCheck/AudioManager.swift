//
//  AudioManager.swift
//  ToneCheck
//
//  Created by HIDEYASU ISHII on 2025/03/22.
//

import Foundation
import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let session = AVAudioSession.sharedInstance()
    private var frequency = 1000.0
    
    func start() {
        try! session.setCategory(.playback, mode: .default)
        try! session.setActive(true, options: .notifyOthersOnDeactivation)
        
        let audioFormat = makeAudioFormat(sampleRate: 44100.0, channel: 2)  //サンプリング周波数44.1kHz、2channelで作成
        let buffer = makePCMBuffer(audioFormat: audioFormat)                //再生用Bufferを作成
        buffer.makeSignWave(frequency: self.frequency, soundVolume: 1)
        
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.outputNode, format: audioFormat)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        if !playerNode.isPlaying {
            playerNode.play()
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        }
    }
    
    func finish() {
        if playerNode.isPlaying {
            playerNode.stop()
        }
        
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        try! session.setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    func updateFrequency(_ frequency: Double) {
        self.frequency = frequency
    }
    
    //AudioFormatを作成
    private func makeAudioFormat(sampleRate: Double, channel: Int) -> AVAudioFormat {
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: UInt32(channel)) else {
            fatalError("Error initializing AVAudioFormat")
        }
        return audioFormat
    }
    
    // 再生用のバッファを作成
    private func makePCMBuffer(audioFormat: AVAudioFormat) -> AVAudioPCMBuffer {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(audioFormat.sampleRate)) else{
            fatalError("Error initializing AVAudioPCMBuffer")
        }
        buffer.frameLength = buffer.frameCapacity   //frameCapacityはバッファのpcmFormatのサンプリング周波数 サンプリング周波数を指定することで、1秒分の波形データを作成することにするために
        return buffer
    }
}

extension AVAudioPCMBuffer {
    // サイン波を作成
    func makeSignWave(frequency: Double, soundVolume: Double) {
        let channels = Int(self.format.channelCount)
        for ch in 0..<channels {
            let deltaTheta = 2.0 * .pi * frequency / self.format.sampleRate
            for i in 0..<Int(self.frameLength) {
                self.floatChannelData![ch][i] = Float(sin(deltaTheta * Double(i)) * soundVolume)
            }
        }
    }
}

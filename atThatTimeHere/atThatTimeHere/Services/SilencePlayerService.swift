//
//  SilencePlayerService.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 5/11/22.
//

import Foundation
import CoreAudio
import AudioToolbox
import AVFAudio

public class SilencePlayerService {
    private var audioQueue: AudioQueueRef? = nil
    public private(set) var isStarted = false
    static let shared = SilencePlayerService()

    public func play() {
        if isStarted { return }
        print("Playing silence")
        
        let avs = AVAudioSession.sharedInstance()
        try! avs.setCategory(.playback, options: .mixWithOthers)
        try! avs.setActive(true)
        isStarted = true
        var streamFormat = AudioStreamBasicDescription(
            mSampleRate: 16000,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
        let status = AudioQueueNewOutput(
            &streamFormat,
            SilenceQueueOutputCallback,
            nil, nil, nil, 0,
            &audioQueue
        )
        print("OSStatus for silence \(status)")
        var buffers = Array<AudioQueueBufferRef?>.init(repeating: nil, count: 3)
        for i in 0..<3 {
            buffers[i]?.pointee.mAudioDataByteSize = 320
            AudioQueueAllocateBuffer(audioQueue!, 320, &(buffers[i]))
            SilenceQueueOutputCallback(nil, audioQueue!, buffers[i]!)
        }
        let startStatus = AudioQueueStart(audioQueue!, nil)
        print("Start status for silence \(startStatus)")
    }

    public func stop() {
        guard isStarted else { return }
        print("Called stop silence")
        if let aq = audioQueue {
            AudioQueueStop(aq, true)
            audioQueue = nil
        }
        try! AVAudioSession.sharedInstance().setActive(false)
        isStarted = false
    }

}

fileprivate func SilenceQueueOutputCallback(_ userData: UnsafeMutableRawPointer?, _ audioQueueRef: AudioQueueRef, _ bufferRef: AudioQueueBufferRef) -> Void {
    let pointer = bufferRef.pointee.mAudioData
    let length = bufferRef.pointee.mAudioDataByteSize
    memset(pointer, 0, Int(length))
    if AudioQueueEnqueueBuffer(audioQueueRef, bufferRef, 0, nil) != 0 {
        AudioQueueFreeBuffer(audioQueueRef, bufferRef)
    }
}

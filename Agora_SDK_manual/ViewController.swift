//
//  ViewController.swift
//  Agora_SDK_manual
//
//  Created by BBC on 2021/9/15.
//

import UIKit
import AgoraRtcKit

class ViewController: UIViewController {
    var localView: UIView!
    var remoteView: UIView!
    // Add this linke to add the agoraKit variable
    var agoraKit: AgoraRtcEngineKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initializeAndJoinChannel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remoteView.frame = self.view.bounds
        localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 90, height: 160)
    }
    
    func initView() {
        remoteView = UIView()
        self.view.addSubview(remoteView)
        localView = UIView()
        self.view.addSubview(localView)
    }
    
    func initializeAndJoinChannel() {
        // Pass in your App ID here
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "APPID", delegate: self)
        
        // *Set channelprofile to live broacasting
        agoraKit?.setChannelProfile(.liveBroadcasting)
        // *Set the client role as broadcaster or audience.
        agoraKit?.setClientRole(.broadcaster)
        
        
        // Video is disabled by default. You need to call enableVideo to start a video stream.
        agoraKit?.enableVideo()
        // Create a videoCanvas to render the local video
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        agoraKit?.setupLocalVideo(videoCanvas)
        
        
        // *Disable 3A and Set audio profile for broadcaster
//        agoraKit?.setParameters("{\"che.audio.enable.aec\":false}")
//        agoraKit?.setParameters("{\"che.audio.enable.agc\":false}")
//        agoraKit?.setParameters("{\"che.audio.enable.ns\":false}")
//        agoraKit?.setAudioProfile(.musicHighQualityStereo, scenario: .gameStreaming)
        
        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(byToken: nil, channelId: "channel_bac", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
        })
    }
}

extension ViewController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}

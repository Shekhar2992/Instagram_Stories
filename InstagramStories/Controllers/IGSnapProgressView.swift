//
//  IGSnapProgressView.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/15/17.
//  Copyright © 2017 Dash. All rights reserved.
//

import UIKit

protocol SnapProgresser:class {func didCompleteProgress()}

fileprivate let interval:Float = 0.1

class IGSnapProgressView:UIProgressView {
    public weak var delegate:SnapProgresser?
    internal var elapsedTime:Float = 0.0
    internal weak var progressor:CSPausibleTimer?
}

extension IGSnapProgressView {
   @objc func delayProcess() {
        if elapsedTime >= 1.0 {
            stopTimer()
            self.delegate?.didCompleteProgress()
        }else{
            elapsedTime = elapsedTime+0.1
            progress = progress+0.1
        }
        debugPrint("Progress:\(progress)")
    }
    
    //TODO: Move these functions into Timer Protocol(BluePrint)
    public func stopTimer() {
        progressor?.timer?.invalidate()
        progressor = nil
    }
    public func resumeTimer() {
        progressor?.start()
    }
    public func pauseTimer() {
        progressor?.pause()
    }
    
    public func willBeginProgress() {
        elapsedTime = 0.0
        progressor = nil
        progressor = CSPausibleTimer.init(timeInterval: TimeInterval(interval), target: self, selector: #selector(IGSnapProgressView.delayProcess), userInfo: nil, repeats: true)
        progressor?.start()
    }
}

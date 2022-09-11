//
//  guardView.swift
//  Doc-controll-app
//
//  Created by RAPHAEL LAM CHEW RAY stu on 11/9/22.
//
// retrieved from https://itnext.io/a-way-to-protect-your-app-content-from-screenshots-in-ios-ea23153a3bc7

import Foundation
import UIKit

extension UIView {
    
    struct Constants {
        static var texfieldTag: Int { Int.max }
    }
    
    func setScreenCaptureProtection() {
        
        guard superview != nil else {
            for subview in subviews { 
                subview.setScreenCaptureProtection()
            }
            return
        }
        
        let guardTextField = UITextField()
        guardTextField.backgroundColor = .red
        guardTextField.translatesAutoresizingMaskIntoConstraints = false
        guardTextField.tag = Constants.texfieldTag
        guardTextField.isSecureTextEntry = true
        
        addSubview(guardTextField)
        guardTextField.isUserInteractionEnabled = false
        sendSubviewToBack(guardTextField)
        
        layer.superlayer?.addSublayer(guardTextField.layer)
        guardTextField.layer.sublayers?.first?.addSublayer(layer)
        
        guardTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        guardTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        guardTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        guardTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
}

public protocol ScreenRecordDelegate {
    func screen(_ screen: UIScreen, didRecordStarted isRecording: Bool)
    func screen(_ screen: UIScreen, didRecordEnded isRecording: Bool)
}

public class ScreenGuardManager {
    
    // MARK: Shared
    
    public static let shared = ScreenGuardManager()
    public var screenRecordDelegate: ScreenRecordDelegate?
    private var recordingObservation: NSKeyValueObservation?

    // MARK: Init
    
    private init() { }
    
    // MARK: Functions
    
    public func guardScreenshot(`for` window: UIWindow) {
        window.setScreenCaptureProtection()
    }
    
    public func guardScreenshot(`for` view: UIView) {
        view.setScreenCaptureProtection()
    }
    
    public func listenForScreenRecord() {
        recordingObservation =  UIScreen.main.observe(\UIScreen.isCaptured, options: [.new]) { [weak self] screen, change in
            let isRecording = change.newValue ?? false
            
            if isRecording {
                self?.screenRecordDelegate?.screen(screen, didRecordStarted: isRecording)
            } else {
                self?.screenRecordDelegate?.screen(screen, didRecordEnded: isRecording)
            }
        }
    }
    
    // MARK: Deinit
    
    deinit {
        screenRecordDelegate = nil
    }
    
}

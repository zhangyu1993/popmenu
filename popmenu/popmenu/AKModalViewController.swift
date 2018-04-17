//
//  AKModalViewController.swift
//  AKUIComponents
//
//  Created by arkin on 19/09/2017.
//  Copyright © 2017 arkin. All rights reserved.
//

import UIKit

private let modalWindow: UIWindow = UIWindow();

class AKModalViewController: UIViewController {
    
    var containerWindow: UIWindow?
    let bg = UIControl()
    
    var window: UIWindow? {
        return (UIApplication.shared.delegate?.window)!;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hideNavBar = true
        bg.frame = self.view.bounds
        bg.addTarget(self, action: #selector(hide), for: .touchDown)
        view.addSubview(bg)
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.sendSubview(toBack: bg)
    }
    
    public func show(_ backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.2)) {
        
        modalWindow.windowLevel = UIWindowLevelAlert
        modalWindow.backgroundColor = .clear
        modalWindow.rootViewController = self
//        modalWindow.makeKeyAndVisible();
        modalWindow.isUserInteractionEnabled = true;
        modalWindow.isHidden = false
        window?.addSubview(modalWindow);
        
        bg.backgroundColor = backgroundColor
//        if containerWindow == nil {
//            containerWindow = UIWindow()
//            containerWindow!.windowLevel = UIWindowLevelAlert
//            containerWindow!.backgroundColor = .clear
//        }
//        self.containerWindow!.rootViewController = self
//        self.containerWindow!.makeKeyAndVisible()
//        self.bg.backgroundColor = backgroundColor
//        self.statusBarStyle = statusBarStyle
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.view.alpha = 0
        }) { (_) in
            self.view.alpha = 1
            modalWindow.rootViewController = nil;
//            modalWindow.resignKey()
            modalWindow.isHidden = true
            modalWindow.isUserInteractionEnabled = false;
            modalWindow.removeFromSuperview();
            
//            self.containerWindow?.rootViewController = nil
//            self.containerWindow?.resignKey()
//            self.containerWindow?.isHidden = true
//            self.containerWindow?.removeFromSuperview();
//            self.containerWindow = nil
        }
    }
    
    deinit {
    }
}

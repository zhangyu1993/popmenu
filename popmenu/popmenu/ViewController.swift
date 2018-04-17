//
//  ViewController.swift
//  popmenu
//
//  Created by zhangyu on 2018/4/17.
//  Copyright © 2018年 zhangyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let b1: UIButton = UIButton(type: .custom)
        self.view.addSubview(b1)
        b1.frame = CGRect(x: 10, y: 40, width: 30, height: 30)
        b1.backgroundColor = .yellow
        b1.setTitle("pop", for: .normal)
        b1.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        
        let b2: UIButton = UIButton(type: .custom)
        self.view.addSubview(b2)
        b2.frame = CGRect(x: 100, y: 40, width: 30, height: 30)
        b2.backgroundColor = .yellow
        b2.setTitle("pop", for: .normal)
        b2.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        let b3: UIButton = UIButton(type: .custom)
        self.view.addSubview(b3)
        b3.frame = CGRect(x: 330, y: 40, width: 30, height: 30)
        b3.backgroundColor = .yellow
        b3.setTitle("pop", for: .normal)
        b3.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        let b4: UIButton = UIButton(type: .custom)
        self.view.addSubview(b4)
        b4.frame = CGRect(x: 10, y: 600, width: 30, height: 30)
        b4.backgroundColor = .yellow
        b4.setTitle("pop", for: .normal)
        b4.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        let b5: UIButton = UIButton(type: .custom)
        self.view.addSubview(b5)
        b5.frame = CGRect(x: 100, y: 600, width: 30, height: 30)
        b5.backgroundColor = .yellow
        b5.setTitle("pop", for: .normal)
        b5.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        
        let b6: UIButton = UIButton(type: .custom)
        self.view.addSubview(b6)
        b6.frame = CGRect(x: 330, y: 600, width: 30, height: 30)
        b6.backgroundColor = .yellow
        b6.setTitle("pop", for: .normal)
        b6.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        

    }

    
    @objc func click(sender:UIButton) {
        let p1 = AKPopIconItem(title: "pop1", image: UIImage(named: "icon_favor_normal")) {}
        let p2 = AKPopIconItem(title: "pop2", image: UIImage(named: "icon_favor_normal")) {}
        let p3 = AKPopIconItem(title: "pop3", image: UIImage(named: "icon_favor_normal")) {}
        let p4 = AKPopCheckItem(title: "p4") {}
        let pop = AKPopMenu([p1,p2,p3,p4])
        let rect = self.view.convert(sender.frame, to: (UIApplication.shared.delegate?.window)!)
        pop.showInRect(rect, UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


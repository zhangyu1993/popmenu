//
//  AKPopMenu.swift
//  AKUIComponents
//
//  Created by arkin on 20/09/2017.
//  Copyright © 2017 arkin. All rights reserved.
//

import UIKit


let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

enum EPopDirection {
    case up
    case down
}

enum EPopArrowAlign {
    case alignleft
    case aligncenter
    case alignright
}

fileprivate let itemHeight = 40

public class AKPopIconItem: UIControl {
    var action: (() -> Void)?
    
    var label = UILabel()
    var icon = UIImageView()
    
    public init(title: String, image: UIImage?, action:@escaping ()->Void) {
        super.init(frame: CGRect.zero)
        
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect.init(x: 10, y: (itemHeight - 20)/2, width: 20, height: 20)
        icon.image = image
        self.addSubview(icon)
        
        
        let width = 50
        label.frame = CGRect.init(x: 35, y: 0, width: Int(width), height: itemHeight)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.textColor = UIColor.red
        self.addSubview(label)
        self.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.action = action
        
//        let vLine = UIView()
//        self.addSubview(vLine)
//        vLine.backgroundColor = UIColor.gray
//        vLine.snp.makeConstraints { (make) in
//            make.leading.equalTo(10)
//            make.trailing.equalTo(-10)
//            make.height.equalTo(kSignLine)
//            make.bottom.equalTo(-kSignLine)
//        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClick() {
        if let _ = action {
            action!()
        }
    }
}

public class AKPopCheckItem: AKPopIconItem {
    override public var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            icon.isHighlighted = isSelected
            label.isHighlighted = isSelected
        }
    }
    
    public init(title: String, action:@escaping ()->Void) {
        super.init(title: title, image: nil, action: action)
        
        icon.image = nil
        icon.tintColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AKPopMenu: AKModalViewController {
    
    var items: [AKPopIconItem]!
    let containerView = UIView()
    let backgroundView = UIView()
    let backgroundLayer = CAShapeLayer()
    let hMargin: CGFloat = 10
    let vMargin: CGFloat = 5
    let arrowHeight: CGFloat = 8
    let arrowWidth: CGFloat = 18
    let radius: CGFloat = 4
    
    public init(_ items: [AKPopIconItem], defaultSelect: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        
        self.items = items
        self.items[defaultSelect].isSelected = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var maxWidth: CGFloat = 0
        for item in items {
            if maxWidth < item.label.frame.width + 45 {
                maxWidth = item.label.frame.width + 45
            }
        }
        
        containerView.bounds = CGRect.init(x: 0, y: 0, width: Int(maxWidth), height: itemHeight * items.count)
        backgroundView.bounds = CGRect.init(x: 0, y: 0, width: Int(maxWidth), height: itemHeight * items.count + Int(arrowHeight))
        
        for (index, item) in items.enumerated() {
            item.frame = CGRect.init(x: 0, y: itemHeight * index, width: Int(maxWidth), height: itemHeight)
            item.addTarget(self, action: #selector(itemOnClick), for: .touchUpInside)
            containerView.addSubview(item)
        }
        view.addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        
        backgroundLayer.strokeColor = UIColor.hex(from: 0xffeeeeee).cgColor
        backgroundLayer.lineWidth = 1
        backgroundLayer.fillColor = UIColor.white.cgColor
        backgroundLayer.frame = backgroundView.bounds
        backgroundView.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func showInRect(_ rect: CGRect, _ backgroundColor: UIColor = UIColor.clear) {
        super.show(backgroundColor)
        
        let result = position(rect)
        let points = result.points
        let origin = result.origin
        let direction = result.direction
        let width = backgroundView.frame.width
        let height = backgroundView.frame.height
        let path = UIBezierPath.init()
        backgroundView.frame.origin = origin
        
        if direction == .up {
            containerView.frame.origin = .zero
            
            path.move(to: CGPoint.init(x: 0, y: radius))
            path.addLine(to: CGPoint.init(x: 0, y: height - arrowHeight - radius))
            path.addArc(withCenter: CGPoint.init(x: radius, y: height - arrowHeight - radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 5/6), clockwise: false)
            path.addLine(to: CGPoint.init(x: radius, y: height - arrowHeight))
            path.addLine(to: points[0])
            path.addLine(to: points[1])
            path.addLine(to: points[2])
            path.addLine(to: CGPoint.init(x: width - radius, y: height - arrowHeight))
            path.addArc(withCenter: CGPoint.init(x: width - radius, y: height - arrowHeight - radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: 0, clockwise: false)
            path.addLine(to: CGPoint.init(x: width, y: height - arrowHeight - radius))
            path.addLine(to: CGPoint.init(x: width, y: radius))
            path.addArc(withCenter: CGPoint.init(x: width - radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 3/2), clockwise: false)
            path.addLine(to: CGPoint.init(x: width - radius, y: 0))
            path.addLine(to: CGPoint.init(x: radius, y: 0))
            path.addArc(withCenter: CGPoint.init(x: radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi * 3/2), endAngle: CGFloat(Double.pi), clockwise: false)
            path.close()

        } else {
            containerView.frame.origin = CGPoint.init(x: 0, y: arrowHeight)
            
            path.move(to: CGPoint.init(x: radius, y: arrowHeight))
            path.addLine(to: points[0])
            path.addLine(to: points[1])
            path.addLine(to: points[2])
            path.addLine(to: CGPoint.init(x: width - radius, y: arrowHeight))
            path.addArc(withCenter: CGPoint.init(x: width - radius, y: arrowHeight + radius), radius: radius, startAngle: CGFloat(Double.pi*3/2), endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint.init(x: width, y: arrowHeight + radius ))
            path.addLine(to: CGPoint.init(x: width, y: height - radius ))
            path.addArc(withCenter: CGPoint.init(x: width - radius, y: height - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
            path.addLine(to: CGPoint.init(x: width - radius, y: height))
            path.addLine(to: CGPoint.init(x: radius, y: height))
            path.addArc(withCenter: CGPoint.init(x: radius, y: height - radius), radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
            path.addLine(to: CGPoint.init(x: 0, y: height - radius))
            path.addLine(to: CGPoint.init(x: 0, y: arrowHeight + radius))
            path.addArc(withCenter: CGPoint.init(x: radius, y: arrowHeight + radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
            path.close()
        }
        backgroundLayer.path = path.cgPath
        
        var anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var bgposition = CGPoint.zero
        switch direction {
        case .down:
            anchorPoint = CGPoint(x: points[1].x / width, y: 0.0)
            bgposition = CGPoint(x: backgroundView.center.x - (width / 2 - points[1].x), y: backgroundView.center.y - height / 2)
        case .up:
            anchorPoint = CGPoint(x: points[1].x / width, y: 1.0)
            bgposition = CGPoint(x: backgroundView.center.x - (width / 2 - points[1].x), y: backgroundView.center.y + height / 2)
        }
        backgroundView.layer.anchorPoint = anchorPoint
        backgroundView.layer.position = bgposition
        backgroundView.layer.transform = CATransform3DMakeScale(0, 0, 1)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    func position(_ rect: CGRect) -> (origin: CGPoint, direction: EPopDirection, align: EPopArrowAlign, points: [CGPoint]) {
        let centerX = (rect.maxX - rect.minX) / 2 + rect.origin.x
        let width = containerView.frame.width
        let height = containerView.frame.height
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        var direction: EPopDirection = .down
        var align: EPopArrowAlign = .aligncenter
        if centerX + width/2 < kScreenWidth - hMargin, centerX - width/2 > hMargin {
            // 居中
            originX = centerX - width/2
        } else if centerX + width/2 < kScreenWidth - hMargin {
            // 左对齐
            originX = hMargin
            align = .alignleft
        } else {
            // 右对齐
            originX = kScreenWidth - hMargin - width
            align = .alignright
        }
        
        if rect.maxY + height + vMargin < kScreenHeight {
            // 向下展开
            originY = rect.maxY + vMargin
        } else if rect.minY - vMargin - height > 0 {
            // 向上展开
            originY = rect.minY - vMargin - height - arrowHeight
            direction = .up
        } else {
            // 上下都超向下展开
            originY = rect.maxY + vMargin
        }
        
        var points: [CGPoint] = []
        switch (direction, align) {
        case (.down, .alignleft):
            points = [CGPoint.init(x: centerX - originX, y: arrowHeight),
                      CGPoint.init(x: centerX - originX, y: 0),
                      CGPoint.init(x: centerX - originX + arrowWidth , y: arrowHeight)]
        case (.down, .aligncenter):
            points = [CGPoint.init(x: centerX - originX - arrowWidth / 2, y: arrowHeight),
                      CGPoint.init(x: centerX - originX , y: 0),
                      CGPoint.init(x: centerX - originX + arrowWidth / 2, y: arrowHeight)]
        case (.down, .alignright):
            points = [CGPoint.init(x: centerX - originX - arrowWidth, y: arrowHeight),
                      CGPoint.init(x: centerX - originX , y: 0),
                      CGPoint.init(x: centerX - originX , y: arrowHeight)]
        case (.up, .alignleft):
            points = [CGPoint.init(x: centerX - originX, y: height),
                      CGPoint.init(x: centerX - originX, y: height + arrowHeight),
                      CGPoint.init(x: centerX - originX + arrowWidth , y: height)]
        case (.up, .aligncenter):
            points = [CGPoint.init(x: centerX - originX - arrowWidth / 2, y: height),
                      CGPoint.init(x: centerX - originX, y: height + arrowHeight),
                      CGPoint.init(x: centerX - originX + arrowWidth / 2, y: height)]
        case (.up, .alignright):
            points = [CGPoint.init(x: centerX - originX - arrowWidth, y: height),
                      CGPoint.init(x: centerX - originX , y: height + arrowHeight),
                      CGPoint.init(x: centerX - originX , y: height)]
        }
        return (CGPoint.init(x: originX, y: originY), direction, align, points)
    }
    
    @objc func itemOnClick(_ sender: AKPopIconItem) {
        for item in items {
            item.isSelected = item == sender
        }
        hide()
    }
}

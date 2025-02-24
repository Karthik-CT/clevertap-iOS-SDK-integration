//
//  DottedLineView.swift
//  push
//
//  Created by Karthik Iyer on 24/02/25.
//

import UIKit

class DottedLineView: UIView {
    
    private var startPoint: CGPoint
    private var endPoint: CGPoint
    private let dashedLayer = CAShapeLayer()
    private let yellowDotLayer = CAShapeLayer()
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Debug: Check if startPoint and endPoint are valid
        print("Drawing line from \(startPoint) to \(endPoint)")
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(4)
        
        let dashPattern: [CGFloat] = [6, 3] // 6pt line, 3pt gap
        context.setLineDash(phase: 0, lengths: dashPattern)
        
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.strokePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawYellowDot()
    }
    
    private func drawYellowDot() {
        yellowDotLayer.removeFromSuperlayer() // Remove any existing dots
        
        let circleRadius: CGFloat = 10
        let circlePath = UIBezierPath(ovalIn: CGRect(
            x: endPoint.x - circleRadius / 2,
            y: endPoint.y - circleRadius / 2,
            width: circleRadius,
            height: circleRadius
        ))
        
        yellowDotLayer.fillColor = UIColor.yellow.cgColor
        yellowDotLayer.path = circlePath.cgPath
        
        self.layer.addSublayer(yellowDotLayer)
    }
}

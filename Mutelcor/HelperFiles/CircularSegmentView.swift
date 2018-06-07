//
//  CircularSegmentView.swift
//  Mutelcor
//
//  Created by  on 18/07/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

// MARK: Circular Segment View Delegate Protocol
protocol CircularSegmentViewDelegate: class {
    func circularSegmentView(_ circularSegmentView: CircularSegmentView, didTapAt layer: Layer)
}

// MARK: Layer Enum
enum Layer {
    case first
    case second
    case third
}

class CircularSegmentView: UIView {
    
    let pi = CGFloat.pi
    var addedLayers: [IndexedShapeLayer] = []
    private lazy var centerLabel = UILabel()
    var excessWeight : String? {
        didSet {
            
        }
    }
    var startingWeight: Int = 0 {
        didSet {
            setText(of: firstTextLayer, with: startingWeight)
        }
    }
    
    var targetWeight: Int = 0 {
        didSet {
            setText(of: secondTextLayer, with: targetWeight)
        }
    }
    
    var currentWeight: Int = 0 {
        didSet {
            setText(of: thirdTextLayer, with: currentWeight)
        }
    }
    
    weak var delegate: CircularSegmentViewDelegate?
    
    private var firstTextLayer: CATextLayer?
    private var secondTextLayer: CATextLayer?
    private var thirdTextLayer: CATextLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customise center label
        centerLabel.numberOfLines = 0
        centerLabel.textColor = .black
        centerLabel.font = AppFonts.sanProSemiBold.withSize(15)
        centerLabel.textAlignment = .center
        setCenterLabel(text: "Weight\nLoss\n0\nkg", highlightedText: "")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addedLayers.removeAll(keepingCapacity: false)
        self.layer.sublayers?.removeAll(keepingCapacity: false)
        centerLabel.removeFromSuperview()
        
        centerLabel.center = CGPoint(x: rect.midX, y: rect.midY)
        self.addSubview(centerLabel)
        
        let segmentCount: Int = 3
        let floatingSegmentCount = CGFloat(segmentCount)
        
        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        let segmentGap: CGFloat = 8
        let layerCornerRadius: CGFloat = 10
        
        let innerRadius: CGFloat = 0.48*rect.width/2
        let innerVirtualRadius: CGFloat = (innerRadius + layerCornerRadius)
        let outerRadius: CGFloat = rect.width/2
        let outerVirtualRadius: CGFloat = (outerRadius - layerCornerRadius)
        
        let innerGap = getArcAngle(arcLength: segmentGap, radius: innerRadius)
        let innerCircumGap = getArcAngle(arcLength: layerCornerRadius, radius: innerRadius)
        let innerVirtualGap = getArcAngle(arcLength: segmentGap, radius: innerVirtualRadius)
        let outerGap = getArcAngle(arcLength: segmentGap, radius: outerRadius)
        let outerCircumGap = getArcAngle(arcLength: layerCornerRadius, radius: outerRadius)
        let outerVirtualGap = getArcAngle(arcLength: segmentGap, radius: outerVirtualRadius)
        
        let innerSegmentAngleSize = getAngleSize(gap: innerGap, segmentCount: floatingSegmentCount)
        let innerVirtualSegmentAngleSize = getAngleSize(gap: innerVirtualGap, segmentCount: floatingSegmentCount)
        let outerSegmentAngleSize = getAngleSize(gap: outerGap, segmentCount: floatingSegmentCount)
        let outerVirtualSegmentAngleSize = getAngleSize(gap: outerVirtualGap, segmentCount: floatingSegmentCount)
        
        for i in 0 ..< segmentCount {
            let (innerStart, innerEnd) = getStartEndAngle(segment: i, angleSize: innerSegmentAngleSize, gap: innerGap)
            let (innerCircumStart, innerCircumEnd) = (innerStart + innerCircumGap, innerEnd - innerCircumGap)
            let (innerVirtualStart, innerVirtualEnd) = getStartEndAngle(segment: i, angleSize: innerVirtualSegmentAngleSize, gap: innerVirtualGap)
            let (outerStart, outerEnd) = getStartEndAngle(segment: i, angleSize: outerSegmentAngleSize, gap: outerGap)
            let (outerCircumStart, outerCircumEnd) = (outerStart + outerCircumGap, outerEnd - outerCircumGap)
            let (outerVirtualStart, outerVirtualEnd) = getStartEndAngle(segment: i, angleSize: outerVirtualSegmentAngleSize, gap: outerVirtualGap)
            
            let segmentPath = getPath(arcCenter: center, innerRadius: innerRadius, innerVirtualRadius: innerVirtualRadius, outerRadius: outerRadius, outerVirtualRadius: outerVirtualRadius, innerStartAngle: innerStart, innerEndAngle: innerEnd, innerCircumStartAngle: innerCircumStart, innerCircumEndAngle: innerCircumEnd, innerVirtualStartAngle: innerVirtualStart, innerVirtualEndAngle: innerVirtualEnd, outerStartAngle: outerStart, outerEndAngle: outerEnd, outerCircumStartAngle: outerCircumStart, outerCircumEndAngle: outerCircumEnd, outerVirtualStartAngle: outerVirtualStart, outerVirtualEndAngle: outerVirtualEnd)
            //            UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: start, endAngle: end, clockwise: true)
            
            let arcLayer = IndexedShapeLayer()
            arcLayer.path = segmentPath.cgPath
            arcLayer.fillColor = UIColor(red: 44/255, green: 193/255, blue: 187/255, alpha: 1).cgColor
            arcLayer.lineWidth = 2
            arcLayer.index = i
            if i == 0 {
                arcLayer.setSelectedColor()
            } else {
                arcLayer.setUnselectedColor()
            }
            let pathRect = segmentPath.bounds
            arcLayer.bounds = pathRect
            arcLayer.position = CGPoint(x: pathRect.midX, y: pathRect.midY)
            
            let textLayer = CATextLayer()
            switch i {
            case 0:
                setText(of: textLayer, with: startingWeight)
            case 1:
                setText(of: textLayer, with: targetWeight)
            case 2:
                setText(of: textLayer, with: currentWeight)
            default:
                break
            }
            
            let x = arcLayer.position.x
            let y = arcLayer.position.y
            let w = pathRect.width
            let h = pathRect.width
            
            switch i {
            case 0:
                firstTextLayer = textLayer
                textLayer.position = CGPoint(x: (x + 0.11*w), y: y)
            case 1:
                secondTextLayer = textLayer
                textLayer.position = CGPoint(x: (x - 0.05*w), y: (y + 0.09*h))
            case 2:
                thirdTextLayer = textLayer
                textLayer.position = CGPoint(x: (x - 0.05*w), y: (y - 0.09*h))
            default:
                break
            }
            
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.rasterizationScale = UIScreen.main.scale
            
            textLayer.isWrapped = true
            textLayer.truncationMode = kCATruncationEnd
            
            arcLayer.addSublayer(textLayer)
            self.layer.addSublayer(arcLayer)
            addedLayers.append(arcLayer)
        }
    }
    
    private func getArcAngle(arcLength: CGFloat, radius: CGFloat) -> CGFloat {
        let circumferenceOfCircle = (2 * pi * radius)
        let angleInDegrees = (arcLength * 360 / circumferenceOfCircle)
        let angleInRadians = (pi * angleInDegrees / 180)
        return angleInRadians
    }
    
    private func getAngleSize(gap: CGFloat, segmentCount: CGFloat) -> CGFloat {
        return (2.0 * pi - segmentCount * gap) / segmentCount
    }
    
    private func getStartEndAngle(segment: Int, angleSize: CGFloat, gap: CGFloat) -> (CGFloat, CGFloat) {
        let start = CGFloat(segment) * (angleSize + gap) - (pi / 2.0)
        let end = start + angleSize
        // 30 degree in radian is 0.523599
        let addedDegree: CGFloat = 0.523599
        return (start + addedDegree, end + addedDegree)
    }
    
    private func getPath(arcCenter: CGPoint, innerRadius: CGFloat, innerVirtualRadius: CGFloat, outerRadius: CGFloat, outerVirtualRadius: CGFloat, innerStartAngle: CGFloat, innerEndAngle: CGFloat, innerCircumStartAngle: CGFloat, innerCircumEndAngle: CGFloat, innerVirtualStartAngle: CGFloat, innerVirtualEndAngle: CGFloat, outerStartAngle: CGFloat, outerEndAngle: CGFloat, outerCircumStartAngle: CGFloat, outerCircumEndAngle: CGFloat, outerVirtualStartAngle: CGFloat, outerVirtualEndAngle: CGFloat) -> UIBezierPath {
        
        let innerStartPoint = getPoint(center: arcCenter, radius: innerRadius, angle: innerStartAngle)
        let innerEndPoint = getPoint(center: arcCenter, radius: innerRadius, angle: innerEndAngle)
        
        let innerCircumStartPoint = getPoint(center: arcCenter, radius: innerRadius, angle: innerCircumStartAngle)
        //        let innerCircumEndPoint = getPoint(center: arcCenter, radius: innerRadius, angle: innerCircumEndAngle)
        
        let innerVirtualStartPoint = getPoint(center: arcCenter, radius: innerVirtualRadius, angle: innerVirtualStartAngle)
        let innerVirtualEndPoint = getPoint(center: arcCenter, radius: innerVirtualRadius, angle: innerVirtualEndAngle)
        
        let outerStartPoint = getPoint(center: arcCenter, radius: outerRadius, angle: outerStartAngle)
        let outerEndPoint = getPoint(center: arcCenter, radius: outerRadius, angle: outerEndAngle)
        
        //        let outerCircumStartPoint = getPoint(center: arcCenter, radius: outerRadius, angle: outerCircumStartAngle)
        let outerCircumEndPoint = getPoint(center: arcCenter, radius: outerRadius, angle: outerCircumEndAngle)
        
        let outerVirtualStartPoint = getPoint(center: arcCenter, radius: outerVirtualRadius, angle: outerVirtualStartAngle)
        let outerVirtualEndPoint = getPoint(center: arcCenter, radius: outerVirtualRadius, angle: outerVirtualEndAngle)
        
        //        let innerStartCentroid = getCentroid(firstVertex: innerStartPoint, secondVertex: innerCircumStartPoint, thirdVertex: innerVirtualStartPoint)
        //        let innerEndCentroid = getCentroid(firstVertex: innerEndPoint, secondVertex: innerCircumEndPoint, thirdVertex: innerVirtualEndPoint)
        //        let outerStartCentroid = getCentroid(firstVertex: outerStartPoint, secondVertex: outerCircumStartPoint, thirdVertex: outerVirtualStartPoint)
        //        let outerEndCentroid = getCentroid(firstVertex: outerEndPoint, secondVertex: outerCircumEndPoint, thirdVertex: outerVirtualEndPoint)
        
        let path = UIBezierPath()
        
        path.move(to: innerCircumStartPoint )
        path.addArc(withCenter: arcCenter, radius: innerRadius, startAngle: innerCircumStartAngle, endAngle: innerCircumEndAngle, clockwise: true)
        path.addQuadCurve(to: innerVirtualEndPoint, controlPoint: innerEndPoint)
        path.addLine(to: outerVirtualEndPoint)
        path.addQuadCurve(to: outerCircumEndPoint, controlPoint: outerEndPoint)
        path.addArc(withCenter: arcCenter, radius: outerRadius, startAngle: outerCircumEndAngle, endAngle: outerCircumStartAngle, clockwise: false)
        path.addQuadCurve(to: outerVirtualStartPoint, controlPoint: outerStartPoint)
        path.addLine(to: innerVirtualStartPoint)
        path.addQuadCurve(to: innerCircumStartPoint, controlPoint: innerStartPoint)
        
        path.close()
        return path
    }
    
    private func getPoint(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    private func getCentroid(firstVertex: CGPoint, secondVertex: CGPoint, thirdVertex: CGPoint) -> CGPoint {
        let x = (firstVertex.x + secondVertex.x + thirdVertex.x)/3
        let y = (firstVertex.y + secondVertex.y + thirdVertex.y)/3
        return CGPoint(x: x, y: y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        for sublayer in self.layer.sublayers ?? [] {
            guard let indexedShapeLayer = sublayer as? IndexedShapeLayer,
                let index = indexedShapeLayer.index,
                indexedShapeLayer.path?.contains(touchPoint) == true else {
                    continue
            }
            resetAddedLayers()
            indexedShapeLayer.setSelectedColor()
            
            switch index {
            case 0:
                delegate?.circularSegmentView(self, didTapAt: .first)
            case 1:
                delegate?.circularSegmentView(self, didTapAt: .second)
            case 2:
                delegate?.circularSegmentView(self, didTapAt: .third)
            default:
                break
            }
            break
        }
    }
    
    private func resetAddedLayers() {
        addedLayers.forEach { addedLayer in
            addedLayer.setUnselectedColor()
        }
    }
    
    private func setText(of layer: CATextLayer?, with weight: Int) {
        guard let textLayer = layer else {
            return
        }
        var attributes = [NSAttributedStringKey: Any]()
        attributes[NSAttributedStringKey.font] = AppFonts.sansProBold.withSize(27)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.white
        let mutAttrStr = NSMutableAttributedString(string: "\(weight)", attributes: attributes as [NSAttributedStringKey: Any])
        attributes[NSAttributedStringKey.font] = AppFonts.sansProRegular.withSize(13.6)
        let attrStr = NSAttributedString(string: "\nkg", attributes: attributes as [NSAttributedStringKey: Any])
        mutAttrStr.append(attrStr)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = mutAttrStr
        label.sizeToFit()
        
        let minimumWidth = max(label.intrinsicContentSize.width, 43)
        let textLayerSize = CGSize(width: minimumWidth, height: label.intrinsicContentSize.height)
        
        textLayer.string = mutAttrStr
        textLayer.bounds = CGRect(origin: .zero, size: textLayerSize)
    }
    
    func setText(of layer: Layer, with weight: Int) {
        switch layer {
        case .first:
            setText(of: firstTextLayer, with: weight)
        case .second:
            setText(of: secondTextLayer, with: weight)
        case .third:
            setText(of: thirdTextLayer, with: weight)
        }
    }
    
    func setCenterLabel(text: String, highlightedText: String) {
        let attributedText = NSMutableAttributedString(string: text)
        
        let fontSize: CGFloat = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS) ? 22 : 28
        var font = AppFonts.sansProBold.withSize(fontSize)
        var range = (text as NSString).range(of: highlightedText)
        attributedText.addAttribute(NSAttributedStringKey.font, value: font, range: range)
//        let fontTextSize: CGFloat = DeviceType.IS_IPHONE_5 ? 22 : 28
        font = AppFonts.sansProRegular.withSize(13.6)
        range = (text as NSString).range(of: "kg")
        attributedText.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        centerLabel.attributedText = attributedText
        centerLabel.sizeToFit()
    }
}

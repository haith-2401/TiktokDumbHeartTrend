//
//  ViewController.swift
//  FaveButtonDemo
//
//  Created by Jansel Valentin on 6/12/16.
//  Copyright © 2016 Jansel Valentin. All rights reserved.
//

import UIKit
import FaveButton


func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class ViewController: UIViewController, FaveButtonDelegate{
    
    @IBOutlet var heartButton: FaveButton?
	@IBOutlet weak var heartImage: UIImageView!
	
	var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // optional, set default selected fave-buttons with initial
        // startup animation disabled.
        self.heartButton?.setSelected(selected: true, animated: false)
		heartButton?.backgroundColor = .clear
		heartButton?.titleLabel?.text = ""
		
		heartButton?.setTitle("", for: .normal)
		heartButton?.isHidden = false
		heartButton?.tintColor = .clear
		
		let pulse1 = CASpringAnimation(keyPath: "transform.scale")
		pulse1.duration = 0.6
		pulse1.fromValue = 1.0
		pulse1.toValue = 1.12
		pulse1.autoreverses = true
		pulse1.repeatCount = 1
		pulse1.initialVelocity = 0.5
		pulse1.damping = 0.8

		let animationGroup = CAAnimationGroup()
		animationGroup.duration = 1.5
		animationGroup.repeatCount = .infinity
		animationGroup.animations = [pulse1]

		heartImage.layer.add(animationGroup, forKey: "pulse")
		animatedStart()
    }
    
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),        
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }
	
	
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        return colors
    }
	
	func animatedStart() {
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

	}
	
	@objc func runTimedCode() {
		DispatchQueue.main.async {
			self.heartButton?.isHidden = false
			self.heartButton?.animateSelect(true, duration: 1000)
		}
	}
}

extension UIBezierPath {
	convenience init(heartIn rect: CGRect) {
		self.init()

		//Calculate Radius of Arcs using Pythagoras
		let sideOne = rect.width * 0.4
		let sideTwo = rect.height * 0.3
		let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

		//Left Hand Curve
		self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)

		//Top Centre Dip
		self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))

		//Right Hand Curve
		self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)

		//Right Bottom Line
		self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))

		//Left Bottom Line
		self.close()
	}
}

extension Int {
	var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

//
//  ViewController.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
		
	@IBOutlet var drawView: DrawView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func clearTapped()
	{
		var theDrawView = drawView as DrawView
		theDrawView.lines = []
		theDrawView.setNeedsDisplay()
	}
	
	@IBAction func colorTapped(button: UIButton){
		var theDrawView = drawView as DrawView
		var color: UIColor!
		if( button.tag == 1){
			color = UIColor.redColor()
		}
		else{
			color = UIColor.blackColor()
		}
		theDrawView.drawColor = color
		
	}
	
	@IBAction func modeGeometric(sender: AnyObject) {
		var theDrawView = drawView as DrawView
		theDrawView.modeGeometric = "1"
	}
	@IBAction func modeMirrorX(sender: AnyObject) {
		var theDrawView = drawView as DrawView
		theDrawView.modeMirrorX = "1"
	}
	@IBAction func modeMirrorY(sender: AnyObject) {
	}
	// MARK: - Misc
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

}


//
//  ViewController.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
		
	@IBOutlet var gridView: UIView!
	@IBOutlet var drawView: DrawView!
	
	@IBOutlet var optionClear: UIButton!
	@IBOutlet var optionSave: UIButton!
	
	@IBOutlet var modeGeometric: UIButton!
	@IBOutlet var modeMirror: UIButton!
	@IBOutlet var modeThick: UIButton!
	@IBOutlet var modeRounded: UIButton!
	@IBOutlet var modeColor: UIButton!
	@IBOutlet var modeContinuous: UIButton!
	
	@IBOutlet var interfaceModes: UIView!
	
	@IBOutlet var renderView: UIImageView!
	@IBOutlet var outputView: UIView!
	
	var tileSize:CGFloat!
	var screenWidth:CGFloat!
	var screenHeight:CGFloat!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		templateStart()
		loadMenu()
		loadSettings()
	}
	
	// MARK: Settings -
	
	func loadSettings()
	{

	}
	
	// MARK: Menu -
	
	func loadMenu()
	{
		let menus = [
			"mirror":["none","x","y","rotated"],
			"shape":["freehand","squared","squared-half"],
			"thickness":["1","2","3","4","5","oscillating"],
			"rounding":["round","squared"],
			"colour":["black","red","cyan","white","gradiant-black","chessboard"]
		]
		
		println(menus)
		
		
		let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
		button.frame = CGRectMake(0, 0, tileSize, tileSize)
		button.backgroundColor = UIColor.greenColor()
		button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
		
		self.view.addSubview(button)
		
		
		self.interfaceModes.backgroundColor = UIColor.redColor()
	}
	
	// MARK: Templates -
	
	func templateStart()
	{
		tileSize = self.view.frame.size.width/8
		screenWidth = self.view.frame.size.width
		screenHeight = self.view.frame.size.height
		
		var theDrawView = drawView as DrawView
		theDrawView.setUnit = tileSize
		
		theDrawView.setRenderView(renderView,targetOutputView: outputView)
		theDrawView.setMenuViewNew(interfaceModes)
		
		renderView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		outputView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		theDrawView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		
		// Interfaces
		interfaceModes.frame = CGRectMake(0, screenHeight-tileSize, screenWidth, tileSize)
		
		// Options
		
		optionClear.frame = CGRectMake(screenWidth-(tileSize), 0, tileSize, tileSize)
		optionClear.backgroundColor = UIColor.redColor()
		optionClear.setTitle("Nu", forState: UIControlState.Normal)
		
		optionSave.frame = CGRectMake(screenWidth-(2*tileSize), 0, tileSize, tileSize)
		optionSave.setTitle("Sa", forState: UIControlState.Normal)
		
		// Modes
		modeMirror.frame = CGRectMake(0, 0, tileSize, tileSize)
		modeMirror.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeMirror.setTitle("Mi", forState: UIControlState.Normal)
		
		// Geometric
		modeGeometric.frame = CGRectMake(tileSize, 0, tileSize, tileSize)
		modeGeometric.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeGeometric.setTitle("Sq", forState: UIControlState.Normal)
		
		// Thickness
		modeThick.frame = CGRectMake(tileSize*2, 0, tileSize, tileSize)
		modeThick.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeThick.setTitle("Th", forState: UIControlState.Normal)
		
		// Roundess
		modeRounded.frame = CGRectMake(tileSize*3, 0, tileSize, tileSize)
		modeRounded.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeRounded.setTitle("Rn", forState: UIControlState.Normal)
		
		// Color
		modeColor.frame = CGRectMake(tileSize*4, 0, tileSize, tileSize)
		modeColor.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeColor.setTitle("Cb", forState: UIControlState.Normal)
			
		templateGrid()
	}
	
	func templateGrid()
	{
		var lineView = UIView(frame: CGRectMake(tileSize, tileSize, 1, screenHeight-(2*tileSize)))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(screenWidth-tileSize, tileSize, 1, screenHeight-(2*tileSize)))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(tileSize, tileSize, screenWidth-(2*tileSize), 1))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(tileSize, screenHeight-tileSize, screenWidth-(2*tileSize), 1))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		var x:CGFloat = 1
		while x < 18
		{
			var y:CGFloat = 1
			while y < 30
			{
				var posX:CGFloat =  CGFloat( Int( tileSize+(tileSize/2*x) ) )
				var posY:CGFloat =  CGFloat( Int( tileSize+(tileSize/2*y) ) )
				
				var lineView = UIView(frame: CGRectMake( posX, posY, 1, 1))
				lineView.backgroundColor = UIColor.whiteColor()
				self.gridView.addSubview(lineView)
				
				y = y + 1
			}
			
			x = x + 1
		}
	}
	
	@IBAction func optionClear(sender: AnyObject)
	{
		let randomColour = Int(arc4random_uniform(5))
		
		let colours = [UIColorFromRGB(0x72dec2).CGColor,UIColorFromRGB(0xff0000).CGColor,UIColorFromRGB(0x222222).CGColor,UIColorFromRGB(0xffffff).CGColor,UIColorFromRGB(0xdddddd).CGColor,UIColorFromRGB(0x999999).CGColor]
		let randomIndex = Int(arc4random_uniform(UInt32(colours.count)))
		
		self.outputView.backgroundColor = UIColor(CGColor: colours[randomIndex])
		
		NSLog("> OPTI | Clear")
		var theDrawView = drawView as DrawView
		theDrawView.lines = []
		renderView.image = UIImage(named: "")
		theDrawView.setNeedsDisplay()
	}
	
	@IBAction func optionSave(sender: AnyObject)
	{
		UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.width, self.view.frame.height))
		outputView.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
		
		interfaceModes.hidden = true
	}

	// Modes
	
	@IBAction func modeMirror(sender: AnyObject)
	{
		modeMirrorToggle()
	}
	
	func modeMirrorToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["M","Mx","My","Mr","Ms","Mo","Mv"]
		var modesIndex = find(modes, theDrawView.modeMirror)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeMirror = modes[modeTarget]
		modeMirror.setTitle( String(format:"%@",modes[modeTarget]), forState: UIControlState.Normal)
	}
	
	// Color
	
	@IBAction func modeColor(sender: AnyObject)
	{
		modeColorToggle()
	}
	
	func modeColorToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Cb","Cw","Cy","Cr","Gg","Gd","Gh"]
		var modesIndex = find(modes, theDrawView.modeColor)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeColor = modes[modeTarget]
		modeColor.setTitle( String(format:"%@",modes[modeTarget]), forState: UIControlState.Normal)
		theDrawView.setNeedsDisplay()
	}
	
	// Geometric
	
	@IBAction func modeGeometric(sender: AnyObject)
	{
		modeGeometricToggle()
	}
	
	func modeGeometricToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Gf","Gs","Gp"]
		var modesIndex = find(modes, theDrawView.modeGeometric)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeGeometric = modes[modeTarget]
		modeGeometric.setTitle( String(format:"%@",modes[modeTarget]), forState: UIControlState.Normal)
	}
	
	// Thickness
	
	@IBAction func modeThick(sender: AnyObject)
	{
		modeThickToggle()
	}
	
	func modeThickToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["T1","T2","T3","T4","T5","Ta"]
		var modesIndex = find(modes, theDrawView.modeThick)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeThick = modes[modeTarget]
		modeThick.setTitle( String(format:"%@",modes[modeTarget]), forState: UIControlState.Normal)
	}
	
	@IBAction func modeRounded(sender: AnyObject)
	{
		modeRoundedToggle()
	}
	
	func modeRoundedToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Rr","Rs"]
		var modesIndex = find(modes, theDrawView.modeRounded)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeRounded = modes[modeTarget]
		modeRounded.setTitle( String(format:"%@",modes[modeTarget]), forState: UIControlState.Normal)
	}
	
	@IBAction func modeContinuous(sender: AnyObject) {
		
	}
	
	// MARK: - Misc
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func UIColorFromRGB(rgbValue: UInt) -> UIColor {
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}


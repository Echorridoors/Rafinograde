//
//  ViewController.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

var menus:Dictionary<String,Array<String>> = ["":["",""]]
var settings:Dictionary<String,String> = ["":""]
var selectionView:UIView!
var currentColour:CGColor!
var clickSound:SystemSoundID?
var optionSound:SystemSoundID?

class ViewController: UIViewController {
		
	@IBOutlet var gridView: UIView!
	@IBOutlet var drawView: DrawView!
	
	@IBOutlet weak var notificationLabel: UILabel!
	@IBOutlet var renderView: UIImageView!
	@IBOutlet var outputView: UIView!
	
	var tileSize:CGFloat!
	var screenWidth:CGFloat!
	var screenHeight:CGFloat!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		menus = [
			"mirror":["none","x","y","radius"],
			"grid":["freehand","large","small"],
			"thickness":["1","2","3","4","osc"],
			"rounding":["round","square","none"],
			"color":["black","red","cyan","white","chess"],
			"system":["share","save","clear"],
			"filter":[""]
		]
		
		// Set default settings
		for categories in menus {
			settings[categories.0] = categories.1[0]
		}
		
		templateStart()
		loadMenu()
		
		settings["color"] = "chess"
		settings["rounding"] = "round"
		settings["mirror"] = "x"
		settings["thickness"] = "osc"
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirror"]!
		theDrawView.modeGeometric = settings["grid"]!
		theDrawView.modeThick = settings["thickness"]!
		theDrawView.modeRounded = settings["rounding"]!
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
		
		autoHideOptions()
		
		clickSound = createClickSound()
		optionSound = createOptionSound()
	}
	
	// MARK: Sounds -
	
	func createClickSound() -> SystemSoundID {
		var soundID: SystemSoundID = 0
		let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "click.1", "wav", nil)
		AudioServicesCreateSystemSoundID(soundURL, &soundID)
		return soundID
	}
	func createOptionSound() -> SystemSoundID {
		var soundID: SystemSoundID = 0
		let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "click.2", "wav", nil)
		AudioServicesCreateSystemSoundID(soundURL, &soundID)
		return soundID
	}
	
	// MARK: Menu -
	
	func updateSelectionMenu(iconTag:Int, iconString:String)
	{
		println("$ SELCT | Updating view #\(iconTag) -> \(iconString)")
		for iconView in selectionView.subviews {
			if iconView.tag != iconTag { continue }
			var iconView = iconView as! UIImageView
			iconView.image = UIImage(named: iconString)
		}
	}
	
	func createSelectionMenu()
	{
		selectionView = UIView(frame: CGRectMake(0, screenHeight-tileSize, tileSize*7, tileSize))
		
		var col:CGFloat = 0
		for categories in menus {
			
			if categories.0 == "rounding" { col = 4 }
			
			if categories.0 != "system" && categories.0 != "filter" {
				
				// Icon
				let iconView = UIImageView(frame: CGRectMake(tileSize*col, 0, tileSize, tileSize))
				let iconString = String(format: "%@.%@", categories.0, settings[categories.0]!)
				
				iconView.image = UIImage(named: iconString)
				iconView.contentMode = UIViewContentMode.ScaleAspectFit
				iconView.tag = 590 + Int(col)
				selectionView.addSubview(iconView)
				
				// Button
				let toggleButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
				toggleButton.frame = CGRectMake(tileSize*col, 0, tileSize, tileSize)
				toggleButton.addTarget(self, action: Selector("toggleOption:"), forControlEvents: UIControlEvents.TouchUpInside)
				selectionView.addSubview(toggleButton)
				
			}

			col++
		}
		
		self.view.addSubview(selectionView)
		
	}
	
	func toggleOption(sender:UIButton!)
	{
		for targetView in self.view.subviews {
			var targetView = targetView as! UIView
			if targetView.tag == 66 {
				UIView.animateWithDuration(0.2, animations: { targetView.frame = CGRectMake(targetView.frame.origin.x, self.screenHeight-self.tileSize, self.tileSize, 0 ) }, completion: { finished in })
				targetView.clipsToBounds = true
			}
			if targetView.tag == 66 && targetView.frame.origin.x == sender.frame.origin.x {
				UIView.animateWithDuration(0.2, animations: { targetView.frame = CGRectMake(targetView.frame.origin.x, self.screenHeight-(self.tileSize * CGFloat((targetView.subviews.count/2)+1)), self.tileSize, self.tileSize * CGFloat(targetView.subviews.count/2) ) }, completion: { finished in })
			}
		}
		AudioServicesPlaySystemSound(optionSound!)
	}
	
	func hideOptions()
	{
		for targetView in self.view.subviews {
			var targetView = targetView as! UIView
			if targetView.tag == 66 {
				UIView.animateWithDuration(0.2, animations: { targetView.frame = CGRectMake(targetView.frame.origin.x, self.screenHeight-self.tileSize, self.tileSize, 0 ) }, completion: { finished in })
				targetView.clipsToBounds = true
			}
		}
	}
	
	func autoHideOptions()
	{
		for targetView in self.view.subviews {
			var targetView = targetView as! UIView
			if targetView.tag == 66 {
				targetView.frame = CGRectMake(targetView.frame.origin.x, self.screenHeight-self.tileSize, self.tileSize, 0 )
				targetView.clipsToBounds = true
			}
		}
	}
	
	func loadMenu()
	{
		var col:CGFloat = 0
		for categories in menus {
			let menuHeight:CGFloat = CGFloat(categories.1.count + 1) * tileSize
			
			if categories.0 == "rounding" { col = 4 }
			if categories.0 == "system" { col = 7 }
			if categories.0 == "filter" { col = 5 }
			
			let menuView = UIView(frame: CGRectMake(tileSize*col, screenHeight-menuHeight, tileSize, menuHeight))
			menuView.tag = 66
			var row:CGFloat = 0
			for option in categories.1 {
				
				// Icon
				let iconView = UIImageView(frame: CGRectMake(0, tileSize*row, tileSize, tileSize))
				let iconString = String(format: "%@.%@", categories.0, option)
				
				iconView.image = UIImage(named: iconString)
				iconView.contentMode = UIViewContentMode.ScaleAspectFit
				menuView.addSubview(iconView)
				
				// Button
				let selectorString = String(format:"option%@:", categories.0.capitalizedString)
				let optionView   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
				optionView.frame = CGRectMake(0, tileSize*row, tileSize, tileSize)
				optionView.setTitle(option.0, forState: UIControlState.Normal)
				optionView.addTarget(self, action: Selector(selectorString), forControlEvents: UIControlEvents.TouchUpInside)
				optionView.titleLabel?.font = UIFont.boldSystemFontOfSize(0)
				optionView.tag = 100 + Int(1 * col)
				menuView.addSubview(optionView)
				
				row++
			}
			self.view.addSubview(menuView)
			col++
		}
		
		createSelectionMenu()
		
		// Clear
		
		let iconView = UIImageView(frame: CGRectMake(screenWidth-tileSize, screenHeight-tileSize, tileSize, tileSize))
		iconView.image = UIImage(named: "system.clear")
		iconView.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(iconView)
		
		let clearButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
		clearButton.frame = CGRectMake(screenWidth-tileSize, screenHeight-tileSize, tileSize, tileSize)
		clearButton.addTarget(self, action: Selector("optionSystem:"), forControlEvents: UIControlEvents.TouchUpInside)
		clearButton.setTitle("clear", forState: UIControlState.Normal)
		clearButton.titleLabel?.font = UIFont.boldSystemFontOfSize(0)
		self.view.addSubview(clearButton)
		
		// Clear
		
		let saveIconView = UIImageView(frame: CGRectMake(screenWidth-(tileSize*2), screenHeight-tileSize, tileSize, tileSize))
		saveIconView.image = UIImage(named: "system.save")
		saveIconView.contentMode = UIViewContentMode.ScaleAspectFit
		self.view.addSubview(saveIconView)
		
		let saveButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
		saveButton.frame = CGRectMake(screenWidth-(tileSize*2), screenHeight-tileSize, tileSize, tileSize)
		saveButton.addTarget(self, action: Selector("optionSystem:"), forControlEvents: UIControlEvents.TouchUpInside)
		saveButton.setTitle("save", forState: UIControlState.Normal)
		saveButton.titleLabel?.font = UIFont.boldSystemFontOfSize(0)
		self.view.addSubview(saveButton)
		
	}
	
	func updateMenuBackground()
	{
		for targetView in self.view.subviews {
			var targetView = targetView as! UIView
			if targetView.tag == 66 {
				targetView.backgroundColor = UIColor(CGColor: currentColour)
			}
		}
	}
	
	func optionThickness(sender:UIButton!)
	{
		settings["thickness"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeThick = settings["thickness"]!
		
		updateSelectionMenu(592, iconString: String(format:"thickness.%@", sender.currentTitle!) )
		hideOptions()
		AudioServicesPlaySystemSound(clickSound!)
	}
	
	func optionSystem(sender:UIButton!)
	{
		settings["system"] = sender.currentTitle
		
		println(sender.currentTitle)
		
		if( sender.currentTitle == "clear" ){
			let colours = [UIColorFromRGB(0xff0000).CGColor,UIColorFromRGB(0xefefef).CGColor,UIColorFromRGB(0xdddddd).CGColor,UIColorFromRGB(0x999999).CGColor]
			let randomIndex = Int(arc4random_uniform(UInt32(colours.count)))
			self.outputView.backgroundColor = UIColor(CGColor: colours[randomIndex])
			currentColour = colours[randomIndex]
			var theDrawView = drawView as DrawView
			theDrawView.lines = []
			renderView.image = UIImage(named: "")
			theDrawView.setNeedsDisplay()
			updateMenuBackground()
		}
		else if sender.currentTitle == "save" {
			notification("SAVED TO YOUR PICTURES")
			UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.width, self.view.frame.height))
			outputView.layer.renderInContext(UIGraphicsGetCurrentContext())
			let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
		}
		AudioServicesPlaySystemSound(clickSound!)
		
	}
	
	func optionFilter(sender:UIButton!)
	{
	}
	
	func optionColor(sender:UIButton!)
	{
		settings["color"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
		
		updateSelectionMenu(593, iconString: String(format:"color.%@", sender.currentTitle!) )
		hideOptions()
		AudioServicesPlaySystemSound(clickSound!)
	}
	
	func optionRounding(sender:UIButton!)
	{
		settings["rounding"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeRounded = settings["rounding"]!
		
		updateSelectionMenu(594, iconString: String(format:"rounding.%@", sender.currentTitle!) )
		hideOptions()
		AudioServicesPlaySystemSound(clickSound!)
	}
	
	func optionGrid(sender:UIButton!)
	{
		settings["grid"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeGeometric = settings["grid"]!
	
		updateSelectionMenu(590, iconString: String(format:"grid.%@", sender.currentTitle!) )
		hideOptions()
		AudioServicesPlaySystemSound(clickSound!)
	}
	
	func optionMirror(sender:UIButton!)
	{
		settings["mirroir"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirroir"]!
		
		updateSelectionMenu(591, iconString: String(format:"mirror.%@", sender.currentTitle!) )
		hideOptions()
		AudioServicesPlaySystemSound(clickSound!)
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
		
		renderView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		outputView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		theDrawView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		
		notificationLabel.frame = CGRectMake(tileSize/5, screenHeight-tileSize*2, screenWidth, tileSize)
		notificationLabel.text = ""
	}
	
	func notification(newText:String)
	{
		notificationLabel.text = newText
		self.notificationLabel.alpha = 1
		UIView.animateWithDuration(2, animations: { self.notificationLabel.alpha = 0 }, completion: { finished in })
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


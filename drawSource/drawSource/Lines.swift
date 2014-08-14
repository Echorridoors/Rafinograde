//
//  Lines.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class Line {

	var start: CGPoint
	var end: CGPoint
	var color: UIColor
	var modeMirrorX: String
	var modeGeometric: String
	
	init( start _start: CGPoint, end _end: CGPoint, color _color: UIColor, modeMirrorX _modeMirrorX: String, modeGeometric _modeGeometric: String){
		start = _start
		end = _end
		color = _color
		modeMirrorX = _modeMirrorX
		modeGeometric = _modeGeometric
	}
	
}
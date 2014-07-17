//
//  Defines.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Foundation

enum ClockStyle: Int {
	case Light, Dark
	
	init(integer: Int) {
		if integer == 1 {
			self = .Dark
			return
		}
		
		self = .Light
	}
}

let ConfigurationDidChangeNotificationName = "SAMClockConfigurationDidChangeNotification"
let BundleIdentifier = "com.samsoffes.clock"
let ClockStyleDefaultsKey = "SAMClockStyle"
let BackgroundStyleDefaultsKey = "SAMClockBackgroundStyleDefaults"
let TickMarksDefaultsKey = "SAMClockTickMarks"
let NumbersDefaultsKey = "SAMClockNumbers"
let DateDefaultsKey = "SAMClockDate"
let LogoDefaultsKey = "SAMClockLogo"

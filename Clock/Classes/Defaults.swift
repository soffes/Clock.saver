//
//  Defaults.swift
//  Clock
//
//  Created by Sam Soffes on 7/17/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

let BundleIdentifier = "com.samsoffes.clock"
let ClockStyleDefaultsKey = "SAMClockStyle"
let BackgroundStyleDefaultsKey = "SAMClockBackgroundStyleDefaults"
let TickMarksDefaultsKey = "SAMClockTickMarks"
let NumbersDefaultsKey = "SAMClockNumbers"
let DateDefaultsKey = "SAMClockDate"
let LogoDefaultsKey = "SAMClockLogo"

class Defaults: NSObject {
	
	// MARK: - Properties
	
	let screenSaverDefaults: ScreenSaverDefaults = ScreenSaverDefaults.defaultsForModuleWithName(BundleIdentifier) as! ScreenSaverDefaults
	
	var faceStyleIndex: Int {
		didSet {
			setInteger(faceStyleIndex, forKey: ClockStyleDefaultsKey)
		}
	}

	var backgroundStyleIndex: Int {
		didSet {
			setInteger(backgroundStyleIndex, forKey: BackgroundStyleDefaultsKey)
		}
	}
	
	var drawsTicks: Bool {
		didSet {
			setBool(drawsTicks, forKey: TickMarksDefaultsKey)
		}
	}
	
	var drawsNumbers: Bool {
		didSet {
			setBool(drawsNumbers, forKey: NumbersDefaultsKey)
		}
	}
	
	var drawsDate: Bool {
		didSet {
			setBool(drawsDate, forKey: DateDefaultsKey)
		}
	}
	
	var drawsLogo: Bool {
		didSet {
			setBool(drawsLogo, forKey: LogoDefaultsKey)
		}
	}
	
	
	// MARK: - Initializers

	override init() {
		faceStyleIndex = screenSaverDefaults.integerForKey(ClockStyleDefaultsKey)
		backgroundStyleIndex = screenSaverDefaults.integerForKey(BackgroundStyleDefaultsKey)
		drawsTicks = screenSaverDefaults.boolForKey(TickMarksDefaultsKey)
		drawsNumbers = screenSaverDefaults.boolForKey(NumbersDefaultsKey)
		drawsDate = screenSaverDefaults.boolForKey(DateDefaultsKey)
		drawsLogo = screenSaverDefaults.boolForKey(LogoDefaultsKey)
	}
	
	
	// MARK: - Private
	
	func setInteger(integer: Int, forKey key: String) {
		screenSaverDefaults.setInteger(integer, forKey: key)
		save()
	}
	
	func setBool(bool: Bool, forKey key: String) {
		screenSaverDefaults.setBool(bool, forKey: key)
		save()
	}
	
	func save() {
		screenSaverDefaults.synchronize()
		NSNotificationCenter.defaultCenter().postNotificationName(ConfigurationDidChangeNotificationName, object: nil)
	}
}

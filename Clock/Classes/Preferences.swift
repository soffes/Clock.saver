//
//  Preferences.swift
//  Clock
//
//  Created by Sam Soffes on 7/17/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

let BundleIdentifier = "com.samsoffes.clock"
let ModelDefaultsKey = "SAMModel"
let StyleDefaultsKey = "SAMStyle"
let LogoDefaultsKey = "SAMClockLogo"
let PreferencesDidChangeNotificationName = "SAMClockConfigurationDidChangeNotification"

class Preferences: NSObject {
	
	// MARK: - Properties
	
	private let defaults: ScreenSaverDefaults = ScreenSaverDefaults.defaultsForModuleWithName(BundleIdentifier) as! ScreenSaverDefaults
	
	var model: String {
		get {
			return defaults.objectForKey(ModelDefaultsKey) as! String
		}

		set {
			defaults.setObject(newValue, forKey: ModelDefaultsKey)
			save()
		}
	}

	var style: String {
		get {
			return defaults.objectForKey(StyleDefaultsKey) as! String
		}

		set {
			defaults.setObject(newValue, forKey: StyleDefaultsKey)
			save()
		}
	}

	var drawsLogo: Bool {
		get {
			return defaults.boolForKey(LogoDefaultsKey)
		}

		set {
			defaults.setBool(newValue, forKey: LogoDefaultsKey)
			save()
		}
	}
	
	
	// MARK: - Initializers

	override init() {
		defaults.registerDefaults([
			ModelDefaultsKey: "BN0032",
			StyleDefaultsKey: "BKBKG",
			LogoDefaultsKey: false
		])
	}
	
	
	// MARK: - Private
	
	private func save() {
		defaults.synchronize()
		NSNotificationCenter.defaultCenter().postNotificationName(PreferencesDidChangeNotificationName, object: nil)
	}
}

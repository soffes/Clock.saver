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
let PreferencesDidChangeNotificationName = "SAMClockPreferencesDidChangeNotification"
let ModelDidChangeNotificationName = "SAMClockModelDidChangeNotification"

let models: [String: ClockView.Type] = [
	"BN0032": BN0032.self,
	"BN0111": BN0111.self
]

let defaultModel = BN0032.self

class Preferences: NSObject {
	
	// MARK: - Properties
	
	private let defaults: NSUserDefaults = ScreenSaverDefaults.defaultsForModuleWithName(BundleIdentifier) as! ScreenSaverDefaults

	var model: ClockView.Type {
		return models[modelName] ?? defaultModel
	}
	
	var modelName: String {
		get {
			return defaults.stringForKey(ModelDefaultsKey) ?? "BN0032"
		}

		set {
			defaults.setObject(newValue, forKey: ModelDefaultsKey)
			save()

			NSNotificationCenter.defaultCenter().postNotificationName(ModelDidChangeNotificationName, object: model)
		}
	}

	var style: ClockStyle {
		let styles = model.styles
		let index = find(styles.map({ $0.rawValue }), styleName) ?? styles.startIndex
		return styles[index]
	}

	var styleName: String {
		get {
			return defaults.stringForKey(StyleDefaultsKey)!
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
		NSNotificationCenter.defaultCenter().postNotificationName(PreferencesDidChangeNotificationName, object: self)
	}
}

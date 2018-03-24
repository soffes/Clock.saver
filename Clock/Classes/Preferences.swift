import AppKit
import ScreenSaver

extension Notification.Name {
	static let PreferencesDidChange = Notification.Name(rawValue: "SAMClockPreferencesDidChangeNotification")
	static let ModelDidChange = Notification.Name(rawValue: "SAMClockModelDidChangeNotification")
}

let models: [String: ClockView.Type] = [
	"BN0021": BN0021.self,
	"BN0032": BN0032.self,
	"BN0111": BN0111.self
]

let defaultModel = BN0032.self

final class Preferences: NSObject {

	// MARK: - Types

	private enum DefaultsKey: String {
		case model = "SAMModel"
		case style = "SAMStyle"
		case logo = "SAMClockLogo"

		var key: String {
			return rawValue
		}
	}
	
	// MARK: - Properties
	
	private let defaults: UserDefaults = ScreenSaverDefaults(forModuleWithName: Bundle(for: Preferences.self).bundleIdentifier!)!

	var model: ClockView.Type {
		return models[modelName] ?? defaultModel
	}
	
	@objc var modelName: String {
		get {
			return defaults.string(forKey: DefaultsKey.model.key) ?? "BN0032"
		}

		set {
			defaults.set(newValue, forKey: DefaultsKey.model.key)
			save()

			NotificationCenter.default.post(name: .ModelDidChange, object: model)
		}
	}

	var style: ClockStyle {
		let styles = model.styles
		let index = styles.map { $0.rawValue }.index(of: styleName) ?? styles.startIndex
		return styles[index]
	}

	@objc var styleName: String {
		get {
			return defaults.string(forKey: DefaultsKey.style.key)!
		}

		set {
			defaults.set(newValue, forKey: DefaultsKey.style.key)
			save()
		}
	}

	@objc var drawsLogo: Bool {
		get {
			return defaults.bool(forKey: DefaultsKey.logo.key)
		}

		set {
			defaults.set(newValue, forKey: DefaultsKey.logo.key)
			save()
		}
	}
	
	// MARK: - Initializers

	override init() {
		defaults.register(defaults: [
			DefaultsKey.model.key: "BN0032",
			DefaultsKey.style.key: "BKBKG",
			DefaultsKey.logo.key: false
		])
	}
	
	// MARK: - Private
	
	private func save() {
		defaults.synchronize()
		NotificationCenter.default.post(name: .PreferencesDidChange, object: self)
	}
}

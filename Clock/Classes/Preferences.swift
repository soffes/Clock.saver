import AppKit
import ScreenSaver

extension Notification.Name {
	static let PreferencesDidChange = Notification.Name(rawValue: "SAMClockPreferencesDidChangeNotification")
	static let ModelDidChange = Notification.Name(rawValue: "SAMClockModelDidChangeNotification")
}

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

	let models = [
		BN0021.self,
		BN0032.self,
//		BN0035.self,
		BN0111.self
	]

	private let defaultModel = BN0032.self

	var model: ClockView.Type {
		return models.first { $0.modelName == modelName } ?? defaultModel
	}
	
	@objc var modelName: String {
		get {
			return defaults.string(forKey: DefaultsKey.model.key) ?? defaultModel.modelName
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
			DefaultsKey.model.key: defaultModel.modelName,
			DefaultsKey.style.key: defaultModel.Style.default.rawValue,
			DefaultsKey.logo.key: false
		])
	}
	
	// MARK: - Private
	
	private func save() {
		defaults.synchronize()
		NotificationCenter.default.post(name: .PreferencesDidChange, object: self)
	}
}

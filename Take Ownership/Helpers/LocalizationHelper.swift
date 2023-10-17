import Foundation

struct LocalizationHelper {
    private static var englishBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj") ?? "")

    fileprivate static func localizedString(forKey key: String) -> String {
        return englishBundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
    }
}

extension String {
    static func localized(_ key: String) -> String {
        return LocalizationHelper.localizedString(forKey: key)
    }
}

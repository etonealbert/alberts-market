//
//  LanguageLocal.swift

import Foundation

private var bundle: Bundle? = nil

func CURR_LANG() {
    UserDefaults.standard.string(forKey: LANGUAGE)
}

class LanguageLocal {
    class func sharedInstance() -> LanguageLocal {
        
        var _SharedInstance: LanguageLocal? = nil
        do {
            bundle = Bundle.main
            _SharedInstance = LanguageLocal()
        }
        return _SharedInstance!
    }
    
    class func setLanguage(newLanguage: String) -> Bool {
        var curruntLan = UserDefaults.standard.string(forKey: LANGUAGE)
        curruntLan = newLanguage
        loadDataForLanguage(newLanguage: newLanguage)
        return true
    }
    
    class func loadDataForLanguage(newLanguage: String) -> Bool {
        let path = Bundle.main.path(forResource: newLanguage, ofType: "lproj")
        if bundle != Bundle(path: path ?? "") {
            
            if FileManager.default.fileExists(atPath: path ?? "") {
                var curruntLan = UserDefaults.standard.string(forKey: LANGUAGE)
                curruntLan = newLanguage.copy() as? String
                bundle = Bundle(path: path ?? "")
                return true
            } else {
                bundle = Bundle.main
            }
        }
        return false
    }
    
    class func myLocalizedString(key: String) -> String {
        var s = NSLocalizedString(key, tableName: STR_LOCALIZED_FILE_NAME, bundle: Bundle.main, value: "", comment: "")
        
        let curruntLan = UserDefaults.standard.string(forKey: LANGUAGE)
        if (curruntLan == "") {
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            let languageBundle = Bundle(path: path ?? "")
            s = languageBundle?.localizedString(forKey: key, value: "", table: STR_LOCALIZED_FILE_NAME) ?? ""
            return s
        }
        else {
            let path = Bundle.main.path(forResource: curruntLan, ofType: "lproj")
            let languageBundle = Bundle(path: path ?? "")
            s = languageBundle?.localizedString(forKey: key, value: "", table: STR_LOCALIZED_FILE_NAME) ?? ""
            return s
        }
//        return s
    }
}


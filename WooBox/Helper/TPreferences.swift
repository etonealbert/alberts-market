//
//  TPreferences.swift

import Foundation

let WALKTHROUGH = "walk_through"
let ISLISTING = "listing"
let TOKEN = "token"
let USER_EMAIL = "user_email"
let USER_DISPLAY_NAME = "user_display_name"
let USER_NICENAME = "user_nicename"
let USER_ID = "user_id"
let USER_FIRST_NAME = "first_name"
let USER_LAST_NAME = "last_name"
let USER_ROLE = ""
let USERNAME = "username"
let PASSWORD = "password"
let IS_LOGGED_IN = "logged_in"
let PRO_ID = "pro_id"
let LOGIN_TYPE = "login_type"
let DASHBOARD_STYLE = "dashboard_style"
let USER_PROFILE_IMAGE = "profile_image"

let PRODUCT_NAME = "name"
let SALES_PRICE = "sale_price"
let REGULAR_PRICE = "regular_price"
let CART_ITEM_COUNT = "cart_item_count"
let RECENT_SEARCH = "recent_search"
let ADDRESS = "address"
let SELECTED_ADDRESS = "selected_address"
let NEXT_TIME_BUY = "next_time_buy"
let CART = "cart"
let PRICE = "price"
let FULL = "full"
let STOCK_QUANTITY = "stock_quantity"

let NEWEST_PRODUCT = "Newest Products"
let TOP_SELLING = "Top Selling"
let FEATURED_PRODUCTS = "Featured Products"
let NEW_ARRIVAL = "New Arrival"
let DEAL_PRODUCT = "Deal Product"
let SUGGESTED_PRODUCT = "Suggested Product"
let OFFER = "Offer"
let YOU_MAY_LIKE = "You May Like"

let CONTACT = "contact"
let FACEBOOK = "facebook"
let INSTAGRAM = "instagram"
let TWITTER = "twitter"
let WHATSAPP = "whatsapp"
let PRIVACY_POLICY = "privacy_policy"
let TERM_CONDITION = "term_condition"
let COPYRIGHT_TEXT = "copyright_text"

let SHARE_KEY = "share_key"
let WISHLIST_COUNT = "Wishlist_Count"
let REWARD_COUNT = "Reward_Count"
let MY_ORDER_COUNT = "My_Order_Count"
let WISHLIST_ITEM = "wishlist_item"

let NO_OF_PAGES = "num_pages"
let CAT_ID = "cat_ID"

let CURRENCY_SYMBOL = "currency_symbol"
let CM = "cm"

let FILTER_ATTRIBUTES = "filter_attributes"
let FILTER_ATTRIBUTES_INDEXPATH = "filter_attributes_indexpath"

let ERROR_MSG = "Please try again later"

let LANGUAGE = "language"
let LANGUAGE_NAME = "language_name"

let THEME_COLOR = "theme_color"
let DARK_MODE = "dark_mode"

let PUSH_NOTIFICATION = "push_notification"

class TPreferences {
    
    class func getURLString(_ urlString: String?) -> String? {
        print("\(BASEURL + ("user" + (urlString ?? "")))")
        return BASEURL + ("user" + (urlString ?? ""))
    }
//
    class func getCommonURL(_ urlString: String?) -> String? {
        print("\(BASEURL + (urlString ?? ""))")
        return BASEURL + (urlString ?? "")
    }
//
//    class func getPrivacyURL(_ urlString: String?) -> String? {
//        print("\(PolicyUrl + (urlString ?? ""))")
//        return PolicyUrl + (urlString ?? "")
//    }
    
    class func readString(_ key: String?) -> String? {
        var value = UserDefaults.standard.string(forKey: key ?? "")
        if value == nil {
            value = ""
        }
        return value
    }
    
    class func writeString(_ key: String?, value: String?) {
        if value == nil {
            UserDefaults.standard.setValue("", forKey: key!)
            return
        }
        UserDefaults.standard.setValue(value, forKey: key!)
    }
    
    class func writeObject(_ key: String?, value: Any?) {
        if value == nil {
            UserDefaults.standard.set("", forKey: key ?? "")
            return
        }
        let myData = NSKeyedArchiver.archivedData(withRootObject: value!)
        UserDefaults.standard.set(myData, forKey: key ?? "")
    }
    
    class func readObject(_ key: String?) -> Any? {
        let recovedUserJsonData = UserDefaults.standard.object(forKey: key ?? "")
        if recovedUserJsonData == nil {
            return ""
        }
        else {
            var value = NSKeyedUnarchiver.unarchiveObject(with: recovedUserJsonData as! Data)
            if value == nil {
                value = ""
            }
            return value
        }
    }
    
    class func removePreference(_ key: String?) {
        UserDefaults.standard.removeObject(forKey: key ?? "")
    }
    
    class func readBoolean(_ key: String?) -> Bool {
        let value: Bool = UserDefaults.standard.bool(forKey: key ?? "")
        return value
    }
    
    class func writeBoolean(_ key: String?, value: Bool) {
        UserDefaults.standard.set(value, forKey: key ?? "")
    }
    
}

//
//  TConfig.swift

import Foundation
import UIKit

// Font.
let PRIMARY_FONT = "Montserrat-Bold"
let PRIMARY_FONT_BOLD = "Montserrat-Regular"

// Screen Size.
let SCREEN_SIZE = UIScreen.main.bounds.size

// Font Size.
let SIZE_XXLARGE:Float = 30
let SIZE_XLARGE:Float = 24
let SIZE_LARGE:Float = 20
let SIZE_NORMAL:Float = 18
let SIZE_MEDIUM:Float = 16
let SIZE_MSMALL:Float = 14
let SIZE_SMALL:Float = 12
let SIZE_TINY:Float = 10

// Base URL
let BASEURL = "https://iqonic.design/wp-themes/woobox_api/wp-json/"
let CONNECT_STR = "woobox-api/api/v1/"

// Secret Keys.
let CONSUMER_KEY = "ZH0mxMZ63h22"
let OAUTH_TOKEN = "gN3kZdeh2Yyh6Ntdvip4Mokf"
let CONSUMER_SECRET = "z5RTcjT0NseqCYbfTQXaSwSNC054HLp0SGGhqbMKlpWWtOTH"
let TOKEN_SECRET = "EhhwL3Ta6GSevnG6aKd4pCdp2X3rosIivzubXmZxSLkByi31"

let AUTH_KEY = "oauth_consumer_key=\(CONSUMER_KEY)&oauth_token=\(OAUTH_TOKEN)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1564471232&oauth_nonce=AHHCPD&oauth_version=1.0&oauth_signature=ciD1i8109Sf01wZR/nVvwT7/qDw"

let IPAD = UI_USER_INTERFACE_IDIOM() == .pad

// ADMob Ids.
let ADMOB_ID = "ca-app-pub-4937593957421986~3239804062"
let BANNER_ID = "ca-app-pub-4937593957421986/6921418147"
let INTERSTITIAL_ID =  "ca-app-pub-4937593957421986/8959234608"

//ONESIGNAL_APP_ID
let ONESIGNAL_APP_ID = "2b3eace3-4c4f-4a11-834a-b32d620cc374"

let STR_LOCALIZED_FILE_NAME = "WooBoxLocalization"

// API End points.
let GET_PRODUCTS = "get_products"
let ADD_PRODUCT = "add_product"
let SHIPMENT_TRACKINGS = "shipment-trackings"
let ORDER_BY_CUSTOMER = "?customer="

let LOGIN = "jwt-auth/v1/token"
let CUSTOMER = "wc/v3/customers/"
let PRODUCTS = "wc/v3/products"
let PRODUCTS_CATEGORIES = "wc/v3/products/categories"
let GET_PRODUCT_REVIEWS = "wc/v1/products"
let PRODUCT_REVIEWS = "wc/v3/products/reviews"
let ORDER = "wc/v3/orders"
let COUPONS = "wc/v3/coupons"
let GET_CART_ITEM = "cocart/v1/get-cart"
let ADD_CART_ITEM = "cocart/v1/add-item"
let UPDATE_DELETE_CART_ITEM = "cocart/v1/item"
let COUNT_CART_ITEMS = "cocart/v1/count-items"
let GET_BY_USER_ID = "wc/v3/wishlist/get_by_user/1"
let WISHLIST = "wc/v3/wishlist"
let REMOVE_WISHLIST = "wc/v3/wishlist/remove_product"
let SHIPMENT = "wc/v1/orders"
let SEARCH = "wc/v1/products?search="
let PAYMENT = "wc/v2/process_payment"
let LOSTPASSWORD = "wp/v2/users/lostpassword"
let PRODUCT_ORDER = "wc/v3/products?order=desc"
let FILTER = "wc/v3/products/attributes"
let CHANGE_PASSWORD = "wp/v2/users"
let TOTAL_AMOUNT = "cocart/v1/totals"
let REMOVE_CART_DATA = "cocart/v1/item"

let NEW_ADD_WISHLIST = CONNECT_STR + "wishlist/add-wishlist/"
let NEW_GET_WISHLIST = CONNECT_STR + "wishlist/get-wishlist/"
let NEW_ADD_TO_CART = CONNECT_STR + "cart/add-cart/"
let NEW_GET_CART = CONNECT_STR + "cart/get-cart/"
let NEW_DELETE_CART = CONNECT_STR + "cart/delete-cart/"
let NEW_FILTER = CONNECT_STR + "woocommerce/get-product"
let NEW_PRODUCT_ATTRIBUTE = CONNECT_STR + "woocommerce/get-product-attribute/"
let NEW_SLIDER = CONNECT_STR + "slider/get-slider/"
let NEW_CATEGORIES = CONNECT_STR + "woocommerce/get-category"
let NEW_UPDATE_CART = CONNECT_STR + "cart/update-cart/"
let NEW_DELETE_WISHLIST = CONNECT_STR + "wishlist/delete-wishlist/"
let NEW_CLEAR_CART = CONNECT_STR + "cart/clear-cart/"
let NEW_PRODUCTS = CONNECT_STR + "woocommerce/get-product"
let NEW_SINGLE_PRODUCT = CONNECT_STR + "woocommerce/get-product-details"
let NEW_FEATURED_PRODUCT = CONNECT_STR + "woocommerce/get-featured-product"
let NEW_SEARCH = CONNECT_STR + "woocommerce/get-search-product"
let NEW_GET_OFFER = CONNECT_STR + "woocommerce/get-offer-product"
let NEW_SUB_CATEGORIES = CONNECT_STR + "woocommerce/get-sub-category"
let NEW_GET_CHECKOUT_URL = CONNECT_STR + "woocommerce/get-checkout-url"
let NEW_DASHBOARD_URL = CONNECT_STR + "woocommerce/get-dashboard"
let NEW_BLOG = CONNECT_STR + "blog/get-blog"
let NEW_SOCIAL_LOGIN = CONNECT_STR + "customer/social_login"
let NEW_ADD_ADDRESS = CONNECT_STR + "customer/add-address"
let NEW_GET_ADDRESS = CONNECT_STR + "customer/get-address"
let NEW_DELETE_ADDRESS = CONNECT_STR + "customer/delete-address"
let NEW_SAVE_PROFILE_IMAGE = CONNECT_STR + "customer/save-profile-image"

//Contact us support mail id
let Contact_us_Email = "Enter Your support mail id"
let Contact_Phone_No = "+919999999999"//+91 Yourcountrycode Your number
let Your_responce_text = "Response Within 24 business hours."

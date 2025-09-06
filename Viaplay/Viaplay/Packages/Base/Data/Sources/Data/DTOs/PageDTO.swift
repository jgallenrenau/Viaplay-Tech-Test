import Foundation

// MARK: - Page DTOs for API Response Mapping

struct PageDTO: Codable {
    let type: String
    let pageType: String
    let title: String
    let description: String?
    let styles: [String]
    let tracking: TrackingDTO?
    let links: LinksDTO
    let embedded: EmbeddedDTO?
    let responseCode: ResponseCodeDTO?
    
    enum CodingKeys: String, CodingKey {
        case type, pageType, title, description, styles, tracking
        case links = "_links"
        case embedded = "_embedded"
        case responseCode
    }
}

struct TrackingDTO: Codable {
    let viewDataType: String?
}

struct LinksDTO: Codable {
    let curies: [CuriesDTO]?
    let selfLink: SelfLinkDTO?
    let viaplayEditorial: ViaplayLinkDTO?
    let viaplayByGuid: ViaplayLinkDTO?
    let viaplayRoot: ViaplayLinkDTO?
    let viaplaySearch: ViaplayLinkDTO?
    let viaplayTechnotifier: ViaplayLinkDTO?
    let viaplaySections: [ViaplaySectionDTO]?
    let viaplayGeolocation: ViaplayLinkDTO?
    let viaplayTranslations: ViaplayLinkDTO?
    let viaplayLocalizationLanguages: ViaplayLinkDTO?
    let viaplayEncryptionUserId: ViaplayLinkDTO?
    let viaplayContentFailover: ViaplayLinkDTO?
    let viaplayUniversalLinkResolver: ViaplayLinkDTO?
    let viaplayTrackingSession: ViaplayLinkDTO?
    let viaplayUtcTime: ViaplayLinkDTO?
    let viaplayBoid: ViaplayLinkDTO?
    let viaplayTcf: ViaplayLinkDTO?
    let viaplayLocalizationCountry: ViaplayLinkDTO?
    let viaplayAppconf: ViaplayLinkDTO?
    let viaplaySetParentalControl: ViaplayLinkDTO?
    let viaplayUserPwdUpdate: ViaplayLinkDTO?
    let viaplayUserPwdLoginRequest: ViaplayLinkDTO?
    let viaplayPasswordToken: ViaplayLinkDTO?
    let termsAndConditions: ViaplayLinkDTO?
    let privacyPolicy: ViaplayLinkDTO?
    let cookiePolicy: ViaplayLinkDTO?
    let viaplayGetUser: ViaplayLinkDTO?
    let viaplayApplePurchases: ViaplayApplePurchasesDTO?
    let viaplayTokenLogin: ViaplayLinkDTO?
    let viaplayTokenRefresh: ViaplayLinkDTO?
    let viaplayLogin: ViaplayLinkDTO?
    let viaplayTracking: ViaplayLinkDTO?
    let viaplayPrimaryNavigation: [ViaplaySectionDTO]?
    let viaplaySecondaryNavigation: [ViaplaySectionDTO]?
    
    enum CodingKeys: String, CodingKey {
        case curies
        case selfLink = "self"
        case viaplayEditorial = "viaplay:editorial"
        case viaplayByGuid = "viaplay:byGuid"
        case viaplayRoot = "viaplay:root"
        case viaplaySearch = "viaplay:search"
        case viaplayTechnotifier = "viaplay:technotifier"
        case viaplaySections = "viaplay:sections"
        case viaplayGeolocation = "viaplay:geolocation"
        case viaplayTranslations = "viaplay:translations"
        case viaplayLocalizationLanguages = "viaplay:localizationLanguages"
        case viaplayEncryptionUserId = "viaplay:encryptionUserId"
        case viaplayContentFailover = "viaplay:contentFailover"
        case viaplayUniversalLinkResolver = "viaplay:universalLinkResolver"
        case viaplayTrackingSession = "viaplay:trackingSession"
        case viaplayUtcTime = "viaplay:utc-time"
        case viaplayBoid = "viaplay:boid"
        case viaplayTcf = "viaplay:tcf"
        case viaplayLocalizationCountry = "viaplay:localizationCountry"
        case viaplayAppconf = "viaplay:appconf"
        case viaplaySetParentalControl = "viaplay:setParentalControl"
        case viaplayUserPwdUpdate = "viaplay:userPwdUpdate"
        case viaplayUserPwdLoginRequest = "viaplay:userPwdLoginRequest"
        case viaplayPasswordToken = "viaplay:passwordToken"
        case termsAndConditions
        case privacyPolicy
        case cookiePolicy
        case viaplayGetUser = "viaplay:getUser"
        case viaplayApplePurchases = "viaplay:applePurchases"
        case viaplayTokenLogin = "viaplay:tokenLogin"
        case viaplayTokenRefresh = "viaplay:tokenRefresh"
        case viaplayLogin = "viaplay:login"
        case viaplayTracking = "viaplay:tracking"
        case viaplayPrimaryNavigation = "viaplay:primaryNavigation"
        case viaplaySecondaryNavigation = "viaplay:secondaryNavigation"
    }
}

struct CuriesDTO: Codable {
    let name: String
    let href: String
    let templated: Bool?
}

struct SelfLinkDTO: Codable {
    let href: String
}

struct ViaplayLinkDTO: Codable {
    let id: String?
    let title: String?
    let href: String
    let method: String?
    let templated: Bool?
    let deprecated: String?
}

struct ViaplaySectionDTO: Codable {
    let id: String
    let title: String
    let href: String
    let type: String?
    let sectionSort: Int?
    let name: String?
    let templated: Bool?
}

struct ViaplayApplePurchasesDTO: Codable {
    let createAndLogin: ViaplayLinkDTO?
    let allowedToRegister: ViaplayLinkDTO?
    let subscriptionProducts: ViaplayLinkDTO?
    let templatedSubscriptionProducts: ViaplayLinkDTO?
    let userCommercialInfo: ViaplayLinkDTO?
    let inAppPurchases: ViaplayLinkDTO?
    let oneStepOrder: ViaplayLinkDTO?
    let activeContracts: ViaplayLinkDTO?
    let receiptUserIdEnquiry: ViaplayLinkDTO?
    let termsAndConditions: ViaplayLinkDTO?
    let privacyPolicy: ViaplayLinkDTO?
    let cookiePolicy: ViaplayLinkDTO?
    let consumableProducts: ViaplayLinkDTO?
    let programEntitlements: ViaplayLinkDTO?
}

struct EmbeddedDTO: Codable {
    let viaplayBlocks: [ViaplayBlockDTO]?
    
    enum CodingKeys: String, CodingKey {
        case viaplayBlocks = "viaplay:blocks"
    }
}

struct ViaplayBlockDTO: Codable {
    // Add block properties as needed
}

struct ResponseCodeDTO: Codable {
    let httpStatus: Int
    let statusCode: Int
    let code: Int
}

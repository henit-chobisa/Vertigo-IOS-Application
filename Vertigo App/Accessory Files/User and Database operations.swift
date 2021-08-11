//
//  User and Database operations.swift
//  Vertigo App
//
//  Created by Henit Work on 20/06/21.
//

import Foundation
import UIKit

struct UserDetails {
    var Email : String?
    var Name : String?
    var Number : String?
    var Weight : String?
    var height : String?
}

struct userPops {
    var Name : String
    var Email : String
    var imageUrl : String
}

struct RecievedNotification {
    let NotificationType : String?
    let byEmail : String?
    let Time : [Int]
}

struct configurations {
    var date : String?
    var time : String?
    var day : String?
    var channel : String?
}

struct Event {
    var ChallengeName : String
    var ChallengeDate : String
    var ChallengeTime : String
    var ChallengeID : String
}


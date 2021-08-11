//
//  constants.swift
//  Vertigo App
///Users/henit_work/Documents/IOS Projects/Vertigo App/Vertigo App/Accessory Files/User and Database operations.swift
//  Created by Henit Work on 20/06/21.
//kno
import Foundation


struct KUserDetails {
    var userName = "Name"
    var userEmail = "Email"
    var userWeight = "Weight"
    var userheight = "Height"
    var userPhone = "PhoneNumber"
    var image = "Image"
    var docID = "DocID"
}

struct Kinteraction {
    var interations = "Interations"
    
// for requests
    var Requests = "Requests"
    
    var SentRequests = "SentRequests"
    var requestedtoEmail = "RequestedToEmail"
    var requesterEmail = "RequesterEmail"
    var requesterName = "RequesterName"
    
// for friends
    var Connections = "Connections"
    var connectionEmail = "ConnectionEmail"
    
}

struct Knotifications {
    var notifications = "Notifications"
    var notificationTypeOne = "NotificationTypeOne"
    var notificationTypeTwo = "NotificationTypeTwo"
    var notificationType = "notificationType"
    var connectionRequest = "ConnectionRequest"
    var requester = "Requester"
    var time = "Time"
    
    var connector = "connector"
    var connectionApproved = "connectionApproved"
    var notificationTypeThree = "NotificationTypeThree"
    
    var askerEmail = "AskerEmail"
    var forChallenge = "For"
    var channel = "Channel"
    var challengeTime = "ChallengeTime"
    var challengeDate = "ChallengeDate"
}

struct KChallenge {
    var Info = "AboutChallenge"
    var challengeName = "ChallengeName"
    var ecoJog = "Ecojog"
    var id = "ID"
    var day = "Day"
    var date = "Date"
    var time = "Time"
    var Host = "Host"
    var channelsGenerated = "ChannelsGenerated"
    var channel = "Channel"
}



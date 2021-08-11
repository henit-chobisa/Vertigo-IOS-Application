//
//  RequestMechanism.swift
//  Vertigo App
//
//  Created by Henit Work on 21/06/21.
//

import Foundation
import Firebase
import Kingfisher

struct ConnectionMechanism {
    
    let kinter = Kinteraction()
    let knf = Knotifications()
    var db = Firestore.firestore()
    
    
    
    func getTime()->[Int]{
        let date = Date()
        let calendar = Calendar.current
        let currentdate = calendar.component(.day, from: date)
        let currentmonth = calendar.component(.month, from: date)
        let currentyear = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        return [currentyear,currentmonth,currentdate,hour,minutes,second]
    }
    
    func AddFriend(from targetEmail : String){
        
        
        cancelTypeOneNotification(to: targetEmail)
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.Connections).addDocument(data: [kinter.connectionEmail : targetEmail])
        
        db.collection(targetEmail).document(kinter.interations).collection(kinter.Connections).addDocument(data: [kinter.connectionEmail : (Auth.auth().currentUser?.email)!])
        
        
    }
    func sendTypeTwoNotification(to targetEmail : String){
        db.collection(targetEmail).document(knf.notifications).collection(knf.notificationTypeTwo).addDocument(data : [knf.notificationType : knf.connectionApproved,knf.connector:(Auth.auth().currentUser?.email)!,knf.time: getTime()])
    }
    
    func friendCanceller(EmailOne : String, EmailTwo : String){
        var docreference = ""
        
        db.collection(EmailOne).document(kinter.interations).collection(kinter.Connections).whereField(kinter.connectionEmail, isEqualTo: EmailTwo).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        docreference = doc.documentID
                    }
                    DispatchQueue.main.async {
                        db.collection(EmailOne).document(kinter.interations).collection(kinter.Connections).document(docreference).delete()
                        
                    }
                    
                }
            }
        }
    }
    
    func cancelApproveNotification(from targetEmail : String){
        var reference = ""
        db.collection(targetEmail).document(knf.notifications).collection(knf.notificationTypeTwo).whereField(knf.connector, isEqualTo: (Auth.auth().currentUser?.email)!).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        reference = doc.documentID
                    }
                    db.collection(targetEmail).document(knf.notifications).collection(knf.notificationTypeTwo).document(reference).delete()
                    
                }
            }
        }
        
    }
    
    func cancelFriend(which targetEmail : String){
        friendCanceller(EmailOne: (Auth.auth().currentUser?.email)! , EmailTwo: targetEmail)
        friendCanceller(EmailOne: targetEmail, EmailTwo: (Auth.auth().currentUser?.email)!)
        cancelApproveNotification(from: targetEmail)
    }
    
    
    
    
    func sendRequest(to targetEmail : String){
        db.collection(targetEmail).document(kinter.interations).collection(kinter.Requests).addDocument(data: [kinter.requesterEmail : (Auth.auth().currentUser?.email)!])
        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.SentRequests).addDocument(data: [kinter.requestedtoEmail : targetEmail])
    }
    
    func sendTypeOneNotification(to targetEmail : String){
        db.collection(targetEmail).document(knf.notifications).collection(knf.notificationTypeOne).addDocument(data: [knf.notificationType : knf.connectionRequest, knf.requester : (Auth.auth().currentUser?.email)!,knf.time: getTime()])
    }
    
    func cancelRequest(to targetEmail: String){
        var reference1 = ""
        var reference2 = ""
        db.collection(targetEmail).document(kinter.interations).collection(kinter.Requests).whereField(kinter.requesterEmail, isEqualTo: (Auth.auth().currentUser?.email)!).getDocuments { (querysnap, error) in
            if error == nil {
                for doc in querysnap!.documents{
                    reference1 = doc.documentID
                    DispatchQueue.main.async{
                        self.db.collection(targetEmail).document(self.kinter.interations).collection(self.kinter.Requests).document(reference1).delete()
                    }
                    
                }
            }
            else {
                print(error!.localizedDescription)
            }
            
        }

        
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.SentRequests).whereField(kinter.requestedtoEmail, isEqualTo: targetEmail).getDocuments { (querySnap, error) in
            if error == nil {
                for doc in querySnap!.documents{
                    reference2 = doc.documentID
                    DispatchQueue.main.async {
                        self.db.collection((Auth.auth().currentUser?.email)!).document(self.kinter.interations).collection(self.kinter.SentRequests).document(reference2).delete()
                    }
                    
                }
                cancelTypeOneNotification(to: targetEmail)
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func readyforfriend(to targetEmail : String){
        var reference1 = ""
        var reference2 = ""
        db.collection((Auth.auth().currentUser?.email)!).document(kinter.interations).collection(kinter.Requests).whereField(kinter.requesterEmail, isEqualTo: targetEmail).getDocuments { (querysnap, error) in
            if error == nil {
                for doc in querysnap!.documents{
                    reference1 = doc.documentID
                    DispatchQueue.main.async{
                        self.db.collection((Auth.auth().currentUser?.email)!).document(self.kinter.interations).collection(self.kinter.Requests).document(reference1).delete()
                    }
                    
                }
            }
            else {
                print(error!.localizedDescription)
            }
            
        }

        
        db.collection(targetEmail).document(kinter.interations).collection(kinter.SentRequests).whereField(kinter.requestedtoEmail, isEqualTo:(Auth.auth().currentUser?.email)! ).getDocuments { (querySnap, error) in
            if error == nil {
                for doc in querySnap!.documents{
                    reference2 = doc.documentID
                    DispatchQueue.main.async {
                        self.db.collection(targetEmail).document(self.kinter.interations).collection(self.kinter.SentRequests).document(reference2).delete()
                    }
                    
                }
                cancelTypeOneNotification(to: (Auth.auth().currentUser?.email)!)
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func cancelTypeOneNotification(to targetEmail : String){
        var notificationReference = ""
        
        db.collection(targetEmail).document(knf.notifications).collection(knf.notificationTypeOne).getDocuments { (query, error) in
            for doc in query!.documents{
                notificationReference = doc.documentID
                DispatchQueue.main.async {
                    self.db.collection(targetEmail).document(self.knf.notifications).collection(self.knf.notificationTypeOne).document(notificationReference).delete()
                }
                
            }
        
        }
        
    }
    
}

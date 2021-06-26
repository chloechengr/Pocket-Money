//
//  Detail.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/1/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import Foundation
import Firebase

class Detail {
    var type: String
    var amount: Double
    var date: String
    var detail: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["type": type, "amount": amount, "date": date, "detail": detail, "postingUserID": postingUserID]
    }
    
    init(type: String, amount: Double, date: String, detail: String, postingUserID: String, documentID: String) {
        self.type = type
        self.amount = amount
        self.date = date
        self.detail = detail
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(type: "", amount: 0.0, date: "", detail: "", postingUserID: currentUserID, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let type = dictionary["type"] as! String? ?? ""
        let amount = dictionary["amount"] as! Double? ?? 0.0
        let date = dictionary["date"] as! String? ?? ""
        let detail = dictionary["detail"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(type: type, amount: amount, date: date, detail: detail, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("details").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("details").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
    func deleteData(detail: Detail, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("details").document(detail.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                completed(true)
            }
        }
    }
    
}

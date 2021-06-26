//
//  Photo.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/2/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var postedBy: String
    var date: Date
    var documentUUID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["postedBy": postedBy, "date": timeIntervalDate]
    }
    
    init(image: UIImage, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        self.init(image: UIImage(), postedBy: postedBy, date: date, documentUUID: "")
    }
    
    func saveData(detail: Detail, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        // convert photo.image to a Data type so it can be saved by Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*** ERROR: couuld not convert image to data format")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString // generate a unique ID to use for the photo image's name
        // create a ref to upload storage to detail.documentID's folder (bucket), with the name we created.
        let storageRef = storage.reference().child(detail.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) {metadata, error in
            guard error == nil else {
                print("😡 ERROR during .putData storage upload for reference \(storageRef). Error: \(error!.localizedDescription)")
                return
            }
            print("😎 Upload worked! Metadata is \(metadata!)")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            // Create the dictionary representing the data we want to save
            let dataToSave = self.dictionary
            // This will either create a new doc at documentUUID or update the existing doc with that name
            let ref = db.collection("details").document(detail.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentUUID) in detail \(detail.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("*** ERROR: upload task for file \(self.documentUUID) failed, in detail \(detail.documentID), error \(error)")
            }
            return completed(false)
        }
    }
}

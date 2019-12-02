//
//  Details.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/1/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import Foundation
import Firebase

class Details {
    var detailArray = [Detail]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("details").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.detailArray = []
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let detail = Detail(dictionary: document.data())
                detail.documentID = document.documentID
                self.detailArray.append(detail)
            }
            completed()
        }
    }
}

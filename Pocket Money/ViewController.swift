//
//  ViewController.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/1/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    var details: Details!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
        details = Details()
        details.detailArray.append(Detail(amount: 100, date: "2019-12-31", detail: "Grocery Shopping", postingUserID: "", documentID: ""))
        details.detailArray.append(Detail(amount: 200, date: "2019-12-31", detail: "Christmas Gift", postingUserID: "", documentID: ""))
        details.detailArray.append(Detail(amount: 300, date: "2019-12-31", detail: "Salary", postingUserID: "", documentID: ""))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = TableView.indexPathForSelectedRow!
            destination.detail = details.detailArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = TableView.indexPathForSelectedRow {
                TableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.detailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        cell.amountLabel.text = String(details.detailArray[indexPath.row].amount)
        cell.dateLabel.text = details.detailArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

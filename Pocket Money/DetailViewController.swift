//
//  DetailViewController.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/1/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    
    var detail: Detail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detail == nil {
            detail = Detail()
        }
        amountField.text = String(detail.amount)
        dateField.text = detail.date
        detailField.text = detail.detail
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func sortBasedOnSegmentPressed() {
        switch sortSegmentControl.selectedSegmentIndex {
        case 0: //Income
            detail.type = "Income"
        case 1: //Spending
            detail.type = "Spending"
        default:
            print("Hey, you should not have gotten here, our segmented conrtol should just have 2 segments")
        }
    }
    
    
    @IBAction func sortSegmentControl(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if detail.type == "" {
            detail.type = "Income"
        }
        detail.amount = Double(amountField.text!) as! Double
        detail.date = dateField.text!
        detail.detail = detailField.text!
        detail.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        detail.deleteData(detail: detail) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("😡 ERROR: Delete unsuccessful")
            }
        }
    }
    
}

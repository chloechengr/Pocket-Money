//
//  ViewController.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/1/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    
    var details: Details!
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.isHidden = true
        
        details = Details()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        let currentUser = authUI.auth?.currentUser
        if currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            TableView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: false)
        details.loadData {
            self.TableView.reloadData()
            if self.details.detailArray.count > 0 {
                var totalIncome = 0.0
                var totalSpending = 0.0
                for number in 0..<self.details.detailArray.count {
                    if self.details.detailArray[number].type == "Income" {
                        totalIncome = totalIncome + self.details.detailArray[number].amount
                    } else {
                        totalSpending = totalSpending + self.details.detailArray[number].amount
                    }
                }
                self.incomeLabel.text = String(totalIncome)
                self.spendingLabel.text = String(totalSpending)
            } else {
                self.incomeLabel.text = "0.0"
                self.spendingLabel.text = "0.0"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
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
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            TableView.isHidden = true
            signIn()
        } catch {
            TableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.detailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        cell.typeLabel.text = details.detailArray[indexPath.row].type
        cell.amountLabel.text = String(details.detailArray[indexPath.row].amount)
        cell.dateLabel.text = details.detailArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            TableView.isHidden = false
            print("*** We signed in with the user \(user.email ?? "unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.darkGray
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logos")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}

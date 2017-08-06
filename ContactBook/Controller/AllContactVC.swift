//
//  AllContactVC.swift
//  ContactBook
//
//  Created by Andrian Yohanes on 8/6/17.
//  Copyright © 2017 episquare. All rights reserved.
//

import UIKit
import RealmSwift

class AllContactVC: UIViewController {
    
    /// Right navigation bar button
    var rightNavButton = UIBarButtonItem()
    
    /// TableView properties.
    let tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.showsVerticalScrollIndicator = false
        myTableView.allowsSelection = false
        myTableView.estimatedRowHeight = 44
        myTableView.backgroundColor = .white
        return myTableView
    }()
    
    /// TableViewCell ID
    let contactCellID = "contactCellID"
    
    /// Empty container view for empty contact label
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /// Empty contact label
    let emptyContactlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    /// Contact count label
    let contactCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let realm = try! Realm()
    lazy var results = realm.objects(ContactBook.self)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /// if iOS 11 apply new large title navigation bar
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        /// Set title for UINavigaton Controller
        title = "Contact Book"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18, weight: .light)]

        /// Setup right nav bar button
        rightNavButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toAddContactVC))
        navigationItem.rightBarButtonItem = rightNavButton
        
        /// Setup views for AllContactVC
        setupViews()
        
        /// Setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        /// Register custom custom tableView cell
        tableView.register(ContactCell.self, forCellReuseIdentifier: contactCellID)
        
        /// Add customFooterView
        let customFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        customFooterView.backgroundColor = .white
        customFooterView.addSubview(contactCountLabel)
        contactCountLabel.fillSuperview()
        tableView.tableFooterView = customFooterView
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }
    
    

    func setupViews() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    
    
    /// Segue to AddContactVC
    @objc func toAddContactVC() {
        let addVc = AddContactVC()
        navigationController?.pushViewController(addVc, animated: true)
    }
    
    
    
    /// Reload tableView data
    @objc func reloadTableData() {
        DispatchQueue.main.async {
            guard self.results.count != 0 else {
                self.tableView.separatorStyle = .none
                self.showEmptyContactLabel(show: true)
                return
            }
            self.contactCountLabel.text = "\(self.results.count) Contacts"
            self.tableView.separatorStyle = .singleLine
            self.showEmptyContactLabel(show: false)
            self.tableView.reloadData()
        }
    }
    
    
    
    /// Show empty contact label
    fileprivate func showEmptyContactLabel(show: Bool) {
        guard show else {
            emptyView.removeFromSuperview()
            return
        }
        view.addSubview(emptyView)
        emptyView.addSubview(emptyContactlabel)
        
        emptyView.fillSuperview()
        
        emptyContactlabel.anchor(nil, left: emptyView.leftAnchor, bottom: nil, right: emptyView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: emptyContactlabel.frame.height)
        emptyContactlabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        let emptyString1 = "Oops it seem like you don't have any contact yet"
        let emptyString2 = "Tap the 'Plus' button on the top right corner to add new contact :)"
        let attributedText = NSMutableAttributedString(string: emptyString1, attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .semibold), .foregroundColor: UIColor.gray])
        attributedText.append(NSAttributedString(string: "\n\n\(emptyString2)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        emptyContactlabel.attributedText = attributedText
    }
    
}





// MARK:- UITableViewDataSource, UITableViewDelegate
extension AllContactVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellID, for: indexPath) as! ContactCell
        cell.contactData = results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            do {
                try realm.write {
                    realm.delete(results[indexPath.row])
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    reloadTableData()
                }
            } catch let error {
                print("Failed to deleted contact at index \(indexPath.row)", error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

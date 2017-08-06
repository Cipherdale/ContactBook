//
//  ContactCell.swift
//  ContactBook
//
//  Created by Andrian Yohanes on 8/6/17.
//  Copyright © 2017 episquare. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    required init(coder adecoder: NSCoder) {
        fatalError("init(codeer:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupViewsForContactCell()
    }
    
    let contactNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    
    
    /// Setup contactData for cell
    var contactData: ContactBook? {
        didSet {
            guard let name = contactData?.name else { return }
            guard let phoneNumber = contactData?.phoneNumber else { return }
            
            contactNameLabel.text = name
            phoneNumberLabel.text = phoneNumber
        }
    }
    
    
    
    /// Setup views for ContactCell
    func setupViewsForContactCell() {
        addSubview(contactNameLabel)
        addSubview(phoneNumberLabel)
        
        contactNameLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 18, bottomConstant: 0, rightConstant: 18, widthConstant: 0, heightConstant: contactNameLabel.frame.height)
        
        phoneNumberLabel.anchor(contactNameLabel.bottomAnchor, left: contactNameLabel.leftAnchor, bottom: bottomAnchor, right: contactNameLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: phoneNumberLabel.frame.height)
        
    }

    
    
    /// Reset cell properties when cell will reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        contactNameLabel.text = ""
        phoneNumberLabel.text = ""
    }

}

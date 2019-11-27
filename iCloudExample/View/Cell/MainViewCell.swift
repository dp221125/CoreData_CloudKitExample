//
//  MainViewCell.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {
    
    weak var todoTitleLabel: UILabel?
    weak var todoMakeDate: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        self.todoTitleLabel = label
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16)
        ])
        
        let dateLabel = UILabel()
        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.todoMakeDate = dateLabel
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


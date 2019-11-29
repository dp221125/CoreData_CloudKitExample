//
//  MainViewCell.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {
    let titleLabel: UILabel

    let createdAtLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        let createdAtLabel = UILabel()
        self.createdAtLabel = createdAtLabel
        createdAtLabel.font = .preferredFont(forTextStyle: .subheadline)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, createdAtLabel])
        stackView.axis = .vertical

        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.createdAtLabel.text = nil
    }

    weak var object: ToDo? {
        didSet {
            self.titleLabel.text = self.object?.title
            let formatter = ISO8601DateFormatter()
            self.createdAtLabel.text = self.object?.date.map(formatter.string(from:))
        }
    }
}

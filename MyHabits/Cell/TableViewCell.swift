//
//  TableViewCell.swift
//  MyHabits
//
//  Created by Alexander on 18.03.2023.
//

import UIKit

struct TableViewCellConfig {
    let dateText: String
    let isChecked: Bool
}

final class TableViewCell: UITableViewCell {
    
    //    MARK: - Property
    
    static let reuseId = "TableViewCell"
    
    private var dataSourse = HabitsStore.shared.dates
    
    private let label: UILabel = {
        var label = UILabel()
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Public functions
    
    func set(config: TableViewCellConfig) {
        label.text = config.dateText
        if config.isChecked == true {
            accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
            accessoryView?.tintColor = .purple
        }
    }
    
    //    MARK: - Private functions
    
    private func prepareView() {
        contentView.addSubview(label)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11)
        ])
    }
}

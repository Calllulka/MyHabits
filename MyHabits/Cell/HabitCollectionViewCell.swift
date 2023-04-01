//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Alexander on 18.03.2023.
//

import UIKit

struct HabitCollectionCellConfig {
    let habit: Habit
    let habitName: String
    let habitTime: String
    let habitColor: UIColor
    let habitIsChecked: Bool
    let couner: Int
}

protocol HabitCollectionViewCellDelegate: AnyObject {
    func habitDidPressedCheck(cell: HabitCollectionCell)
}

final class HabitCollectionCell: UICollectionViewCell {
    
    //    MARK: - Property
    
    weak var delegate: HabitCollectionViewCellDelegate?
    
    static let reuseId = "HabitCollectionViewCell"
    
    private(set) var isChecked: Bool = false {
        didSet {
            let imageName = isChecked ? "checkmark.circle.fill" : "circle"
            checkMark.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    private let nameHabit: UILabel = {
        var name = UILabel()
        name.font = .headline
        name.tintColor = .black
        name.numberOfLines = 2
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let timeHabit: UILabel = {
        var time = UILabel()
        time.font = .caption
        time.tintColor = .systemGray2
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    private let counter: UILabel = {
        var counter = UILabel()
        counter.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        counter.tintColor = .systemGray
        counter.text = "Cчетчик: 0"
        counter.translatesAutoresizingMaskIntoConstraints = false
        return counter
    }()
    
    private lazy var checkMark: UIButton = {
       var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapCheckMark), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Internal functions
    
    func set(config: HabitCollectionCellConfig) {
        nameHabit.text = config.habitName
        timeHabit.text = config.habitTime
        checkMark.tintColor = config.habitColor
        nameHabit.textColor = config.habitColor
        isChecked = config.habitIsChecked
        counter.text = "Счетчик: \(config.couner)"
    }
    
    //    MARK: - Private functions
    
    private func prepareView() {
        contentView.backgroundColor = .white
        contentView.addSubview(nameHabit)
        contentView.addSubview(timeHabit)
        contentView.addSubview(counter)
        contentView.addSubview(checkMark)
        contentView.layer.cornerRadius = 8
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
        
            nameHabit.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameHabit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameHabit.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -103),
            
            timeHabit.topAnchor.constraint(equalTo: nameHabit.bottomAnchor, constant: 4),
            timeHabit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            counter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -135),

            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            checkMark.heightAnchor.constraint(equalToConstant: 38),
            checkMark.widthAnchor.constraint(equalToConstant: 38),
            checkMark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46),
            
        ])
    }

    //MARK: - Actions
    
    @objc private func tapCheckMark() {
        self.delegate?.habitDidPressedCheck(cell: self)
    }
}

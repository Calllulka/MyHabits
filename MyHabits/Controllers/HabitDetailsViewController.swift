//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Alexander on 18.03.2023.
//

import UIKit

protocol HabitDetailsViewControllerDelegate: AnyObject {
    func habitDetailsViewControllerHabitDidEdited()
}

final class HabitDetailsViewController: UIViewController {
    
    //    MARK: - Property
    
    var delegate: HabitDetailsViewControllerDelegate?
    
    var habit: Habit? = nil {
        didSet {
            guard habit != nil else { return }
            tableView.reloadData()
        }
    }
    
    private let activity: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray2
        label.text = "АКТИВНОСТЬ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
        table.estimatedRowHeight = 44
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .myLightGray
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //    MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myLightGray
        navigationItem.largeTitleDisplayMode = .never
        addNavigationBar()
        prepareView()
        makeConstraints()
    }
    
    //    MARK: - Functions
    
    private func addNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(addHabitViewController))
        rightButton.tintColor = .purple
        
        let button = UIButton()
        let icon = UIImage(systemName: "chevron.backward")?.withTintColor(.purple, renderingMode: .alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.setTitle("Ceгодня", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(leftBarButton), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = habit?.name
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func prepareView() {
        view.addSubview(tableView)
        view.addSubview(activity)
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
        
            activity.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            activity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            activity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 7),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
    }
    
    @objc private func addHabitViewController() {
        guard  let habit = habit else { return }
        let habitViewController = HabitViewController()
        let modalNavigationController = UINavigationController(rootViewController: habitViewController)
        modalNavigationController.modalPresentationStyle = .fullScreen
        habitViewController.configurate(type: .edit(habit))
        habitViewController.delegate = self
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func leftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

//    MARK: - Extension

extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let habit = habit,
              let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }
        
        let dates = HabitsStore.shared.dates.filter({ !Calendar.current.isDateInToday($0) }).reversed() as [Date]
        let check = HabitsStore.shared.habit(habit, isTrackedIn: dates[indexPath.row])
        let dateText: String
        
        if dates[indexPath.row].isYesterday {
            dateText = "Вчера"
        } else if dates[indexPath.row].isAfterYesterday {
            dateText = "Позавчера"
        } else {
            let formatter = DateFormatter()
            formatter.locale = .init(identifier: "ru_RU")
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            formatter.dateFormat = "dd MMMM yyyy"
            dateText = formatter.string(from: dates[indexPath.row])
        }

        let config = TableViewCellConfig(dateText: dateText,
                                         isChecked: check)
        cell.set(config: config)
        return cell
    }
}

extension HabitDetailsViewController: HabitViewControllerDelegate {
    
    func habitViewControllerAddedOrEditedHabit() {
        delegate?.habitDetailsViewControllerHabitDidEdited()
    }
    
    func habitViewControllerDeleteHabit(habit: Habit) {
        delegate?.habitDetailsViewControllerHabitDidEdited()
        self.navigationController?.popViewController(animated: false)
    }
}

extension Date {
    
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    var isAfterYesterday: Bool {
        let afterYesterdayDate = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let startAfterYesterday = Calendar.current.startOfDay(for: afterYesterdayDate)
        let endAfterYesterday = Calendar.current.date(byAdding: .hour, value: 24, to: startAfterYesterday) ?? Date()
        return (startAfterYesterday ... endAfterYesterday).contains(self)
    }
}

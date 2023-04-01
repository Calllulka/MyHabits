//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Alexander on 14.03.2023.
//

import UIKit

final class HabitsViewController: UIViewController {
    
    //    MARK: - Property
    
    private var dataSourse: [Habit] {
        HabitsStore.shared.habits
    }
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        var collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemGray6
       
        collection.register(ProgressCollectionCell.self,
                            forCellWithReuseIdentifier: ProgressCollectionCell.reuseId)
        
        collection.register(HabitCollectionCell.self,
                            forCellWithReuseIdentifier: HabitCollectionCell.reuseId)
        
        return collection
    }()
    
    //    MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarButton()
        prepareView()
        makeConstraints()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .myLightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //    MARK: - Private functions
    
    private func addNavBarButton() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(actionBarbutton))
        barButton.tintColor = .purple
        navigationItem.rightBarButtonItem = barButton
    }
        
    private func prepareView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func actionBarbutton() {
        let habitViewController = HabitViewController()
        habitViewController.configurate(type: .create)
        let modalNavigationController = UINavigationController(rootViewController: habitViewController)
        modalNavigationController.modalPresentationStyle = .fullScreen
        habitViewController.delegate = self
        navigationController?.present(modalNavigationController, animated: true)
    }
}

//    MARK: - Extension collectionView

extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.reuseId, for: indexPath) as? ProgressCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.setProgress(progress: HabitsStore.shared.todayProgress)
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionCell.reuseId, for: indexPath) as? HabitCollectionCell else {
                return UICollectionViewCell()
            }
            
            let habit = dataSourse[indexPath.row - 1]
            let trackedHabitCount = habit.trackDates.filter {
                HabitsStore.shared.habit(habit, isTrackedIn: $0)
            }.count
            
            let config = HabitCollectionCellConfig(habit: habit,
                                                   habitName: habit.name,
                                                   habitTime: habit.dateString,
                                                   habitColor: habit.color,
                                                   habitIsChecked: habit.isAlreadyTakenToday,
                                                   couner: trackedHabitCount)
            
            cell.set(config: config)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 1 {
            let habit = dataSourse[indexPath.row - 1]
            let habitDetailsViewController = HabitDetailsViewController()
            habitDetailsViewController.habit = habit
            habitDetailsViewController.delegate = self
            navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 33
        let height = CGFloat(indexPath.row == 0 ? 60 : 130)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 22, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension HabitsViewController: HabitViewControllerDelegate {
    func habitViewControllerAddedOrEditedHabit(habitIndex: Int) {
        let indexPath = IndexPath(item: habitIndex, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
}

extension HabitsViewController: HabitDetailsViewControllerDelegate {
    func habitDetailsViewControllerHabitDidEdited(habitIndex: Int) {
        let indexPath = IndexPath(row: habitIndex + 1, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func habitDetailsViewControllerHabitDidDeleted(habitIndex: Int) {
        let indexPath = IndexPath(item: habitIndex + 1, section: 0)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension HabitsViewController: HabitCollectionViewCellDelegate {
    func habitDidPressedCheck(cell: HabitCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let habitIndex = indexPath.row - 1

        if dataSourse[habitIndex].isAlreadyTakenToday {
            dataSourse[habitIndex].trackDates.removeLast()
        } else {
            HabitsStore.shared.track(dataSourse[habitIndex])
        }
        
        let progressIndexPath = IndexPath(row: 0, section: 0)
        collectionView.reloadItems(at: [progressIndexPath, indexPath])
    }
}

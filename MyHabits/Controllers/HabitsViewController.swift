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
        setupView()
        prepareView()
        setupLayouts()
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
    
    //    MARK: - Functions
    
    private func setupView() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(actionBarbutton))
        barButton.tintColor = .purple
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func actionBarbutton() {
        let habitViewController = HabitViewController()
        habitViewController.configurate(type: .create)
        let modalNavigationController = UINavigationController(rootViewController: habitViewController)
        modalNavigationController.modalPresentationStyle = .fullScreen
        habitViewController.delegate = self
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    private func prepareView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
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
            
            var counter: Int = 0
            habit.trackDates.forEach { date in
               counter += HabitsStore.shared.habit(habit, isTrackedIn: date) ? 1 : 0
            }
            
            let config = HabitCollectionCellConfig(habit: habit,
                                                   habitName: habit.name,
                                                   habitTime: habit.dateString,
                                                   habitColor: habit.color,
                                                   habitIsChecked: habit.isAlreadyTakenToday,
                                                   couner: counter)
            
            cell.set(config: config)
            cell.delegate = self
//            cell.cellChenge = self
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
    
    private func itemWidth(
        for width: CGFloat,
        spacing: CGFloat
    ) -> CGFloat {
        let itemsInRow: CGFloat = 1
        
        let finalWidth = (width - 33) / itemsInRow
        
        return finalWidth
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.row == 0 {
            let width = itemWidth(
                for: view.frame.width,
                spacing: 33
            )
            let height = CGFloat(60)
            
            return CGSize(width: width, height: height)
        } else {
            let width = itemWidth(
                for: view.frame.width,
                spacing: 33
            )
            let height = CGFloat(130)
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: CGFloat(22),
            left: CGFloat(16),
            bottom: CGFloat(18),
            right: CGFloat(17)
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
}

extension HabitsViewController: HabitViewControllerDelegate {
    
    func habitViewControllerAddedOrEditedHabit(habitIndex: Int) {
        let indexPath = IndexPath(item: habitIndex, section: 0)
        collectionView.insertItems(at: [indexPath])
    }

    func habitViewControllerDeleteHabit(habitIndex: Int) {
        let indexPath = IndexPath(item: habitIndex, section: 0)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension HabitsViewController: HabitDetailsViewControllerDelegate {
    func habitDetailsViewControllerHabitDidEdited(habitIndex: Int) {
        let indexPath = IndexPath(item: habitIndex, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
}

extension HabitsViewController: HabitCollectionViewCellDelegate {
    
    func habitDidPressedCheck(cell: HabitCollectionCell) {
        guard
            let indexPath = collectionView.indexPath(for: cell),
            let progressCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProgressCollectionCell,
            let progressIndex = collectionView.indexPath(for: progressCell)
        else { return }
        
        let habitIndex = indexPath.row - 1
        
        if dataSourse[habitIndex].isAlreadyTakenToday {
            dataSourse[habitIndex].trackDates.removeLast()
        } else {
            HabitsStore.shared.track(dataSourse[habitIndex])
        }
        
        collectionView.reloadItems(at: [progressIndex, indexPath])
    }
}

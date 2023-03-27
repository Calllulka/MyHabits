//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Alexander on 15.03.2023.
//

import UIKit

enum HabitViewControllerType: Equatable {
    case create
    case edit(Habit)
}

protocol HabitViewControllerDelegate: AnyObject {
    func habitViewControllerAddedOrEditedHabit()
    func habitViewControllerDeleteHabit(habit: Habit)
}

class HabitViewController: UIViewController {
    
    //    MARK: - Property
    
    weak var delegate: HabitViewControllerDelegate?
    
    private var screenType: HabitViewControllerType = .create
    
    private var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            setHabit(habit: habit)
        }
    }
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = .footnote
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addHabitName: UITextField = {
        var text = UITextField()
        text.font = .body
        text.textColor = .blue
        text.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        return text
    }()
    
    private let color: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = .footnote
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var circle: UIButton = {
        var circle = UIButton()
        circle.layer.cornerRadius = 15
        circle.backgroundColor = .orange
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.addTarget(self, action: #selector(openColor), for: .touchUpInside)
        return circle
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = .footnote
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addTime: UILabel = {
        var text = UILabel()
        text.font = .body
        text.tintColor = .black
        text.text = "Каждый день в ..."
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var dataPicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(date), for: .valueChanged)
        return picker
    }()
    
    private let habitDelete: UIButton = {
       var button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        prepareView()
        makeConstraints()
        configurateNavigationBar()
    }
    
    //    MARK: - Functions
    
    func configurate(type: HabitViewControllerType) {
        screenType = type
        switch type {
        case .create:
            title = "Создать"
            habitDelete.isHidden = true
            
        case .edit(let habit):
            title = "Править"
            habitDelete.isHidden = false
            self.habit = habit
        }
    }
    
    private func setHabit(habit: Habit) {
        addHabitName.text = habit.name
        dataPicker.date = habit.date
        circle.backgroundColor = habit.color
    }
    
    private func configurateNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(tapRightButtonSave))
        rightButton.tintColor = .purple
        let leftButton = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(tapLeftBarButton))
        leftButton.tintColor = .purple
        leftButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.body], for: .normal)
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func tapRightButtonSave() {
        screenType == .create ? saveHabit(): editHabit()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapLeftBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    private func prepareView() {
        view.addSubview(labelName)
        view.addSubview(addHabitName)
        view.addSubview(color)
        view.addSubview(circle)
        view.addSubview(time)
        view.addSubview(addTime)
        view.addSubview(dataPicker)
        view.addSubview(habitDelete)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
        
            labelName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelName.heightAnchor.constraint(equalToConstant: 18),
            
            addHabitName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 7),
            addHabitName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            color.topAnchor.constraint(equalTo: addHabitName.bottomAnchor, constant: 15),
            color.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            circle.topAnchor.constraint(equalTo: color.bottomAnchor, constant: 7),
            circle.heightAnchor.constraint(equalToConstant: 30),
            circle.widthAnchor.constraint(equalToConstant: 30),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            time.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 15),
            time.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        
            addTime.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 7),
            addTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        
            dataPicker.topAnchor.constraint(equalTo: addTime.bottomAnchor, constant: 15),
            dataPicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            dataPicker.heightAnchor.constraint(equalToConstant: 216),
            
            habitDelete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            habitDelete.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func date(paramdatePicker: UIDatePicker) {
        
        if paramdatePicker.isEqual(self.dataPicker) {
            let formater = DateFormatter()
            formater.dateFormat = "hh:mm a"
            let attrebutedText = NSMutableAttributedString(string: "Каждый день в ")
            let timeAttrebutedText = NSMutableAttributedString(string: "\(formater.string(from: paramdatePicker.date))")
            
            timeAttrebutedText.addAttributes([.foregroundColor : UIColor.purple],
                                             range: NSRange(location: 0, length: timeAttrebutedText.length))
            
            attrebutedText.append(timeAttrebutedText)
            addTime.attributedText = attrebutedText
        }
    }
    
    @objc private func openColor() {
        presentColorPicker()
    }
    
    private func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = .orange
        colorPicker.title = "Выберите Цвет"
        present(colorPicker, animated: true, completion: nil)
    }
    
    private func saveHabit() {
        let newHabit = Habit(name: addHabitName.text ?? "Текст не введен",
                             date: dataPicker.date,
                             color: circle.backgroundColor ?? .orange)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        delegate?.habitViewControllerAddedOrEditedHabit()
    }
    
    private func editHabit() {
        
        guard let currentHabit = habit,
              let habitIndex = HabitsStore.shared.habits.firstIndex(where: { $0 == currentHabit })
        else {
            return
        }
        currentHabit.color = circle.backgroundColor ?? .orange
        currentHabit.date = dataPicker.date
        currentHabit.name = addHabitName.text ?? "Текст не введен"
        HabitsStore.shared.habits[habitIndex] = currentHabit
        delegate?.habitViewControllerAddedOrEditedHabit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    @objc func deleteHabit() {
        let alertText = "Вы хотите удалить привычку \"\(habit?.name ?? "")\"?"
        let alert = UIAlertController(title: "Удалить привычку", message: alertText, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Отмена", style: .cancel) {_ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let actionTwo = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            guard let deleteHabit = self.habit,
                  let habitIndex = HabitsStore.shared.habits.firstIndex(where: { $0 == deleteHabit })
            else {
                return
            }
            HabitsStore.shared.habits.remove(at: habitIndex)
            self.delegate?.habitViewControllerDeleteHabit(habit: deleteHabit)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        
        present(alert, animated: true, completion: nil)
    }
}

//    MARK: - Extension

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    internal func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        circle.backgroundColor = viewController.selectedColor
    }
}

extension HabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


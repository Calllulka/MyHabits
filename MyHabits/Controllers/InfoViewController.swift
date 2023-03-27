//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Alexander on 14.03.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    //    MARK: - Property
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let textInfo: UILabel = {
        var text = UILabel()
        text.text = "Привычка за 21 день"
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let oneText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let twoText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let threeText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "2. Выдержать 2 дня в прежнем состоянии самоконтроля."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fourText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fiveText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sixText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sevenText: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        makeConstraints()
    }
    
    //    MARK: - Functions
    
    func prepareView() {
        view.addSubview(scrollView)
        scrollView.addSubview(textInfo)
        scrollView.addSubview(oneText)
        scrollView.addSubview(twoText)
        scrollView.addSubview(threeText)
        scrollView.addSubview(fourText)
        scrollView.addSubview(fiveText)
        scrollView.addSubview(sixText)
        scrollView.addSubview(sevenText)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textInfo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22),
            textInfo.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textInfo.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -141),
            
            oneText.topAnchor.constraint(equalTo: textInfo.bottomAnchor, constant: 12),
            oneText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            oneText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            twoText.topAnchor.constraint(equalTo: oneText.bottomAnchor, constant: 12),
            twoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            twoText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            threeText.topAnchor.constraint(equalTo: twoText.bottomAnchor, constant: 12),
            threeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            threeText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            fourText.topAnchor.constraint(equalTo: threeText.bottomAnchor, constant: 12),
            fourText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fourText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            fiveText.topAnchor.constraint(equalTo: fourText.bottomAnchor, constant: 12),
            fiveText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fiveText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            sixText.topAnchor.constraint(equalTo: fiveText.bottomAnchor, constant: 12),
            sixText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sixText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            sevenText.topAnchor.constraint(equalTo: sixText.bottomAnchor, constant: 12),
            sevenText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sevenText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            sevenText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

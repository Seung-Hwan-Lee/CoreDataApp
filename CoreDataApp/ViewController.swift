//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Thomas on 2020/08/28.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Use private root context"
        return label
    }()
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.addTarget(self, action: #selector(didChangeUseRootContext(_:)), for: .valueChanged)
        return switchControl
    }()
    var horizontalStackView = UIStackView()

    var fetchResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var stackView = UIStackView()

    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()

        switchControl.isOn = appDelegate.isUseRootContext

        insertDataIfNeeds()

        fetchData()
    }

    func prepareSubviews() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        horizontalStackView.addArrangedSubview(descriptionLabel)
        horizontalStackView.addArrangedSubview(switchControl)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(fetchResultLabel)
    }

    func insertDataIfNeeds() {
        guard UserDefaults.standard.bool(forKey: Key.isDataInserted.rawValue) == false else {
            return
        }
        let context = appDelegate.backgroundContext
        context.perform {
            ["Kim", "Lee", "Park", "Hong", "Moon", "Choo"].forEach { name in
                let person = ManagedPerson(entity: ManagedPerson.entity(), insertInto: context)
                person.name = name
            }
            do {
                try context.save()
                UserDefaults.standard.set(true, forKey: Key.isDataInserted.rawValue)
            }
            catch {
                fatalError()
            }
        }
    }

    func fetchData() {
        let context = appDelegate.backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<ManagedPerson> = ManagedPerson.fetchRequest()
            fetchRequest.fetchBatchSize = 5

            do {
                let fetchedList = try context.fetch(fetchRequest)
                let message = "Fetched result count : \(fetchedList.count)"
                DispatchQueue.main.async {
                    self.fetchResultLabel.text = message
                }
            }
            catch {
                fatalError()
            }
        }
    }

    @objc func didChangeUseRootContext(_ sender: Any) {
        guard let switchControl = sender as? UISwitch else {
            fatalError()
        }
        appDelegate.isUseRootContext = switchControl.isOn

        let alertController = UIAlertController(title: "Notice", message: "App will quit to apply change.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            exit(0)
        }))
        present(alertController, animated: true, completion: nil)
    }
}


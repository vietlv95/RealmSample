//
//  ViewController.swift
//  RealmSample
//
//  Created by ngo van do on 18/07/2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var peoples: Results<People>!

  override func viewDidLoad() {
    super.viewDidLoad()
    config()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData()
  }
  
  private func config() {
    title = "People"
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  private func fetchData() {
    let realm = try! Realm()
    peoples = realm.objects(People.self)
    self.tableView.reloadData()
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {
    showAlert(title: "New Person", message: "Enter new info") {[weak self] name, phone in
        self?.save(name: name, phone: phone)
        self?.tableView.reloadData()
    }
  }
  
  func update(name: String,phone: String,  index: Int) {
    let realm = try! Realm()
    
    let person = self.peoples[index]
    try! realm.write {
        person.name = name
        person.phone = phone
    }
  }
  
  func save(name: String, phone: String) {
    let person = People()
    person.id = UUID().uuidString
    person.name = name
    person.phone = phone
    
    let realm = try! Realm()
    try! realm.write {
        realm.add(person)
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return peoples.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let person = peoples[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.text = "Name: \(person.name ?? "")" + "\n" + "Phone: \(person.phone ?? "")"
    return cell
  }
}


extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showAlert(title: "Update", message: "Enter new info") {[weak self] name, phone in
        self?.update(name: name, phone: phone, index: indexPath.row)
        self?.tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let person = peoples[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(person)
        }
        self.tableView.reloadData()
    }
  }
    
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Delete"
  }
}

extension ViewController {
  func showAlert(title: String, message: String, saveCompletionHandler:((_ name: String, _ phone: String) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { action in

      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }
      
      guard let textField = alert.textFields?[1],
        let phoneToSave = textField.text else {
          return
      }

      saveCompletionHandler?(nameToSave, phoneToSave)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addTextField { nameTextField in
      nameTextField.placeholder = "name"
    }
    
    alert.addTextField { phoneTextFiled in
      phoneTextFiled.placeholder = "phone"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }
}


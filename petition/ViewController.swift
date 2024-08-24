//
//  ViewController.swift
//  petition
//
//  Created by Sanam Gurung on 8/24/24.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        // Create the right bar button item
        let rightBarButton = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCreditAlert))
        
        // Left Bar Button Item for filtering petitions
        let leftBarButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterAlert))
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func showFilterAlert() {
          // Create the alert controller
          let ac = UIAlertController(title: "Filter Petitions", message: "Enter a keyword to filter petitions", preferredStyle: .alert)
          
          // Add a text field to the alert for user input
          ac.addTextField()
          
          // Add an action for filtering the list
          let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
              guard let filterText = ac?.textFields?[0].text else { return }
              self?.filterPetitions(with: filterText)
          }
          
          // Add an action to reset the filter
          let resetAction = UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
              self?.filteredPetitions = self?.petitions ?? []
              self?.tableView.reloadData()
          }

          // Add the actions to the alert controller
          ac.addAction(filterAction)
          ac.addAction(resetAction)
          
          // Present the alert
          present(ac, animated: true, completion: nil)
      }
    
    func filterPetitions(with query: String) {
           // Filter the petitions array
           filteredPetitions = petitions.filter { petition in
               return petition.title.localizedCaseInsensitiveContains(query) || petition.body.localizedCaseInsensitiveContains(query)
           }
           
           // Reload the table view with the filtered data
           tableView.reloadData()
       }

    @objc func showCreditAlert() {
        // Create the alert
        let alert = UIAlertController(title: "Credits", message: "It's credited from hackingwithswift", preferredStyle: .alert)
        
        // Add an OK action to dismiss the alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


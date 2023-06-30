//
//  ViewController.swift
//  MVVM&UnitTest
//
//  Created by M_2195552 on 2023-05-03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvTableView: UITableView!
    private let viewModel = ViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchData()
        callbackHandler()
    }
}

extension ViewController {
    func callbackHandler() {
        viewModel.requestSucceeded = { [weak self] in
            if let _weakSelf = self {
                //DispatchQueue.main.async {
                    _weakSelf.tvTableView.reloadData()
                //}
            }
        }
        
        viewModel.requestFailed = { error in
            print(error)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConstants.tableViewCellId, for: indexPath)
        let objectAtIndex = viewModel.apiResponseModel[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = objectAtIndex.name
        contentConfiguration.secondaryText = objectAtIndex.description
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}


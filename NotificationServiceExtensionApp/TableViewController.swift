//
//  TableViewController.swift
//  NotificationServiceExtensionApp
//
//  Created by BaglaiB on 25.04.2020.
//  Copyright © 2020 bogdan. All rights reserved.
//


import UIKit

class TableViewController: UIViewController {

    let searchBarModel: SearchViewModel
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self.searchBarModel
        self.view.addSubview(searchBar)
        return searchBar
    }()

    let tableViewModel: TableViewModel
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self.tableViewModel
        table.delegate = self.tableViewModel
        table.register(TableViewCell.self, forCellReuseIdentifier: self.tableViewModel.cellId)
        self.view.addSubview(table)

        return table
    }()

    init() {
        self.searchBarModel = SearchViewModel()
        self.tableViewModel = TableViewModel()
        super.init(nibName: nil, bundle: nil)

        self.searchBarModel.textHandler = { [weak self] (searchText) in

        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.configureConstraints()
    }

    private func configureConstraints() {

        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        let searchBarConstraits = [
            self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(searchBarConstraits)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableConstraints = [
            self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableConstraints)
    }
}

class SearchViewModel: NSObject {
    var textHandler: ((String) -> Void)?
}

extension SearchViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.textHandler?(searchText)
    }
}


class TableViewModel: NSObject {

    let cellId: String = "CellId"
    var cellVMs: [String] = [String]()

    override init() {
        super.init()
        self.loadData()
    }

    private func loadData() {
        self.cellVMs = UserDefaults.standard.object(forKey: "PushNotifications") as? [String] ?? [String]()
    }

}

extension TableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellVMs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cellView = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cellView.textLabel?.text = self.cellVMs[indexPath.row]
        return cellView
    }
}

extension TableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

class TableViewCell: UITableViewCell {

}


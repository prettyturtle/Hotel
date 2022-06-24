//
//  TotalListViewController.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit
import SnapKit

class TotalListViewController: UIViewController {
    // MARK: - UI Components
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(
            self,
            action: #selector(beginRefreshing(_:)),
            for: .valueChanged
        )
        return refresh
    }()
    private lazy var totalListTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150.0
        tableView.dataSource = self
        tableView.register(
            ItemTableViewCell.self,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private var hotelList = [Product]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
        
        fetchData(page: 1)
    }
}

// MARK: - UITableViewDataSource
extension TotalListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return hotelList.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.identifier,
            for: indexPath
        ) as? ItemTableViewCell else { return UITableViewCell() }
        let product = hotelList[indexPath.row]
        cell.product = product
        cell.setupView(product: product, style: .total)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Methods
private extension TotalListViewController {
    func fetchData(page: Int) {
        Network().get(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let hotelList):
                self.updateHotelListAndReload(products: hotelList)
            case .failure(let error):
                print(error, "🐽🐽")
            }
        }
    }
    func updateHotelListAndReload(products: [Product]) {
        hotelList = products
        totalListTableView.reloadData()
    }
}

// MARK: - @objc Methods
private extension TotalListViewController {
    @objc func beginRefreshing(_ control: UIRefreshControl) {
        totalListTableView.reloadData()
        control.endRefreshing()
    }
}

// MARK: - UI Methods
private extension TotalListViewController {
    func setupNavigationBar() {
        navigationItem.title = "전체"
    }
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        view.addSubview(totalListTableView)
        totalListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

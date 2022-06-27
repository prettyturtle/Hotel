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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ItemTableViewCell.self,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        tableView.refreshControl = refreshControl
        return tableView
    }()
    private lazy var pagingIndicatorView: PagingIndicatorView = {
        let indicator = PagingIndicatorView()
        indicator.delegate = self
        return indicator
    }()
    
    private var currentShowPage = 1
    private let limitCellCount = 20
    private var hotelList = [Product]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAttribute()
        setupLayout()
        
        fetchData(page: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalListTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension TotalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(product: hotelList[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /* Paging
         한번에 20개 단위로 보여줘야한다. 20, 40, 60, ...
         17, 37, 57, ...번 째 셀이 보여질 시점에
         PagingIndicatorView를 테이블 뷰의 footerView로 보여주면 된다.
         17, 37, 57, ...은 20으로 나누었을 때의 나머지가 17이라는 공통점을 가진다.
         => indexPath.row % limitCellCount(20) == limitCellCount - 3(17)
         
         현재 fetch한 page 번호를 저장하고 있다가
         새로 fetch할 때 page 번호를 1만큼 증가시킨다.
         
         스크롤을 아래로 하다가 다시 위로 올라갈 경우
         17, 37, 57, ...번 째 셀을 다시 보여주는데
         PagingIndicatorView를 footerView에 한번씩만 설정하려면
         현재 보고있는 셀이 몇 번째에 fetch 되었는지 확인하고
         이를 currentShowPage와 비교하여 footerView를 한번씩만 설정해주면 된다.
         => currentShowPage == (indexPath.row / limitCellCount) + 1
         */
        if indexPath.row % limitCellCount == limitCellCount - 3
            && currentShowPage == (indexPath.row / limitCellCount) + 1 {
            tableView.tableFooterView = pagingIndicatorView
        }
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

// MARK: - PagingIndicatorViewDelegate
extension TotalListViewController: PagingIndicatorViewDelegate {
    func showMoreItem() {
        fetchData(page: currentShowPage + 1)
        currentShowPage += 1
        pagingIndicatorView.stopAnimating()
        totalListTableView.tableFooterView = nil
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
        hotelList += products
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

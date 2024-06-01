//
//  RestaurantListVC.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import UIKit

class RestaurantListVC: BaseVC {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    
    private var restaurantViewModel: RestaurantViewModel!
    private var refreshControl = UIRefreshControl()

    init(viewModel: RestaurantViewModel) {
        super.init(nibName: "\(RestaurantListVC.self)", bundle: .main)
        restaurantViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantViewModel.delegate = self
        setupTableView()
        setupSearchBar()
        restaurantViewModel.fetch(page: .first)
        restaurantViewModel.populateLocalData()
        tableView.reloadData()
    }
}

extension RestaurantListVC {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "\(RestaurantTVCell.self)", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "\(RestaurantTVCell.self)")
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
}

extension RestaurantListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantViewModel.currentVenueList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RestaurantTVCell.self)", for: indexPath) as! RestaurantTVCell
        cell.venueData = restaurantViewModel.currentVenueList[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //can make custom refresh Control here
        if restaurantViewModel.canFetchNextPage() {
            let bottom = tableView.contentSize.height + tableView.contentInset.bottom - tableView.bounds.size.height
            if (tableView.contentOffset.y + 5 >= bottom) {
                restaurantViewModel.fetch(page: .next)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension RestaurantListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        restaurantViewModel.search(for: searchText)
        tableView.reloadData()
    }
}

extension RestaurantListVC: RestaurantViewModelProtcol {
    func fetchSuccess(for params: [String : Any]) {
        if restaurantViewModel.isFirstPage() {
            tableView.reloadData()
        } else {
            tableView.insertRows(at: restaurantViewModel.getLastPageIndexes(), with: .none)
        }
        refreshControl.endRefreshing()
    }
    
    func fetchFailure(with error: any Error, for params: [String : Any]) {
        //Show Error Here
        return
    }
    
    @objc private func refreshPage() {
        restaurantViewModel.fetch(page: .first)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

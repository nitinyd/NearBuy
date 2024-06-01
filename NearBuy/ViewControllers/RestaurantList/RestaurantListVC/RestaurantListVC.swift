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
    
    private var restaurantFeed = RestaurantViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantFeed.delegate = self
        setupTableView()
        setupSearchBar()
        restaurantFeed.fetch(page: .first)
    }
}

extension RestaurantListVC {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "\(RestaurantTVCell.self)", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "\(RestaurantTVCell.self)")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
}

extension RestaurantListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantFeed.currentVenueList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RestaurantTVCell.self)", for: indexPath) as! RestaurantTVCell
        cell.venueData = restaurantFeed.currentVenueList[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //can make custom refresh Control here
        if restaurantFeed.canFetchNextPage() {
            let bottom = tableView.contentSize.height + tableView.contentInset.bottom - tableView.bounds.size.height
            if (tableView.contentOffset.y + 5 >= bottom) {
                restaurantFeed.fetch(page: .next)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension RestaurantListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        restaurantFeed.search(for: searchText)
        tableView.reloadData()
    }
}

extension RestaurantListVC: APIResultProtocol {
    func fetchSuccess(for params: [String : Any]) {
        if restaurantFeed.currentPage == 1 {
            tableView.reloadData()
        } else {
            tableView.insertRows(at: restaurantFeed.lastPageIndexes, with: .none)
        }
    }
    
    func fetchFailure(with error: any Error, for params: [String : Any]) {
        //Show Error Here
        return
    }
}

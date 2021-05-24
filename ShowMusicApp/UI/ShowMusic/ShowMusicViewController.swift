//
//  ViewController.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import UIKit

class ShowMusicViewController: UITableViewController {
    
    var viewModel: IShowMusicViewModel?
    var storedOffsets = [Int: CGFloat]()
    
    lazy var spinner : UIActivityIndicatorView = {
        let res = UIActivityIndicatorView(style: .large)
        res.color = .blue
        res.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(res)
        res.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        res.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return res
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        initUIComponents()
        reloadTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    // MARK: - UIComponents
    
    private func initUIComponents() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: .valueChanged)
    }
    
    @objc func didPullToRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        reloadTableView()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Ooop!", message: "Something wrong happens!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showLoadingIndicator() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    private func reloadTableView() {
        
        viewModel?.reloadData{ [weak self] success in
            if (success)    { self?.tableView.reloadData() }
            else            { self?.showError() }
        }
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        viewModel?.isLoadingData.bind(listener: { [weak self] isLoading in
            DispatchQueue.main.async {                
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        })
    }
    
    private func removeObservers() {
        viewModel?.isLoadingData.unbind()
    }
}

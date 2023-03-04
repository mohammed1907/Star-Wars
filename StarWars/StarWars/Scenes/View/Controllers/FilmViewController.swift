//
//  ViewController.swift
//  StarWars
//
//  Created by Farghaly on 03/03/2023.
//

import UIKit

enum ViewState {
    case `default`
    case search
    case result
}

class FilmViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filmTableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var resetSearch: UIButton!
    @IBOutlet weak var bottomSearchView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    // MARK: - Properties
    lazy private var viewModel: FilmViewModel = {
        return FilmViewModel()
    }()
}

// MARK: - Life Cycle
extension FilmViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
}

// MARK: - Setup UI
private extension FilmViewController {
    func setupUI() {
        setupTableView()
        hideKeyboard()
        containerHeight.constant = 0
        searchContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        searchText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    func setupTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib.init(nibName: SearchResultCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SearchResultCell.identifier)
        filmTableView.dataSource = self
        filmTableView.delegate = self
        filmTableView.register(UINib.init(nibName: FilmResultCell.identifier, bundle: nil),
                           forCellReuseIdentifier: FilmResultCell.identifier)
    }
}

// MARK: - Setup Actions
private extension FilmViewController {
    @IBAction func searchPressed(_ sender: Any) {
        updateUI(for: .search)
    }

    @IBAction func dismissSearchPressed(_ sender: Any) {
        updateUI(for: .default)
    }

    @IBAction func closeResultPressed(_ sender: Any) {
        updateUI(for: .search)
        viewModel.emptySearchResult()
    }

    @IBAction func resetSearchPressed(_ sender: Any) {
        searchText.text = ""
        resetSearch.isHidden = true
        updateUI(for: .search)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? false) {
            resetSearch.isHidden = false
            if textField.text!.count >= 3 {
                viewModel.search(text: textField.text!)
            } else {
                viewModel.emptySearchResult()
                updateUI(for: .search)
            }
        } else {
            resetSearch.isHidden = true
            viewModel.emptySearchResult()
            updateUI(for: .search)
        }
    }

    func checkSearchResult() {
        if viewModel.numberOfSearchCells > 0 {
            updateUI(for: .result)
        } else {
            updateUI(for: .search)
        }
    }

    func updateUI(for viewState: ViewState) {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            switch viewState {
            case .default:
                self.containerHeight.constant = 0
            case .search:
                self.containerHeight.constant = 150
                self.bottomSearchView.isHidden = true
            case .result:
                self.containerHeight.constant = 350
                self.bottomSearchView.isHidden = false
            }
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - Setup Binding
private extension FilmViewController {
    func setupBinding() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                case .loading:
                    self.activityIndicator.startAnimating()
                case .populated:
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }

        viewModel.reloadFilmTableViewClosure = { [weak self] () in
            guard let self = self else {
                return
            }
            self.filmTableView.reloadData()
        }
        viewModel.reloadSearchTableViewClosure = { [weak self] () in
            guard let self = self else {
                return
            }
            self.checkSearchResult()
            self.searchTableView.reloadData()
        }
        viewModel.getFilms()
    }

}

// MARK: - TableView DataSource
extension FilmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == filmTableView ? viewModel.numberOfFilmCells : viewModel.numberOfSearchCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filmTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmResultCell", for: indexPath)
                    as? FilmResultCell else {
                fatalError("Cell not exists in storyboard")
            }
            let cellVM = viewModel.getFilmCellViewModel( at: indexPath )
            cell.filmData = cellVM
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
                    as? SearchResultCell else {
                fatalError("Cell not exists in storyboard")
            }
            let cellVM = viewModel.getSearchCellViewModel( at: indexPath )
            cell.searchData = cellVM
            return cell
        }
  
    }
}

// MARK: - TableView Delegate
extension FilmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //TODO: nav to details

    }
}

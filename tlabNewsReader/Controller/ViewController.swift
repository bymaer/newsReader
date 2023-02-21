//
//  ViewController.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/3/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    private var apiCaller = APICaller()
    var image = UIImage()
    var count = 1
    var sortby = ["publishedAt", "relevancy", "popularity"]
    var domains = ["engadget.com", "bbc.co.uk", "techcrunch.com", "thenextweb.com"]
    private var data = [Articles]()
    var openCounts = [Int](repeating: 0, count: 20)
    
    var parameters = [
        "page": "1",
        "sortby": "popularity",
        "pageSize": "20",
        "apiKey": "9d19289ad0ef4002876b9967bb4c22af",
        "domains": "techcrunch.com"
    ] as [String : Any]
    
    
    let queue = DispatchQueue(label: "DispatchQueue", attributes: .concurrent)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cellTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setupURL()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        title = "Newsfeed"
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    @objc func callPullToRefresh(){
        self.data.removeAll()
        self.tableView.reloadData()
        count = 1
        parameters["sortby"] = String(sortby.randomElement() ?? "publishedAt")
        parameters["domains"] = String(domains.randomElement() ?? "techcrunch.com")
        self.openCounts.removeAll()
        self.openCounts = [Int](repeating: 0, count: 20)
        self.setupURL()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){
            self.tableView.refreshControl?.endRefreshing()
                   }
        }
    
    func setupURL() {
        var feedURLComponents = URLComponents(string:"https://newsapi.org/v2/everything?")!
        feedURLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value as? String)
        })
        
        if let url = URL(string: (feedURLComponents.url?.relativeString)!) {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    self.apiCaller.parse(json: data)
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        apiCaller.fetchData(pagination: false, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cellTableViewCell else { return UITableViewCell() }
        cell.cellTitleLabel.text = data[indexPath.row].title
        cell.cellCountLabel.text = "👁 \(openCounts[indexPath.row])"
        cell.cellImageView.loadFrom(URLAddress: data[indexPath.row].urlToImage)
        return cell
    }
    

    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            guard !apiCaller.isPaginating else { return }
            count += 1
            parameters["page"] = String(count)
            setupURL()
            let additionalCounts = [Int](repeating: 0, count: 20)
            self.openCounts += additionalCounts
            self.tableView.tableFooterView = createSpinnerFooter()
            apiCaller.fetchData(pagination: true) { [weak self] result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                
                switch result {
                case .success(let moreData):
                    self?.data.append(contentsOf: moreData)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            openCounts[indexPath.row] += 1
            vc.detailItem = data[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

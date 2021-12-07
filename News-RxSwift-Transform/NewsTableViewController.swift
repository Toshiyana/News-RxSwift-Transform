//
//  NewsTableViewController.swift
//  News-RxSwift-Transform
//
//  Created by Toshiyana on 2021/12/07.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        
        populateNews()
        
        tableView.register(ArticleTableViewCell.nib(), forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    private func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(displayP3Red: 47/255, green: 54/255, blue: 64/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func populateNews() {

        // don't use the below code by using extension ArticleList all in Article.swift
//        let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-12-06&sortBy=popularity&apiKey=06b76736facf4432bcfd15d554f2cb08")!
//        let resource = Resource<ArticleList>(url: url)
        
        
        // In the case of not using URLRequest+Extensions.swift (a little bit smaller code than the below code)
        
        URLRequest.load(resource: ArticleList.all)
            .subscribe(onNext: { [weak self] result in
                self?.articles = result.articles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

                
//                if let result = result {
//                    self?.articles = result.articles
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                }
            }).disposed(by: disposeBag)
        
        // In the case of not using URLRequest+Extensions.swift (shouldn't use to make codes maintainable)
//        Observable.just(url)
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//
//                // rx: this extension can be used in RxCocoa
//                // return observable data (not data)
//                return URLSession.shared.rx.data(request: request)
//            }.map { data -> [Article]? in
//                // Decode json data
//                return try? JSONDecoder().decode(ArticleList.self, from: data).articles
//            }.subscribe(onNext: { [weak self] articles in
//
//                // Bind tableView
//                if let articles = articles {
//                    self?.articles = articles
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell does not exist")
            // return UITableViewCell()
        }
        
        cell.configure(
            title: articles[indexPath.row].title,
            description: articles[indexPath.row].description ?? ""
        )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 80
        return UITableView.automaticDimension
    }
}

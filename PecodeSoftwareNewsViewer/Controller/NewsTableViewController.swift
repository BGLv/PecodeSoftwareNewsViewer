//
//  NewsTableViewController.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/11/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var articles: [Article]?
    
    private var category: String?
    private var country: String = "ua"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableHeaderView = UIView()
        tableView.estimatedSectionHeaderHeight = 50
        
        let newsService = NewsService()
        newsService.getTopNews { [weak self] (articles) in
            self?.articles = articles?.sorted(by: { (earlierAricle, laterArticle) -> Bool in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat="yyyy-MM-dd'T'HH:mm:ss'Z'"
                let earlierArticleDate = dateFormater.date(from: earlierAricle.publishedAt!)
                let laterArticleDate = dateFormater.date(from: laterArticle.publishedAt!)
                let distanceBetweenDates = laterArticleDate?.timeIntervalSince(earlierArticleDate!)
                if distanceBetweenDates! <= 0.0 {
                    return false
                }else{
                    return true
                }
            })
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRows = self.articles?.count ?? 0
        return numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        
        // Configure the cell...
        cell.article=articles?[indexPath.row]
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func selectCategory(_ sender: Any) {
        /*let categorys = ["entertaiment","general","health","science","sports","technology"]*/
        
        let actionSelectCategorySheet = UIAlertController(title: "Filter option", message: "Please select filtered category", preferredStyle: .actionSheet)
        
        let entertaimentSelectedAction = UIAlertAction(title: "entertaiment", style: .default) { [weak self] (action) in
            self?.category = "entertaiment"
        }
        
        let generalSelectedAction = UIAlertAction(title: "general", style: .default) { [weak self] (action) in
            self?.category = "general"
        }
        
        let healthSelectedAction = UIAlertAction(title: "health", style: .default) { [weak self] (action) in
            self?.category = "health"
        }
        
        let scienceSelectedAction = UIAlertAction(title: "science", style: .default) { [weak self] (action) in
            self?.category = "science"
        }
        
        let sportsSelectedAction = UIAlertAction(title: "sports", style: .default) { [weak self] (action) in
            self?.category = "sports"
        }
        
        let technologySelectedAction = UIAlertAction(title: "technology", style: .default) { [weak self] (action) in
            self?.category = "technology"
        }
        
        let cancel = UIAlertAction(title: "Reset", style: .cancel) { [weak self] (action) in
            self?.category = nil
        }
        
        actionSelectCategorySheet.addAction(entertaimentSelectedAction)
        actionSelectCategorySheet.addAction(generalSelectedAction)
        actionSelectCategorySheet.addAction(healthSelectedAction)
        actionSelectCategorySheet.addAction(scienceSelectedAction)
        actionSelectCategorySheet.addAction(sportsSelectedAction)
        actionSelectCategorySheet.addAction(technologySelectedAction)
        actionSelectCategorySheet.addAction(cancel)
        
        self.present(actionSelectCategorySheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCountrySegue" {
            if let selectCountryController = segue.destination as? SelectCountryViewController{
                selectCountryController.pickerViewInfoArray = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
                let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
                let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
                
                selectCountryController.pickerViewSelectedCountry = settingsDictionary["country"]!
            }
        }
    }
    
}

//
//  NewsTableViewController.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/11/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    @IBOutlet weak var countryButton: UIBarButtonItem!
    @IBOutlet weak var sourcesButton: UIBarButtonItem!
    
    ////Data from API
    private var articles: [Article]?
    private var sources: [Source]?
    ////////////////////
    
    private var category: String?
    private var country: String?
    private var sourceID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchBar.delegate = self
        
        tableView.tableHeaderView = UIView()
        tableView.estimatedSectionHeaderHeight = 50
        
        reloadDataFromApi(stringToSearch: nil)
        
        let newsService = NewsService()
        newsService.getAvaliableSources { (sources) in
            self.sources=sources
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
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let generalSelectedAction = UIAlertAction(title: "general", style: .default) { [weak self] (action) in
            self?.category = "general"
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let healthSelectedAction = UIAlertAction(title: "health", style: .default) { [weak self] (action) in
            self?.category = "health"
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let scienceSelectedAction = UIAlertAction(title: "science", style: .default) { [weak self] (action) in
            self?.category = "science"
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let sportsSelectedAction = UIAlertAction(title: "sports", style: .default) { [weak self] (action) in
            self?.category = "sports"
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let technologySelectedAction = UIAlertAction(title: "technology", style: .default) { [weak self] (action) in
            self?.category = "technology"
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
        }
        
        let cancel = UIAlertAction(title: "Reset", style: .cancel) { [weak self] (action) in
            self?.category = nil
            self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
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
                if let country = country {
                    selectCountryController.pickerViewSelectedCountry = country
                }else{
                    let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
                    let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
                    
                    selectCountryController.pickerViewSelectedCountry = settingsDictionary["country"]!
                }
                selectCountryController.completion = {
                    [weak self](countryFromSelector:String) -> Void in
                    self?.country=countryFromSelector
                    self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
                }
            }
        }
        
        if segue.identifier == "selectSourceSegue" {
            if let selectSourceController = segue.destination as? SelectSourceViewController{
                selectSourceController.sources = self.sources
                selectSourceController.pickerViewSelectedSourceID = self.sourceID
                selectSourceController.completion = {
                    [weak self](sourceIDFromSelector: String?) -> Void in
                    self?.sourceID=sourceIDFromSelector
                    if nil == self?.sourceID{
                        self?.countryButton.isEnabled = true
                        self?.categoryButton.isEnabled = true
                    }else{
                        self?.countryButton.isEnabled = false
                        self?.categoryButton.isEnabled = false
                    }
                    self?.reloadDataFromApi(stringToSearch: self?.searchBar.text)
                }
            }
        }
    }
    
    private func reloadDataFromApi(stringToSearch: String?){
        
        let newsService = NewsService()
        //newsService.country = country
        newsService.getTopNews(byString:stringToSearch, byCategory: self.category, byCountry: self.country, fromSourceID: self.sourceID) { [weak self] (articles) in
            self?.articles = articles?.sorted(by: { (earlierAricle, laterArticle) -> Bool in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat="yyyy-MM-dd'T'HH:mm:ss'Z'"
                if let earlierArticleDate = dateFormater.date(from: earlierAricle.publishedAt!),
                    let laterArticleDate = dateFormater.date(from: laterArticle.publishedAt!){
                    let distanceBetweenDates = laterArticleDate.timeIntervalSince(earlierArticleDate)
                    if distanceBetweenDates <= 0.0 {
                        return false
                    }else{
                        return true
                    }
                }else{return false}
            })
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.reloadDataFromApi(stringToSearch: self.searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        ArticleTableViewCell.clearArticlesImagesCache()
    }
    
}

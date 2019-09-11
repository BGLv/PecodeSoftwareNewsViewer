//
//  NewsTableViewController.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/11/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var articles: [Article]?
    private var imagesDictionary: [Int:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let newsService = NewsService()
        newsService.getTopNews { [weak self] (articles) in
            self?.articles = articles
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
        
        if let imageForCellFromDict = self.imagesDictionary[indexPath.row]{
            cell.articleImage.image=imageForCellFromDict
            //cell.loadIndicator.stopAnimating()
        }else{
            if let imageURL = URL(string: (articles?[indexPath.row].imageURL)!){
                let imageDownloadSession = URLSession(configuration: URLSessionConfiguration.default)
                let task=imageDownloadSession.dataTask(with: imageURL) { [weak self] (data, response, error) in
                    guard let data = data, nil==error else {return}
                    self?.imagesDictionary[indexPath.row]=UIImage(data: data)?.resized(toWidth: 200)
                    DispatchQueue.main.async {[weak self] in
                        //self?.tableView.reloadData()
                        cell.articleImage.image = self?.imagesDictionary[indexPath.row]
                        cell.loadIndicator.stopAnimating()
                    }
                    
                }
                task.resume()
                
            }
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

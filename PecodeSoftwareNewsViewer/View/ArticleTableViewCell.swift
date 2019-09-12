//
//  ArticleTableViewCell.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/11/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    private static var imagesDictionary: [String:UIImage] = [:]
    
    var article: Article?{
        didSet{
            updateUI()
        }
    }
    
    static func clearArticlesImagesCache() {
        ArticleTableViewCell.imagesDictionary = [:]
    }
    
    private func updateUI(){
        titleLabel.text=article?.title
        descriptionLabel.text=article?.description
        authorLabel.text="Author: \(article?.author ?? "unknown")"
        dateLabel.text="Date:\(article?.publishedAt ?? "unknown")"
        if let optSourceStr = article?.source?["name"]{
            if let sourceStr = optSourceStr{
                sourceLabel.text="Source: \(sourceStr)"
            }
        }
        
       if let strUrlToImage = article?.imageURL{
        if let imageFromDictionary = ArticleTableViewCell.imagesDictionary[strUrlToImage]{
            self.articleImage.image = imageFromDictionary
        }else{
            if let imageURL = URL(string: strUrlToImage){
                let urlSession = URLSession(configuration: URLSessionConfiguration.default)
                let task = urlSession.dataTask(with: imageURL) { (data, response, error) in
                    guard let data = data, nil==error else {
                    ArticleTableViewCell.imagesDictionary[strUrlToImage]=UIImage(named: "failed")?.resized(toWidth: 200.0)

                        DispatchQueue.main.async {
                            self.articleImage?.image = UIImage(named: "failed")?.resized(toWidth: 200.0)
                            self.loadIndicator.stopAnimating()
                        }
                        return
                        
                    }
                    
                ArticleTableViewCell.imagesDictionary[strUrlToImage]=UIImage(data: data)?.resized(toWidth: 200.0)

                    DispatchQueue.main.async {
                        //self.articleImage?.clipsToBounds = true
                        //self.articleImage?.contentMode = .scaleAspectFit
                        //self.articleImage?.image = nil
                        self.articleImage?.image = UIImage(data: data)?.resized(toWidth: 200.0)
                        self.loadIndicator.stopAnimating()
                    }
                }
                task.resume()
            }

        }
        
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
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

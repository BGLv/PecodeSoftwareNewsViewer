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
    
    
    var article: Article?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        titleLabel.text=article?.title
        descriptionLabel.text=article?.description
        authorLabel.text="Author: \(article?.author ?? "unknown")"
        if let optSourceStr = article?.source?["name"]{
            if let sourceStr = optSourceStr{
                sourceLabel.text="Source: \(sourceStr)"
            }
        }
        
       /* if let strUrlToImage = article?.imageURL{
            if let imageURL = URL(string: strUrlToImage){
                let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    guard let data = data, nil==error else {return}
                    DispatchQueue.main.async {
                        self.imageView?.clipsToBounds = true
                        self.imageView?.contentMode = .scaleAspectFit
                        self.imageView?.image = nil
                        self.imageView?.image = UIImage(data: data)?.resized(toWidth: 70.0)
                    }
                }
                task.resume()
            }
            
        }*/
        
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



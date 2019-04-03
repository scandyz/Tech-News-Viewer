//
//  ArticleTableViewController.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 02/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {
    
    var article: Article?
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let url = URL(string: (self?.article?.urlToImage)!) {
                if let data = try? Data(contentsOf: url) {
                    self?.showArticle(data: data)
                    return
                }
            }
            self?.showError()
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func showArticle(data: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.articleImageView.image = UIImage(data: data)
            self?.title = self!.article?.source.name
            self?.titleLabel.text = self!.article?.title
            self?.descriptionTextView.text = self!.article?.description
            self?.authorLabel.text = self!.article?.author
        }
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "Check your connection and try again!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSegue" {
                let dvc =  segue.destination as! WebViewController
            dvc.urlString = (article?.url)!
        }
    }

}

//
//  NewsTableViewController.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 02/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=96389ba7f6c2416cbddfe9bf4e679d3a"
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            self?.showError()
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonArticles = try? decoder.decode(Articles.self, from: json) {
            articles = jsonArticles.articles
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "Check your connection and try again!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticleTableViewCell

        cell.headlineLabel.text = articles[indexPath.row].title
        cell.authorLabel.text = "Author: \(articles[indexPath.row].author)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let save = UITableViewRowAction(style: .default, title: "Save") { (action, indexPath) in
            //пытаемся получить контекст
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                //создаем сущность нашей статьи
                let article = SavedArticle(context: context)
                //задаем все свойства нашей сущности
                article.articleDescription = self.articles[indexPath.row].description
                article.author = self.articles[indexPath.row].author
                article.title = self.articles[indexPath.row].title
                article.source = self.articles[indexPath.row].source.name
                article.url = self.articles[indexPath.row].url
                article.urlToImage = self.articles[indexPath.row].urlToImage
                //пытаемся сохранить контекст
                do {
                    try context.save()
                    print("Article was successfully saved")
                } catch let error as NSError {
                    print("Saving Error \(error)")
                }
            }

        }
        save.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return [save]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articleSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc =  segue.destination as! ArticleTableViewController
                dvc.article = self.articles[indexPath.row]
            }
        }
    }


}

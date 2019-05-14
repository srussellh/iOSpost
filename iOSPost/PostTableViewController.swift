//
//  TableViewController.swift
//  iOSPost
//
//  Created by Bobba Kadush on 5/13/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostController.shared.fetchPosts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    @objc func refresh(sender:AnyObject) {
        PostController.shared.fetchPosts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = PostController.shared.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        return cell
    }
    
    func presentNewPostAlert(){
        let alertController = UIAlertController(title: "Adding Alert", message: "Whats on your mind?", preferredStyle: .alert)
       alertController.addTextField { (textField) in
            textField.placeholder = "userName"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "message"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let username = alertController.textFields?[0].text,
                let post = alertController.textFields?[1].text else {return}
            PostController.shared.addNewPostWith(username: username, Text: post, completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        self.present(alertController, animated: true, completion: nil)
        }
}
//comment


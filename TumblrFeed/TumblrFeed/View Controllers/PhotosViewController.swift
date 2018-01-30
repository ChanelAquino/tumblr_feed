//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Chanel Aquino on 1/29/18.
//  Copyright © 2018 Chanel Aquino. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // ---------------------------------
    // outlets
    // ---------------------------------
    
    @IBOutlet weak var tableView: UITableView! // outlet for posts
    @IBOutlet weak var photoCell: PhotoCell!        // outlet for photos
    
    // ---------------------------------
    // properties
    // ---------------------------------
    var posts: [[String: Any]] = [] // array of dictionaries from blog posts
    
    
    // ---------------------------------
    // viewDidLoad
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure tableView properties
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // TODO: Reload the table view
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    // ---------------------------------
    // didReceiveMemoryWarning
    // ---------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ---------------------------------
    // numberOfRows in Section
    //      set number of rows
    // ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // ---------------------------------
    // cellForRowAt
    //      return the cell for each row
    // ---------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.textLabel?.text = "This is row \(indexPath.row)"
        
        let post = posts[indexPath.row] // pull out a single post from posts array
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // TODO: Get the photo url
            // First photo in array
            let photo = photos[0]
            // originalSize dictionary from photo
            let originalSize = photo["original_size"] as! [String: Any]
            // get url from the originalSize dictionary from photo
            let urlString = originalSize["url"] as! String
            // creates a url
            let url = URL(string: urlString)
            
            // retrieve image from url
            cell.photoImageView.af_setImage(withURL: url!)
        }

        return cell
    }


    // ---------------------------------
    // cellForRowAtIndexPath
    //      dequeque the cell
    // ---------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

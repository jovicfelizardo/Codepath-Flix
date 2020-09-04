//
//  MoviesViewController.swift
//  flixster
//
//  Created by Kanchanak Khat on 7/29/20.
//  Copyright © 2020 Kanchanak Khat. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {//-> we want this viewcontroller to work with the table view Step1
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()//run the first time that the screen comes out
        tableView.dataSource = self  //step2
        tableView.delegate = self
        
       
       // print("Hello")
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]//dataDictionary: when the thing has fetched the data back, it will store into dataDictionary
            //print(dataDictionary)
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.tableView.reloadData()//reload data after right after the view controller shows up
            print(dataDictionary)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()


    }
    //step3
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cellForRowAt: for this particular row, give me the cell
        /*
        let cell = UITableViewCell()
        cell.textLabel?.text = "row: \(indexPath.row)"
        return cell
         */
        //dequeueReusableCell: if the another cell is off-screen, gives me
        //that recycle cell otherwise, give me a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell//recycle cell after the cells run out of the screen
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
       
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        /*getting url from the api*/
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!) //pod's library
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

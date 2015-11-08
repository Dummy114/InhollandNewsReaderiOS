//
//  FavoriteViewController.swift
//  Opdracht5
//
//  Created by Christiaan Kiewiet on 05-11-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage
class FavoriteViewController: UITableViewController {

    var _api : AlamofireApiService!
    var _user : User?
    var _userAuth : UserAuth?
    var _articles : [Article] = []
    var _loading : MBProgressHUD = MBProgressHUD()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Favorieten"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        self._api = Extensions.getAppDelegate()._api
        self._user = Extensions.getUser()
        
        if self._user != nil && _userAuth == nil {
            //login at API
            self.getUserAuth()
        }
        else if self._user != nil && _userAuth != nil{
            self.fetchLikedArticles()
        }
        else {
            self._articles = []
            self.tableView.reloadData()
            let alertController = UIAlertController(title: "U bent niet ingelogd", message: "Ga naar de main pagina om in te loggen", preferredStyle: .Alert)
            let cancel = UIAlertAction(title:"Ok", style: .Cancel){(_) in }
            alertController.addAction(cancel)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func setupLoading(){
        self._loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self._loading.mode = MBProgressHUDMode.Indeterminate
        self._loading.labelText = "Loading..."
    }
    func removeLoading(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    private func getUserAuth(){
        self._userAuth = Extensions.getAppDelegate().getUserAuth()
        self.fetchLikedArticles()
    }
    
    private func fetchLikedArticles(){
        //reset
        self._articles = []
        self.tableView.reloadData()
        self._api.GetLikedArticles(self._userAuth!, callbackSuccess: { (results) -> () in
            
            let _result: ResultModel = results
            self._articles.appendContentsOf(_result.Results)
            self.tableView.reloadData()
            self.removeLoading()
            }) { (results) -> () in
                self.showErrorBox()
        }
    }
    
    private func showErrorBox(){
        let alertController = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Ok", style: .Default){(_) in }
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return _articles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Article", forIndexPath: indexPath) as! TableViewCell
        
        cell.Title.text = _articles[indexPath.row].Title
        
        Alamofire.request(.GET, _articles[indexPath.row].Image).responseImage {response in
            if let image = response.result.value {
                cell.DetailImage.image = image
            }
        }
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let _indexPath = tableView.indexPathForSelectedRow
        let _article = _articles[(_indexPath?.item)!]
        if segue.identifier == "goToDetail" {
            if let desViewController = segue.destinationViewController as? DetailViewController{
                desViewController.setArticle(_article)
            }
        }
    }


}

//
//  TableViewController.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage

class TableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var nextId: Int = 0
    
    var _api : AlamofireApiService!
    var refresh : UIRefreshControl!
    var _articles : [Article] = []
    var UserToken : UserAuth?
    var _loading : MBProgressHUD = MBProgressHUD()
    var pickerdata = ["test1", "test2", "test3"]
    var _imageCache : NSCache?
    var _isLoading : Bool?
    override func viewDidLoad() {
        _api = Extensions.getAppDelegate()._api
        super.viewDidLoad()
        self.setupRefresh()
        self._isLoading = false
        self.checkLogin()
        self._imageCache = NSCache()
        
        let menu_item_button = UIButton(type: UIButtonType.InfoLight)
        menu_item_button.addTarget(self, action: "OnMenuClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let menu_item = UIBarButtonItem(customView: menu_item_button)
        /*let feed_item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "OnFeedsClicked")*/
        
        self.navigationItem.rightBarButtonItem = menu_item
        //self.navigationItem.leftBarButtonItem = feed_item
        self.title = "Artikelen"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerdata.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerdata[row]
    }
    
    /*func OnFeedsClicked(){
        
        let feedsSelector = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        feedsSelector.delegate = self
        feedsSelector.dataSource = self
        feedsSelector.showsSelectionIndicator = true
        feedsSelector.backgroundColor = UIColor.clearColor()
        
        let alertController = UIAlertController()
        alertController.view.addSubview(feedsSelector)
        self.presentViewController(alertController, animated: true, completion: nil)

    }*/
    
    func checkLogin(){
        let _user = Extensions.getUser()
        if _user != nil{
            self.loginUser(_user!)
        }
        else{
            self.setupLoading()
            self.fetchList(nil)
        }
    }
    
    func setupRefresh(){
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "")
        self.refresh.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)

    }

    func setupLoading(){
        self._loading = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self._loading.mode = MBProgressHUDMode.Indeterminate
        self._loading.labelText = "Loading..."
    }
    func removeLoading(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    func refresh(sender: AnyObject){
        self.fetchList(self.UserToken)
    }
    
    private func fetchList(userauth: UserAuth?){
        if self._isLoading == false {
            self._isLoading = true
            self._api.GetArticles(userauth, callbackSuccess: { (results) -> () in
            self._articles = []
            let _result: ResultModel = results
            self._articles.appendContentsOf(_result.Results)
            self.nextId = _result.NextId
            self.tableView.reloadData()
            self.removeLoading()
            self.refresh.endRefreshing()
                self._isLoading = false;
            }) { (fail) -> () in
                self.removeLoading()
                self.showErrorBox()
            }
        }
    }
    
    private func fetchNextList(userauth: UserAuth?){
        if self._isLoading == false {
            self._isLoading = true
            self._api.GetNextArticles(self.nextId, isLoggedIn: userauth, callbackSuccess: { (results) -> () in
            let _result: ResultModel = results
            self._articles.appendContentsOf(_result.Results)
            self.nextId = _result.NextId
            self.tableView.reloadData()
            self._isLoading = false;
            }, callbackFailure: { (fail) -> () in
                self.showErrorBox()
            })
        }
    }
    
    func OnMenuClicked(sender: UIBarButtonItem){
        if self.UserToken == nil{
            let alertController = UIAlertController(title: "Log in", message: "Please input your username & password:", preferredStyle: .Alert)
            
            var inputNameField: UITextField?
            var inputPassWordField: UITextField?
            
            let confirm = UIAlertAction(title: "Log in", style: .Default){(_) in
                let _userName : String = (inputNameField?.text)!
                let _passWord : String = (inputPassWordField?.text)!
                if _passWord != "" && _userName != ""{
                    let _user = User(username: _userName, password: _passWord)
                    self.loginUser(_user)
                }
            }
            let cancel = UIAlertAction(title:"Cancel", style: .Cancel){(_) in }
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                inputNameField = textField
                textField.placeholder = "Username"
            }
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                inputPassWordField = textField
                textField.placeholder = "Password"
                textField.secureTextEntry = true
            }
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Logout", message: "Click to logout", preferredStyle: .Alert)
            
            let cancel = UIAlertAction(title:"Cancel", style: .Cancel){(_) in }
            let logout = UIAlertAction(title: "Logout", style: .Default){(_) in
                self.UserToken = nil
                //self.changeFavoriteBar(false)
                Extensions.deleteUser()
                self.fetchList(nil)
            }
            alertController.addAction(logout)
            alertController.addAction(cancel)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    /*func changeFavoriteBar(turnedOn : Bool){
        let controller : TabBarControllerFavorites = Extensions.getAppDelegate().getViewController("TabBarControllerFavorites") as! TabBarControllerFavorites
        controller.changeFavoriteBar(turnedOn)
        
    }*/
    
    private func showErrorBox(){
        let alertController = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Ok", style: .Default){(_) in }
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    private func showLoginErrorBox(){
        let alertController = UIAlertController(title: "Error", message: "Verkeerde gegevens", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Ok", style: .Default){(_) in }
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loginUser(user: User){
        self.setupLoading()
        self._api.LoginUser(user, callBackSuccess: { (results) -> () in
            let _userAuth : UserAuth = results
            
            //save user
            Extensions.saveUserName(user)
            self.UserToken = _userAuth
            
            //reset article list
            self.fetchList(_userAuth)
            
            //set userauth
            Extensions.getAppDelegate().setUserAuth(_userAuth)
            
            //enable favoritebar
            //self.changeFavoriteBar(true)
            }, callbackFailure: { (results) -> () in
                self.removeLoading()
                let status = Reach().connectionStatus()
                switch status {
                case .Offline, .Unknown:
                    self.showErrorBox()
                case .Online(ReachabilityType.WWAN), .Online(ReachabilityType.WiFi):
                    self.showLoginErrorBox()
                }
        })

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
        
        //cache the image
        let imageUrl = _articles[indexPath.row].Image
        if let image = self._imageCache?.objectForKey(imageUrl) as? UIImage{
            cell.DetailImage.image = image
        } else{
            cell.DetailImage.image = nil
            Alamofire.request(.GET, _articles[indexPath.row].Image).responseImage {response in
                if let image = response.result.value {
                    cell.DetailImage.image = image
                    self._imageCache?.setObject(image, forKey: imageUrl)
                }
            
            }
        }
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        cell.LikeButton.hidden = self.UserToken != nil ? false : true
        cell.DislikeButton.hidden = self.UserToken != nil ? false : true
        cell.LikeButton.tag = indexPath.row
        cell.DislikeButton.tag = indexPath.row
        
        cell.DislikeButton.addTarget(self, action: "DislikeArticle:", forControlEvents: .TouchUpInside)
        cell.LikeButton.addTarget(self, action: "LikeArticle:", forControlEvents: .TouchUpInside)
        
        if self.UserToken != nil {
            cell.FavoriteStar.hidden = _articles[indexPath.row].IsLiked ? false : true
            cell.DislikeButton.enabled = _articles[indexPath.row].IsLiked ? true : false
            cell.LikeButton.enabled = _articles[indexPath.row].IsLiked ? false : true
        }
        else{
            cell.FavoriteStar.hidden = true
            
        }
        return cell
    }
    
    func LikeArticle(sender: UIButton){
        let _index = NSIndexPath(forRow: sender.tag, inSection: 0)
        let _id = self._articles[sender.tag].Id
        self._api.LikeArticle(_id, userauth: self.UserToken!, callBackSuccess: { (results) -> () in
            let cell = self.tableView.cellForRowAtIndexPath(_index) as! TableViewCell;
            cell.FavoriteStar.hidden = false;
            cell.LikeButton.enabled = false;
            cell.DislikeButton.enabled = true;
            }) { (results) -> () in
                self.showErrorBox()
        }
    }
    
    func DislikeArticle(sender: UIButton){
        let _index = NSIndexPath(forRow: sender.tag, inSection: 0)
        let _id = self._articles[sender.tag].Id
        self._api.DisLikeArticle(_id, userauth: self.UserToken!, callBackSuccess: { (results) -> () in
            let cell = self.tableView.cellForRowAtIndexPath(_index) as! TableViewCell;
            cell.FavoriteStar.hidden = true;
            cell.LikeButton.enabled = true
            cell.DislikeButton.enabled = false;
            }) { (results) -> () in
               self.showErrorBox()
        }
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row >= self._articles.count - 5){
            if UserToken != nil{
                self.fetchNextList(self.UserToken)
            }
            else{
                self.fetchNextList(nil)
            }
        }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

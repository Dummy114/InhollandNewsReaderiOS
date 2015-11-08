//
//  DetailViewController.swift
//  Opdracht5
//
//  Created by Christiaan Kiewiet on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DetailViewController: UIViewController {
    
    var _article : Article?
    
    @IBOutlet weak var ReadMore: UIButton!
    @IBOutlet weak var Related: UIStackView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var Titel: UILabel!
    @IBOutlet weak var Desc: UILabel!
    @IBOutlet weak var DetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Titel.text = _article?.Title
        self.Desc.text = _article?.Summary
        self.DateLabel.text = Extensions.parseToNSdate((_article?.PublishDate)!)
        
        Alamofire.request(.GET, (_article?.Image)!).responseImage {response in
            if let image = response.result.value {
                self.DetailImage.image = image
            }
            
        }
        for string in (_article?.Related)!{
            let _label : UILabel = UILabel()
            _label.numberOfLines = 0
            _label.font = UIFont(name: _label.font.fontName, size:12)
            _label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            _label.text = string
            
            self.Related.addArrangedSubview(_label)
        }
        self.ReadMore.addTarget(self, action: "OpenUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let share_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "OnShareClicked")
        
        self.navigationItem.rightBarButtonItem = share_button
        
    }
    
    func OnShareClicked(){
        let url : NSURL = NSURL(string: (_article?.Url)!)!
        let title : String = (_article?.Title)!
        let objects = [title, url]
        let activityVC = UIActivityViewController(activityItems: objects, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func OpenUrl(sender: UIButton){
        UIApplication.sharedApplication().openURL(NSURL(string: (_article?.Url)!)!)
    }
    
    func setArticle(article: Article){
       _article = article
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

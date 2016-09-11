//
//  NewsVC.swift
//  Society2
//
//  Created by George Atuan on 9/4/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTxtField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 358
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
            
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snapshot {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                }
                print("POST COUNT \(self.posts.count)")
            }
            self.tableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl  {
                img = NewsVC.imageCache.objectForKey(url) as? UIImage
            }
            cell.configureCell(post, img: img)
            return cell
        } else {
            return PostCell()
        }
             
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postTxtField.text where txt != "" {
            if let img = imageSelectorImage.image where imageSelected == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imageData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)
                
                Alamofire.upload(.POST, url, multipartFormData: { multiPartFormData in
                    
                    multiPartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multiPartFormData.appendBodyPart(data: keyData!, name: "key")
                    multiPartFormData.appendBodyPart(data: keyJSON!, name: "format")
                    
                }) { encodingResults in
                    switch encodingResults {
                    case .Success(let upload, _,_):
                        upload.responseJSON(completionHandler: { request, response, result in
                            if let info = result.value as? Dictionary<String, AnyObject> {
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    if let imgLink = links["image_link"] as? String {
                                        print("LINK: \(imgLink)")
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                        })
                    case .Failure(let error):
                        print(error)
                    }
                    
                }
            } else {
                postToFirebase(nil)
            }
        }
    }
    func postToFirebase(imgUrl: String?) {
        var post: Dictionary<String, AnyObject> = [
        "description": postTxtField.text!,
        "likes": 0]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postTxtField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
}

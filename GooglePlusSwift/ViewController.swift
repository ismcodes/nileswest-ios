//
//  ViewController.swift
//  GooglePlusSwift
//
//  Created by Fernando Olivares on 10/15/14.
//  Copyright (c) 2014 Spiffy. All rights reserved.
//

import UIKit

//G+
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ViewController: UIViewController, GPPSignInDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //table stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        label.text = "Hello Man"
        cell.addSubview(label)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    var email = ""
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var textLabel: UITextField!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            textLabel.text = "Accept selected";
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://nileswest.herokuapp.com/change_status")!)
            request.HTTPMethod = "POST"
            
            let name = ""
            let subject = ""
            
            let postString = "email="+email+"&secret_key=DEVISING&name="+name+"&subject="+subject
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                println("response = \(response)")
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString = \(responseString)")
            }
            task.resume()

        case 1:
            textLabel.text = "Decline selected";
        default:
            break;
        }

    }
    
    
    
    @IBAction func switchClicked(sender: UISwitch) {
        
            println("switch has been clicked")
        
            let request = NSMutableURLRequest(URL: NSURL(string: "http://nileswest.herokuapp.com/change_status")!)
            request.HTTPMethod = "POST"
            var status = 2
            if sender.on{
                status = 1
            }

            let postString = "email="+email+"&secret_key=DEVISING&status="+String(status)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                println("response = \(response)")
                
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString = \(responseString)")
            }
            task.resume()
       
    }
    
    class func addToScreen(nameAndSubject: String){
        
        
    }
    
    
    var signIn : GPPSignIn?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
                
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "492971078631-jc36td2n8vds9tcscacuso3gvd0kg7l7.apps.googleusercontent.com"
        signIn?.scopes = [
            kGTLAuthScopePlusMe,
            kGTLAuthScopePlusUserinfoEmail]
        signIn?.delegate = self
        signIn?.authenticate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: G+
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        println("======")
        println(auth.userEmail)
        email = auth.userEmail
        println("======")
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        
        // Sets up Mobile Push Notification
        let readAction = UIMutableUserNotificationAction()
        readAction.identifier = "READ_IDENTIFIER"
        readAction.title = "Read"
        readAction.activationMode = UIUserNotificationActivationMode.Foreground
        readAction.destructive = false
        readAction.authenticationRequired = true
        
        let deleteAction = UIMutableUserNotificationAction()
        deleteAction.identifier = "DELETE_IDENTIFIER"
        deleteAction.title = "Delete"
        deleteAction.activationMode = UIUserNotificationActivationMode.Foreground
        deleteAction.destructive = true
        deleteAction.authenticationRequired = true
        
        let ignoreAction = UIMutableUserNotificationAction()
        ignoreAction.identifier = "IGNORE_IDENTIFIER"
        ignoreAction.title = "Ignore"
        ignoreAction.activationMode = UIUserNotificationActivationMode.Foreground
        ignoreAction.destructive = false
        ignoreAction.authenticationRequired = false
        
        let messageCategory = UIMutableUserNotificationCategory()
        messageCategory.identifier = "MESSAGE_CATEGORY"
        messageCategory.setActions([readAction, deleteAction], forContext: UIUserNotificationActionContext.Minimal)
        messageCategory.setActions([readAction, deleteAction, ignoreAction], forContext: UIUserNotificationActionContext.Default)
        
        let types = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        let notificationSettings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: messageCategory))
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
            if identifier == "READ_IDENTIFIER" {
                println("User selected 'Read'")
                
            } else if identifier == "DELETE_IDENTIFIER" {
                println("User selected 'Delete'")
            }
            
            completionHandler()
        }
        
    }
    
    func didDisconnectWithError(error: NSError!) {
        println(error.localizedDescription)
        
    }
    
    
}


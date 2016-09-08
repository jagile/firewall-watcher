//
//  AppDelegate.swift
//  firewall-watcher
//
//  Created by Anton Dumler on 26/08/16.
//  Copyright © 2016 Anton Dumler. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    var status: Bool = false
    
    var timer: NSTimer? = nil
    
    var doCheck: Bool = true

    var firewallStatus: Bool? = nil
    
    var statusBarButtonImage = NSImage(named: "StatusBarButtonImage")

    var statusBarUnavailableImage = NSImage(named: "StatusBarUnavailableImage")

    let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = statusBarUnavailableImage
            button.action = #selector(toggleChecking)
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.checkTarget), userInfo: nil, repeats: true)
        timer?.tolerance = 2
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        timer?.invalidate()
    }

    func setTargetStatus(status: Bool) {
        firewallStatus = status
        if(status) {
            statusItem.button?.image = statusBarButtonImage
        } else {
            statusItem.button?.image = statusBarUnavailableImage
        }
    }
    
    func toggleChecking(sender: AnyObject) {
        //doCheck = !doCheck
    }
    
    func checkTarget() {
        if(!doCheck) {
            print("Target checking disabled by user click...")
            return
        }
        
        // ===================
        let mainURL = "https://www.google.de"
        print("Checking \(mainURL)...")
        
        let url = NSURL(string: mainURL)
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 5.0
        request.HTTPMethod = "GET" // POST OR PUT What you want
        //let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
        
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                //handle error
                print("Response error \(mainURL):\(error!.code) \(error!.localizedDescription)")
                self.setTargetStatus(false)
            } else {
                //let outputString : NSString = NSString(data:data!, encoding:NSUTF8StringEncoding)!
                print("Response \(mainURL): ok")
                self.setTargetStatus(true)
            }
            
        }
        dataTask.resume()
        // ===================
    }

}


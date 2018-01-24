//
//  PinDetailViewController.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/23.
//  Copyright © 2018年 harry. All rights reserved.
//

import UIKit
class PinDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var appDelegate: AppDelegate!
    var locations: [[String: AnyObject]]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        locations = appDelegate.locations
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print(locations.count)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinDetailCell")!
        let location = self.locations[(indexPath as NSIndexPath).row]
        print(location)
        let title = "\(location["firstName"]) \(location["lastName"])"
        print(title)
        let detail = "\(location["mediaURL"])"
        print(detail)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        return cell
    }
    
}

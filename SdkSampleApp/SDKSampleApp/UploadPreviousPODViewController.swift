//
//  UploadPreviousPODViewController.swift
//  SDKSampleApp
//
//  Created by davix on 11/2/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

@objc class UploadPreviousPODViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var connected : Bool = false
    var batches : [BatchObj] = []
    var count = 0
    
    @IBOutlet var podNumberLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    class func newInstance() -> UploadPreviousPODViewController{
        return UploadPreviousPODViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInAllBatches()
        self.setUpLabel()
    }
    
    func setUpLabel(){
        
        let count = self.batches.count
        self.podNumberLabel.text = String(count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadAllPodBtnClicked(_ sender: Any) {
        
        EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
        self.uploadAllPODBatches(batches: self.batches   ){
            dictionary, error in
            EZLoadingActivity.hide(true, animated: true)
            self.loadInAllBatches()
            self.setUpLabel()
            self.tableView.reloadData()
            self.presentUploadSuccessController()
        }

    }
    
    func loadInAllBatches() -> Bool{
        
        let service = BatchService()
        self.batches = service.loadNonUploadedBatches()
        return true
        
    }
    
    func uploadAllPODBatches(batches : [BatchObj], completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        //1)Pop array
        var dataArray = batches
        var batchObj = dataArray.popLast()
        //2)If nil we are done
        if batchObj == nil {
            completion(nil,nil)
        }else{
            //3)If not nil, call helper to upload and pass self as a call back
            let uploadHelper = UploadHelper.init()
            uploadHelper.uploadPODBatch(batchObj: batchObj!){
                dictionary, error in
                let batchService = BatchService()
                batchService.updateBatchUpdatedToTrue(num: (batchObj?.batchNumber)!)
                self.uploadAllPODBatches(batches: dataArray, completion: completion)
            }
        }
    }
     
    func presentUploadSuccessController(){
        
        let alertController = UIAlertController(title: "Upload Success", message:
            "Documents and POD Number uploaded to server successfully", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.batches.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        if( indexPath.item == 0){
            cell.textLabel?.text = "POD Number #"
        }else{
            var index = indexPath.item
            index -= 1
            let batch = self.batches[index]
            let text = batch.podNumber
            cell.textLabel?.text = text
        }
        return cell
        
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
}

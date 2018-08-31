//
//  TableViewController.swift
//  PhotoBooth
//
//  Created by Ravi on 30/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var phototableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib.init(nibName: String(describing: PhotoTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
        title = "Table View"
    }
    
    private let reuseIdentifier = "TableCell"
    private let thumbnailSize = CGSize(width: 80.0, height: 200.0)
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10.0, right: 10)
    private let photos = ["photo1","photo2","photo3","photo4","photo5"]
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Select Image to view in full size"
        label.backgroundColor =  UIColor.orange
        label.textColor=UIColor.blue
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor =  UIColor.red
        label.textColor=UIColor.green
        label.textAlignment = .right
        return label
    }

}
    
extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PhotoTableViewCell
        let fullSizedImage = UIImage(named:photos[indexPath.row] )
        cell.tableCell.image = fullSizedImage?.thumbnailOfSize(thumbnailSize)
        cell.cellLabel.text = photos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZoomedPhotoViewController()//nibName: "ZoomedPhotoViewController", bundle: nil)
        vc.photoName = photos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}





    func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
        
    }



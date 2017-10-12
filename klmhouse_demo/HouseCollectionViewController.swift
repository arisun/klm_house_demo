//
//  HouseCollectionViewController.swift
//  klmhouse_demo
//
//  Created by arindam_ghosh on 10/11/17.
//  Copyright © 2017 arindam_ghosh. All rights reserved.
//

import UIKit

class HouseCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate let reuseIdentifier = "collectionViewCell"

    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    fileprivate let itemsPerRow: CGFloat = 4

    var houseListsCollection : [[House]]!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setUpCollectionView()

    }


    private func setUpCollectionView(){

        collectionView.delegate = self

        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}


extension HouseCollectionViewController : UICollectionViewDataSource{

    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return houseListsCollection.count
    }

    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return houseListsCollection[section].count
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCustomCell

        let data = houseIndexPath(indexPath: indexPath)

        cell.houseImageView.image = UIImage(data: data.houseImageData! as Data)

        cell.houseLbl.text = data.houseName

        // Configure the cell
        return cell
    }
    
}

private extension HouseCollectionViewController {
    func houseIndexPath(indexPath: IndexPath) -> House {

        return houseListsCollection[(indexPath as NSIndexPath).section][(indexPath as IndexPath).row]

    }
}


extension HouseCollectionViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)

        let availableWidth = view.frame.width - paddingSpace

        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        let houseData = houseIndexPath(indexPath: indexPath)

        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        viewController.houseData = houseData

        self.navigationController?.pushViewController(viewController, animated: true)
    }

}


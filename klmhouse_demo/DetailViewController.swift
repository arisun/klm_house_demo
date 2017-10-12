//
//  DetailViewController.swift
//  klmhouse_demo
//
//  Created by arindam_ghosh on 10/12/17.
//  Copyright © 2017 arindam_ghosh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!

    @IBOutlet weak var houseImageView: UIImageView!

    @IBOutlet weak var lblHouse: UILabel!

    @IBOutlet weak var txtViewHouse: UITextView!

    var isCallFromMyCollection : Bool = false

    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var houseData : House?


    override func viewDidLoad() {

        super.viewDidLoad()

        setUpView()

        if !isCallFromMyCollection{
            setUpFavButton()
            
        }

    }

    private func setUpFavButton(){
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0.0, y: 0.0, width: 38.0, height: 40.0)
        infoButton.addTarget(self, action: #selector(favButtonSelected(_:)), for: .touchUpInside)
        infoButton.setImage(UIImage(named: "StarSelect"), for:.selected)
        infoButton.setImage(UIImage(named: "StarDeselect"), for:.normal)

        if (houseData?.isUserCollected)!{
            infoButton.isSelected = true
        }
        else{
            infoButton.isSelected = false
        }

        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = barButton

    }


    private func setUpView(){

        houseImageView.contentMode = .scaleAspectFit

        txtViewHouse.isEditable = false


        if let houseData = self.houseData{

            if let houseImageData = houseData.houseImageData{

                houseImageView.image = UIImage(data: houseImageData as Data)

            }

            lblHouse.text = houseData.houseName ?? ""

            if let desc = houseData.houseDescription{

                txtViewHouse.text = desc

                if let videoLink = houseData.houseVideoLink{
                    txtViewHouse.text.append("\n\nVideo: \(videoLink)")

                }

                if houseData.houseLatitude > 0 &&
                    houseData.houseLongitude > 0{

                    let urlStr = "http://maps.apple.com/?sll=\(houseData.houseLatitude),\(houseData.houseLongitude)&z=10&t=s"
                    txtViewHouse.text.append("\n\nMap: \(urlStr)")
                }
                
            }
            
        }
    }
    
}

extension DetailViewController{

    @objc fileprivate func favButtonSelected(_ sender: UIButton){
        if !(houseData?.isUserCollected)! {
            sender.isSelected = true

            houseData?.isUserCollected = true

            do{
                try context.save()
            }
            catch{
                fatalError("unable to save data")
            }

        }

    }
}

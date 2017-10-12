//
//  MasterViewController.swift
//  klmhouse_demo
//
//  Created by arindam_ghosh on 10/11/17.
//  Copyright © 2017 arindam_ghosh. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet var segmentedControl: UISegmentedControl!

    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    fileprivate var houseCollections : [House]?

    lazy var housesViewController: HouseCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "HouseCollectionViewController") as! HouseCollectionViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    fileprivate lazy var mycollectionViewController: MyCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyCollectionViewController") as! MyCollectionViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setUpView()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setUpView(){

        saveData()

        setUpSegmentedControl()

        updateView()

    }

    private func setUpSegmentedControl(){
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Houses", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "My Collections", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }


    func selectionDidChange(_ sender: UISegmentedControl) {

        updateView()
    }


}


extension MasterViewController{

    fileprivate func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: mycollectionViewController)
            add(asChildViewController: housesViewController)
        } else {
            remove(asChildViewController: housesViewController)
            add(asChildViewController: mycollectionViewController)
        }
    }


    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)

        // Configure Child View
        var viewrect = view.bounds
        viewrect.size.height -= 93.0
        viewrect.origin.y += 93.0
        viewController.view.frame = viewrect
        //viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }


    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}


extension MasterViewController{

    func saveData(){

        let userDefaults:UserDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "dataSaved") == nil{
            userDefaults.set(true, forKey: "dataSaved")
            userDefaults.synchronize()

            for i in 1...34{
                let house = House(context: context)
                house.houseID = Int64(i)
                house.houseName = "Demo House" + "\(i)"
                house.houseDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
                if let img = UIImage(named: "HouseImage"){
                    if let imgData = UIImageJPEGRepresentation(img, 7.0) as NSData?{
                        house.houseImageData = imgData
                    }
                }
                house.houseVideoLink = "https://www.youtube.com/watch?v=qLRKf-OmkO8"
                house.houseLatitude = 52.0012815
                house.houseLongitude = 4.367086500000028
                house.houseAddress = "Rotterdamseweg 196, 2628 AR Delft, Netherlands"
                do{
                    try context.save()
                }
                catch{
                    fatalError("unable to save data")
                }
                
            }
        }
        
    }
}


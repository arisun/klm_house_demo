//
//  GlobalClass.swift
//  klmhouse_demo
//
//  Created by arindam_ghosh on 10/12/17.
//  Copyright © 2017 arindam_ghosh. All rights reserved.
//

import UIKit


func loadData() -> [House]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var houseCollections:[House]?
    do {
        houseCollections = try context.fetch(House.fetchRequest())
    }catch {
        fatalError("Error fetching data from CoreData")

    }
    return houseCollections ?? []
}

func getModifiedList(houselist:[House] , isUserCollectionView collection: Bool) -> [[House]]{

    var ddArray = [[House]]()
    var array = [House]()
    var filterList : [House]?
    if collection{
        filterList = houselist.filter() {$0.isUserCollected == true}
    }
    else{
        filterList = houselist.filter() {$0.isUserCollected == false}
    }


    for (index,item) in (filterList?.enumerated())!{

        if index > 0 && index % 4 == 0{
            ddArray.append(array)
            array = [House]()
            array.append(item)
            continue
        }
        array.append(item)
    }

    if array.count > 0{
        ddArray.append(array)
    }

    return ddArray
}

//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Apple on 12/02/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var data = DataLoader()
    @Published var userData = [UserData]()
    var cityNameArr:[String] = []
    
    @IBOutlet var tab:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Data", into: context)
//        context.delete(newData)

        data.loadFromInternet{
            (data,error)  in
            if (error == nil){
            self.userData = (data)!

            for cityname in self.userData{
//                context.delete(newData)

             newData.setValue(cityname.timezone, forKey: "cityName")
                self.cityNameArr.append(cityname.timezone)
                
                do {

                    try context.save()
                    print("SAVED")
                }catch{}
            }
            DispatchQueue.main.async {
                self.tab.reloadData()
            }
            }else{
                
                // when user is offline
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
                
                        request.returnsObjectsAsFaults = false
                
                        do{
               
                            let results = try context.fetch(request)
                            if results.count > 0{
                                for result in results as! [NSManagedObject] {
                                    if let cityName = result.value(forKey: "cityName") as? String
                                    {
                                        print(cityName)
                                        self.cityNameArr.append(cityName)
                                        DispatchQueue.main.async {
                                            self.tab.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                        catch{
                            print("error")
                        }
            }
        }
        
        

        
        
//

        
        
    }

//    func deleteAllData(_ entity:String) {
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else {continue}
//                context.delete(objectData)
//            }
//        } catch let error {
//            print("Detele all data in \(entity) error :", error)
//        }
//    }

}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cityNameArr[indexPath.row]
        return cell
    }
    
    
}

extension UIApplication {
      func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "HasLaunched") {
          UserDefaults.standard.set(true, forKey: "HasLaunched")
          UserDefaults.standard.synchronize()
          return true
      }
      return false
    }
}

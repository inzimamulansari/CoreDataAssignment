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
        context.delete(newData)
        
        data.loadFromInternet{
            (data,error)  in
            self.userData = (data)!
            
            for cityname in self.userData{
                
                newData.setValue(cityname.timezone, forKey: "cityName")
            }
            DispatchQueue.main.async {
                self.tab.reloadData()
            }
        }
        
        

        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")

        request.returnsObjectsAsFaults = false
        
        
        do{
            try context.save()
            let results = try context.fetch(request)
            if results.count > 0{
                for result in results as! [NSManagedObject] {
                    if let cityName = result.value(forKey: "cityName") as? String
                    {
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

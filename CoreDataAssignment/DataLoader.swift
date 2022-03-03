//
//  DataLoader.swift
//
//  Created by Apple on 13/02/22.
//


import Foundation

public class DataLoader {
    
    @Published var userData = [UserData]()
    
    
    func loadFromInternet(comp:@escaping([UserData]?, Error?) -> ()) {
        
        if let url = URL(string:"https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&exclude=hourly,daily&appid=8c74b3976e361cbcda0787c3c1011a29") {

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let data = data {
                    
                    do {
                        let jsonDecoder = JSONDecoder()
                        let dataFromJson = try jsonDecoder.decode(UserData.self, from: data)
                        
                        self.userData = [dataFromJson]
                        comp(self.userData, nil)
                    }
                    catch let error {
                        print(error)
                    }
                }

            }.resume()
        }
    }
    
    

}

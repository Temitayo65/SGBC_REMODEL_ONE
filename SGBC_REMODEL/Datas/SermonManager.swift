//
//  SermonManager.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import Foundation

protocol SermonManagerDelegate{
    func didUpdateSermonData(sermon: [Sermons]?)
}

struct SermonManager{
    let baseURL = "https://still-savannah-43128.herokuapp.com/sermons/all"
    var delegate: SermonManagerDelegate?
   
    
    func fetchSermons(){
        performRequest(urlString: baseURL)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let sermon = parseJSON(data: safeData){
                        self.delegate?.didUpdateSermonData(sermon: sermon)
                    }
                }
            }
            task.resume()
        }
                
    }
    
    func parseJSON(data: Data)-> [Sermons]?{
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(Datas.self, from: data){
            let sermons = data.data
            return sermons
        }
        return nil
    }
    
}

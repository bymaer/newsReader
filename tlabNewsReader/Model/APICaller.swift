//
//  APICaller.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/4/23.
//

import Foundation

class APICaller {
    
    var newsFeed = [Articles]()
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(NewsFeed.self, from: json) {
            newsFeed = jsonPetitions.articles
        }
    }
    
    var isPaginating = false
    
    func fetchData(pagination: Bool = false, completion: @escaping (Result<[Articles], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
            let originalData = self.newsFeed
            let newData = self.newsFeed
            completion(.success(pagination ? newData : originalData ))
            if pagination {
                self.isPaginating = false
            }
        })
    }

    
}

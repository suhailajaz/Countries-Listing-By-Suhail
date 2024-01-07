//
//  DatabaseManager.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//
import UIKit
import Foundation
import CoreData



final class DatabaseManager{
    static let shared = DatabaseManager()
    
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    private init(){}
   
        
        
        func cacheQuestionsToLocalDB(parsedCountries: [Country],completion: @escaping (Bool)->()){
            for parsedCountry in parsedCountries{
                print("########")
                print(parsedCountry.name.common)
                print(parsedCountry.latlng[0])
                print(parsedCountry.latlng[1])
                print(parsedCountry.flags.png)
                print("########")
            }
            //        for document in snapshot.documents{
            //            let documentData = document.data()
            //            let answer = documentData["answer"] as! String
            //            let text = documentData["text"] as! String
            //            let newQuestion = QuestionsCD(context: self.context)
            //            newQuestion.text = text
            //            newQuestion.answer = answer
            //            do{
            //                try self.context.save()
            //            }catch{
            //                print(error.localizedDescription)
            //            }
            //        }
            //        completion(true)
        }
    
        
        //    func fetchCachedQuestions()->[QuestionsCD]?{
        //        do{
        //            let questions = try context.fetch(QuestionsCD.fetchRequest())
        //           return questions
        //        }catch{
        //            print("Could not fetch questions!")
        //        }
        //        return nil
        //    }
    
}

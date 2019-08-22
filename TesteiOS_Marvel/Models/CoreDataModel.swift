//
//  CoreDataModel.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataModel: DataModel {
    static let sharedInstance: CoreDataModel = CoreDataModel()
    let personaEntityName: String = "PersonaDataModel"
    let personaIdKey: String = "persona_id"
    let personaNameKey: String = "persona_name"
    let personaAvatarKey: String = "persona_avatar"
    
    
    private let appContext: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func savePersonaAsFavorite(_ id: Int, name: String, avatar: Data) -> Observable<Bool> {
        guard let managedContext = appContext else { return Observable.just(false) }
        
        guard let personaEntity = NSEntityDescription.entity(
            forEntityName: personaEntityName,
            in: managedContext) else { return Observable.just(false) }
        
        let persona = NSManagedObject(
            entity: personaEntity,
            insertInto: managedContext)
        
        persona.setValue(id, forKey: personaIdKey)
        persona.setValue(name, forKey: personaNameKey)
        persona.setValue(avatar, forKey: personaAvatarKey)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
            return Observable.error(error)
        }
        
        return Observable.just(true)
    }
    
    func retrieveFavoritePersonasList() -> Observable<[(name: String, id: Int, avatar: Data?)]> {
        guard let managedContext = appContext else { return Observable.error(NSError(domain: "Error to get list of favorite personas", code: 1, userInfo: nil)) }
        var listOfElements: [(name: String, id: Int, avatar: Data?)] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: personaEntityName)
        do {
            let personaList = try managedContext.fetch(fetchRequest)
            for persona in personaList {
                guard let name = persona.value(forKey: personaNameKey) as? String,
                    let id = persona.value(forKey: personaIdKey) as? Int else {
                        return Observable.error(NSError(domain: "Error parsing list of favorite personas from CoreData", code: 2, userInfo: nil))
                }
                listOfElements.append(
                    (name: name, id: id, avatar: persona.value(forKey: personaAvatarKey) as? Data)
                )
            }
        } catch let error as NSError {
            print(error)
            return Observable.error(error)
        }
        
        return Observable.just(listOfElements)
    }
    
    func removePersonaFromFavoriteList(_ id: Int) -> Observable<Bool> {
        guard let managedContext = appContext else { return Observable.just(false) }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: personaEntityName)
        do {
            let personaList = try managedContext.fetch(fetchRequest)
            if let personaToDelete = personaList.first(where: { $0.value(forKey: personaIdKey) as? Int == id }) {
                managedContext.delete(personaToDelete)
            }
            return Observable.just(true)
        } catch let error as NSError {
            print(error)
            return Observable.error(error)
        }
    }
}

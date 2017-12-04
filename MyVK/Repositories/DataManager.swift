//
//  DataManager.swift
//  MyVK
//
//  Created by Дамир Зарипов on 03.12.17.
//  Copyright © 2017 itisioslab. All rights reserved.
//

import Foundation

class DataManager: ManagerProtocol {
    
    func syncSave<T>(with obj: T) where T : DataProtocol {
        let keyPathOfObject = NSStringFromClass(T.self)
        if let keyPathOfCurrectObject = UserDefaults.standard.data(forKey: keyPathOfObject) {
            guard var arrayOfCurrentObject = NSKeyedUnarchiver.unarchiveObject(with: keyPathOfCurrectObject) as? [T] else {return}
            arrayOfCurrentObject.append(obj)
            let archiver = NSKeyedArchiver.archivedData(withRootObject: arrayOfCurrentObject)
            UserDefaults.standard.set(archiver, forKey: keyPathOfObject)
        } else {
            let archiver = NSKeyedArchiver.archivedData(withRootObject: [obj])
            UserDefaults.standard.set(archiver, forKey: keyPathOfObject)
        }
    }
    
    func asynSave<T>(with obj: T, complitionBlock: @escaping (Bool) -> ()) where T : DataProtocol {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.syncSave(with: obj)
            complitionBlock(true)
        }
    }
    
    func syncGetAll<T>() -> [T]? where T : DataProtocol {
        let keyPathOfObject = NSStringFromClass(T.self)
        if let keyPathOfCurrectObject = UserDefaults.standard.data(forKey: keyPathOfObject) {
            guard let arrayOfCurrectObject = NSKeyedUnarchiver.unarchiveObject(with: keyPathOfCurrectObject) as? [T] else {return nil}
            return arrayOfCurrectObject
        } else {return nil}
    }
    
    func asynGetAll<T>(complitionBlock: @escaping ([T]) -> ()) where T : DataProtocol {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            guard let arrayOfCurrectObject: [T] = strongSelf.syncGetAll() else { return }
            complitionBlock(arrayOfCurrectObject)
        }
    }
    
    
    func syncSearch<T>(by id: Int, type: T.Type) -> T? where T : DataProtocol, T : HasIdProtocol {
        let keyPathOfObject = NSStringFromClass(type)
        if let keyPathOfCurrectObject = UserDefaults.standard.data(forKey: keyPathOfObject) {
            guard let arrayOfCurrectObject = NSKeyedUnarchiver.unarchiveObject(with: keyPathOfCurrectObject) as? [T] else {return nil}
            return arrayOfCurrectObject.first {$0.id == id}
        }
        return nil
    }
    
    
    func asynSearch<T>(by id: Int, type: T.Type, complitionBlock: @escaping (T?) -> ()) where T : DataProtocol, T : HasIdProtocol {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            complitionBlock(strongSelf.syncSearch(by: id, type: type))
        }
    }
    
}

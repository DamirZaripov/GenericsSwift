//
//  ManagerProtocol.swift
//  MyVK
//
//  Created by Дамир Зарипов on 03.12.17.
//  Copyright © 2017 itisioslab. All rights reserved.
//

import Foundation

protocol ManagerProtocol {
    func syncSave<T: DataProtocol> (with obj: T)
    func asynSave<T: DataProtocol> (with obj: T, complitionBlock: @escaping (Bool) -> ())
    func syncGetAll<T: DataProtocol>() -> [T]?
    func asynGetAll<T: DataProtocol>(complitionBlock: @escaping([T]) -> ())
    func syncSearch<T: DataProtocol> (by id: Int, type: T.Type) -> T? where T: HasIdProtocol
    func asynSearch<T: DataProtocol> (by id: Int, type: T.Type, complitionBlock: @escaping(T?) -> ()) where T: HasIdProtocol
}

//
//  News.swift
//  MyVK
//
//  Created by itisioslab on 11.10.17.
//  Copyright © 2017 itisioslab. All rights reserved.
//

import UIKit

class News: NSObject, NSCoding, HasIdProtocol, DataProtocol {
    
    @objc var id: Int
    @objc let name: String
    @objc let surname: String
    @objc let date: String
    @objc let text: String?
    @objc let image: UIImage?
    @objc let numberOfLikes: String
    @objc let numberOfComments: String
    @objc let numberOfReposts: String
    @objc let avatar: UIImage
    
    init(id: Int, name: String, surname: String, date: String, text: String?, image: UIImage?, numberOfLikes: String, numberOfComments: String, numberOfReposts: String, avatar: UIImage) {
        self.id = id
        self.name = name
        self.surname = surname
        self.date = date
        self.text = text
        self.image = image
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.numberOfReposts = numberOfReposts
        self.avatar = avatar
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: #keyPath(News.id))
        aCoder.encode(name, forKey: #keyPath(News.name))
        aCoder.encode(surname, forKey: #keyPath(News.surname))
        aCoder.encode(date, forKey: #keyPath(News.date))
        aCoder.encode(text, forKey: #keyPath(News.text))
        aCoder.encode(image, forKey: #keyPath(News.image))
        aCoder.encode(numberOfLikes, forKey: #keyPath(News.numberOfLikes))
        aCoder.encode(numberOfComments, forKey: #keyPath(News.numberOfComments))
        aCoder.encode(numberOfReposts, forKey: #keyPath(News.numberOfReposts))
        aCoder.encode(avatar, forKey: #keyPath(News.avatar))
    }
   
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: #keyPath(News.id))
        guard let name = aDecoder.decodeObject(forKey: #keyPath(News.name)) as? String else {return nil}
        guard let surname = aDecoder.decodeObject(forKey: #keyPath(News.surname)) as? String else {return nil}
        guard let date = aDecoder.decodeObject(forKey: #keyPath(News.date)) as? String else {return nil}
        let text = aDecoder.decodeObject(forKey: #keyPath(News.text)) as? String
        let image = aDecoder.decodeObject(forKey: #keyPath(News.image)) as? UIImage
        guard let numberOfLikes = aDecoder.decodeObject(forKey: #keyPath(News.numberOfLikes)) as? String else {return nil}
        guard let numberOfComments = aDecoder.decodeObject(forKey: #keyPath(News.numberOfComments)) as? String else {return nil}
        guard let numberOfReposts = aDecoder.decodeObject(forKey: #keyPath(News.numberOfReposts)) as? String else {
            return nil}
        guard let avatar = aDecoder.decodeObject(forKey: #keyPath(News.avatar)) as? UIImage else {return nil}
        
        self.init(
            id: id,
            name: name,
            surname: surname,
            date: date,
            text: text,
            image: image,
            numberOfLikes: numberOfLikes,
            numberOfComments: numberOfComments,
            numberOfReposts: numberOfReposts,
            avatar: avatar
        )
    }
    
    
}

//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 31.03.2023.
//

import CoreData

class CoreDataManeger {
    
    static let defaulManager = CoreDataManeger()
    
    init() {
        reloadUsers()
//        reloadPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    // Users
    
    var user: User?
    var users: [User] = []
    func reloadUsers() {
        let fetchRequest = User.fetchRequest()
        users = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func addUser(logIn: String, password: String, fullName: String, avatar: Data?) {
        
        persistentContainer.performBackgroundTask { contextBackground in
            let user = User(context: contextBackground)
            user.login = logIn
            user.password = password
            user.fullName = fullName
            user.dateCreated = Date()
            user.avatar = avatar
            user.isLogIn = true
            user.lastAutorizationDate = Date()
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUserStatus(user: User, newStatus: String?) {
        user.status = newStatus
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func updateUserAvatar(user: User, imageData: Data?) {
        user.avatar = imageData
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        try? persistentContainer.viewContext.save()
    }
    
    // Posts
    
    var posts: [Post] = []
    func reloadPosts() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        posts = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func addPost(text: String, image: Data?, for user: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let post = Post(context: contextBackground)
            post.author = user.fullName
            post.text = text
            post.image = image
            
            post.user = self.getUser(login: user.login!, context: contextBackground)
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func getUser(login: String, context: NSManagedObjectContext) -> User? {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    func updatePost(post: Post, newText: String, imageData: Data?) {
        post.text = newText
        post.image = imageData
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func favoritePost(post: Post, isFavorite: Bool) {
        post.isFavorite = isFavorite
        if isFavorite {
            post.likes += 1
        } else {
            post.likes -= 1
        }
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deletePost(post: Post) {
        persistentContainer.viewContext.delete(post)
        try? persistentContainer.viewContext.save()
    }
    
    // Authorization
    
    func authorization(user: User) {
        user.isLogIn = true
        user.lastAutorizationDate = Date()
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deauthorization(user: User) {
        user.isLogIn = false
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
}

extension User {
    var postsSorted: [Post] {
        posts?.sortedArray(using: [NSSortDescriptor(key: "dateCreated", ascending: false)]) as? [Post] ?? []
    }
}

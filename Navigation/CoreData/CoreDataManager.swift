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
        reloadPosts()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Users
    
    var users: [User] = []
    func reloadUsers() {
        let fetchRequest = User.fetchRequest()
        users = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func addUser(logIn: String, password: String, fullName: String, avatar: Data?) {
        let user = User(context: persistentContainer.viewContext)
        user.login = logIn
        user.password = password
        user.fullName = fullName
        user.dateCreated = Date()
        user.avatar = avatar
        user.isLogIn = true
        
        saveContext()
        reloadUsers()
    }
    
    func updateUserStatus(user: User, newStatus: String?) {
        user.status = newStatus
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
        reloadUsers()
    }
    
    func updateUserAvatar(user: User, imageData: Data?) {
        user.avatar = imageData
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
        reloadUsers()
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        saveContext()
        reloadUsers()
    }
    
    // Posts
    
    var posts: [Post] = []
    func reloadPosts() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        do {
            posts = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func addPost(text: String, image: Data?, for user: User) {
        let post = Post(context: persistentContainer.viewContext)
        post.user = user
        post.author = user.fullName
        post.text = text
        post.image = image
        
        saveContext()
        reloadPosts()
    }
    
    func updatePost(post: Post, newText: String, imageData: Data?) {
        post.text = newText
        post.image = imageData
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
        reloadPosts()
    }
    
    func favoritePost(post: Post, isFavorite: Bool) {
        post.isFavorite = isFavorite
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
        reloadPosts()
    }
    
    func deletePost(post: Post) {
        persistentContainer.viewContext.delete(post)
        saveContext()
        reloadPosts()
    }
    
    // Authorization
    
    func authorization(user: User) {
        user.isLogIn = true
        
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

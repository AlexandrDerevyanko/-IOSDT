//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 31.03.2023.
//

import CoreData
import UIKit

class CoreDataManeger {
    
    static let defaulManager = CoreDataManeger()
    
    init() {
        reloadUsers()
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
    
    // Users
    
    var user: User?
    var users: [User] = []
    func reloadUsers() {
        let fetchRequest = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastAutorizationDate", ascending: false)]
        users = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        user = users.first
    }
    
    func addUser(logIn: String, password: String, fullName: String, avatar: Data?) {
        
        persistentContainer.performBackgroundTask { contextBackground in
            let user = User(context: contextBackground)
            user.login = logIn
            user.password = password
            user.fullName = fullName
            user.dateCreated = Date()
            let image = UIImage(named: "addPhotoIcon")
            let imageData = image?.pngData()
            if let avatar {
                user.avatar = avatar
            } else {
                user.avatar = imageData
            }
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
    
    func changeUserName(user: User, name: String) {
        user.fullName = name
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func changePassword(user: User, password: String) {
        user.password = password
        
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func getUser(login: String, context: NSManagedObjectContext) -> User? {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        return (try? context.fetch(fetchRequest))?.first
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        try? persistentContainer.viewContext.save()
    }
    
    // Posts
    
    var posts: [Post] = []
    
    func getPost(id: UUID, context: NSManagedObjectContext) -> Post? {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postID == %@", id as CVarArg)
        return(try? context.fetch(fetchRequest))?.first
    }
    
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
            if let image {
                let photo = Photo(context: contextBackground)
                photo.image = image
                photo.user = self.getUser(login: user.login ?? "", context: contextBackground)
                photo.photoID = UUID()
            }
            
            post.user = self.getUser(login: user.login ?? "", context: contextBackground)
            post.postID = UUID()
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func addPhoto(image: Data?, for user: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let photo = Photo(context: contextBackground)
            photo.image = image
            photo.user = self.getUser(login: user.login ?? "", context: contextBackground)
            photo.photoID = UUID()
            photo.dateCreated = Date()
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func updatePost(post: Post, newText: String, imageData: Data?) {
        post.text = newText
        if let imageData {
            post.image = imageData
        }
        
        do {
            try post.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func getLike(login: String, postID: UUID, context: NSManagedObjectContext) -> Like? {
        let fetchRequest = Like.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@ AND postID == %@", login, postID as CVarArg)
        return(try? context.fetch(fetchRequest))?.first
    }
    
    func likePost(postUUID: UUID, userLogin: String) {
        persistentContainer.performBackgroundTask { contextBackground in
            let like = Like(context: contextBackground)
            let post = self.getPost(id: postUUID, context: contextBackground)
            let user = self.getUser(login: userLogin, context: contextBackground)
            
            like.dateCreated = Date()
            like.login = userLogin
            like.post = post
            like.user = user
            like.postID = postUUID
                        
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteLike(postUUID: UUID, userLogin: String) {
        persistentContainer.performBackgroundTask { contextBackground in
            guard let like = self.getLike(login: userLogin, postID: postUUID, context: contextBackground) else { return }
            contextBackground.delete(like)
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func commentPost(postUUID: UUID, userLogin: String, text: String) {
        persistentContainer.performBackgroundTask { contextBackground in
            let comment = Comment(context: contextBackground)
            let post = self.getPost(id: postUUID, context: contextBackground)
            let user = self.getUser(login: userLogin, context: contextBackground)
            
            comment.dateCreated = Date()
            comment.login = userLogin
            comment.text = text
            comment.post = post
            comment.user = user
            comment.postID = postUUID
                        
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
    func showPost(post: Post) {
        post.views += 1
        
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
        self.user = user
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func deauthorization(user: User) {
        user.isLogIn = false
        self.user = nil
        do {
            try user.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    // Subscribe
    
    // Добавление подписки
    func subscribe(authorizedUser: User, subscriptionUser: User) {
        persistentContainer.performBackgroundTask { contextBackground in
            let subscription = Subscription(context: contextBackground)
            let authorizedUserContextBackground = self.getUser(login: authorizedUser.login ?? "", context: contextBackground)
            let subscriptionUserContextBackground = self.getUser(login: subscriptionUser.login ?? "", context: contextBackground)
            subscription.user = authorizedUserContextBackground // Пользователь, который подписывается
            subscription.userSubscription = subscriptionUserContextBackground // Пользователь на которого подписываются
            subscription.dateCreated = Date()
            
            let subscriber = Subscriber(context: contextBackground)
            let subscriberUserContextBackground = self.getUser(login: authorizedUser.login ?? "", context: contextBackground)
            let userContextBackground = self.getUser(login: subscriptionUser.login ?? "", context: contextBackground)
            subscriber.user = userContextBackground  // Пользователь на которого подписываются
            subscriber.userSubscriber = subscriberUserContextBackground // Пользователь, который подписывается
            subscriber.dateCreated = Date()
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
        }
    }
    
}

extension User {
    var postsSorted: [Post] {
        posts?.sortedArray(using: [NSSortDescriptor(key: "dateCreated", ascending: false)]) as? [Post] ?? []
    }
}

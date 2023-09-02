
protocol ProfileDelegate: AnyObject {
    func pushNewPostViewController()
    func changePost(post: Post)
    func likePost(post: Post)
    func setStatusButtonPressed(status: String, user: User)
    func subscribe(authorizedUser: User, subscriptionUser: User)
    func pushUsersViewController(post: Post?, subscribers: [Subscriber]?, subscriptions: [Subscription]?)
    func pushCommentsViewController(post: Post)
}

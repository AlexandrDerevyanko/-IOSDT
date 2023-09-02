
protocol FeedDelegate {
    func authorLabelPressed(user: User)
    func likePost(post: Post)
    func pushUsersViewController(post: Post?, subscribers: [Subscriber]?, subscriptions: [Subscription]?)
    func pushCommentsViewController(post: Post)
}

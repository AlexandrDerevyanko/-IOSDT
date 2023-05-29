//
//  ProfileDelegate.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 04.04.2023.
//

import Foundation

protocol ProfileDelegate {
    func pushNewPostViewController()
    func changePost(post: Post)
    func likePost(post: Post)
}

//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 02.02.2023.
//

import UIKit
import StorageService
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    var imageProcessor = ImageProcessor()
    
    private enum Constants {
        static let numberOfItemsInLIne: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        imageFiltered(urlString: "") { result in
            switch result {
            case .success(let message):
                print("\(message)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        collectionView.reloadData()
    }
    
    private func imageFiltered(
        urlString: String,
        completion: @escaping (Result<String, ImagesError>) -> Void) {
            
//            guard URL(string: urlString) != nil else {
//                completion(.failure(.badURL))
//                return
//            }
//            
//            let queue = DispatchQueue.global(qos: .default)
//            let workItem = DispatchWorkItem.init { [self] in
//                let startTime = Date()
//                imageProcessor.processImagesOnThread(sourceImages: data as? [UIImage] ?? [UIImage()], filter: .chrome, qos: .default) { images in
//                    let CGImages = images
//                    var UIImages: [UIImage?] = []
//                    for index in CGImages {
//                        UIImages.append(UIImage(cgImage: index!))
//                        data = UIImages
//                    }
//                    let endTime = Date()
//                    print(endTime.timeIntervalSince(startTime))
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                        completion(.success("Filters applied"))
//                    }
//                }
//            }
//            queue.sync (execute: workItem)
            
    }
    
    private func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Photo Gallery"
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        data.count
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
//
//        cell.clipsToBounds = true
//        cell.setup(with: data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        
        let width = collectionView.frame.width - (Constants.numberOfItemsInLIne - 1) * interItemSpacing - insets.left - insets.right
        
        let itemWidth = floor(width / Constants.numberOfItemsInLIne)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
        
    }
    
}


//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 02.02.2023.
//

import UIKit
import iOSIntPackage
import CoreData

class PhotosViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var user: User
    var isCurrentUser: Bool
        
    var photosFetchResultsController: NSFetchedResultsController<Photo>?
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
        collectionView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(user: User, isCurrentUser: Bool) {
        self.user = user
        self.isCurrentUser = isCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initPhotosFetchResultsController()
        let addPhotoButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPhotoButtonPressed))
        navigationItem.rightBarButtonItem = addPhotoButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Photo Gallery"
        collectionView.reloadData()
    }
    
    private func initPhotosFetchResultsController() {
        let fetchRequest = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        photosFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        photosFetchResultsController?.delegate = self
        try? photosFetchResultsController?.performFetch()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    @objc
    private func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func addPhotoButtonPressed() {
        ImagePicker.defaultPicker.getImage(in: self) { imageData in
            CoreDataManeger.defaulManager.addPhoto(image: imageData, for: self.user)
        }
    }
    
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFetchResultsController?.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
//
//        cell.clipsToBounds = true
        let data = photosFetchResultsController?.fetchedObjects
        cell.setup(with: UIImage(data: data?[indexPath.row].image ?? Data()))
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            collectionView.reloadData()
//            tableView.insertRows(at: [IndexPath(row: newIndexPath!.row, section: 1)], with: .automatic)
        case .delete:
//            tableView.deleteRows(at: [IndexPath(row: indexPath!.row, section: 1)], with: .automatic)
            collectionView.reloadData()
        case .move:
            ()
        case .update:
            collectionView.reloadData()
        @unknown default:
            collectionView.reloadData()
        }
        self.collectionView.reloadData()
    }
    
}


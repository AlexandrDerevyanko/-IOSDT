//
//  LocationViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 04.05.2023.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class LocationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var hybridStyleButton = CustomButton(title: "Hubrid", titleColor: UIColor.createColor(lightMode: .black, darkMode: .white), bgColor: UIColor.createColor(lightMode: .white, darkMode: .systemGray3), action: hybridStyleButtonPressed)
    private lazy var satelliteStyleButton = CustomButton(title: "Satellite", titleColor: UIColor.createColor(lightMode: .black, darkMode: .white), bgColor: UIColor.createColor(lightMode: .white, darkMode: .systemGray3), action: satelliteStyleButtonPressed)
    private lazy var standardStyleButton = CustomButton(title: "Standard", titleColor: UIColor.createColor(lightMode: .black, darkMode: .white), bgColor: UIColor.createColor(lightMode: .white, darkMode: .systemGray3), action: standardStyleButtonPressed)
    private lazy var removeAnnotationsButton = CustomButton(title: NSLocalizedString("remove-annotations-button-locationVC-localizable", comment: ""), titleColor: UIColor.createColor(lightMode: .black, darkMode: .white), bgColor: UIColor.createColor(lightMode: .white, darkMode: .systemGray3), action: removeAnnotationsButtonPressed)
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true

        
        let pointsOfInterestFilter = MKPointOfInterestFilter()
        mapView.pointOfInterestFilter = pointsOfInterestFilter
        // Москва
        let initialLocation = CLLocationCoordinate2D(
            latitude: 55.75222,
            longitude: 37.61556
        )
        mapView.setCenter(
            initialLocation,
            animated: false
        )
        let region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 1_000_000,
            longitudinalMeters: 1_000_000
        )
        mapView.setRegion(
            region,
            animated: false
        )
        mapView.addAnnotations(CapitalAnnotation.make())
        return mapView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        setupUI()
        findUserLocation()
        mapView.delegate = self
        let lpgr = UILongPressGestureRecognizer(target: self,
                                 action:#selector(self.handleLongPress))
            lpgr.minimumPressDuration = 1
            lpgr.delaysTouchesBegan = true
            lpgr.delegate = self
            self.mapView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = NSLocalizedString("location-tabbar-localizable", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestLocation()
    }

    private func setupUI() {
        view.addSubview(mapView)
        mapView.addSubview(stackView)
        mapView.addSubview(removeAnnotationsButton)
        stackView.addArrangedSubview(hybridStyleButton)
        stackView.addArrangedSubview(satelliteStyleButton)
        stackView.addArrangedSubview(standardStyleButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        removeAnnotationsButton.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalTo(view.snp.centerX)
        }
        removeAnnotationsButton.titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(15)
        })
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(mapView.snp.centerX)
            make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(-6)
        }
        hybridStyleButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        satelliteStyleButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        standardStyleButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
    }
    
    private func findUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    private func hybridStyleButtonPressed() {
        mapView.mapType = .hybrid
    }
    
    private func satelliteStyleButtonPressed() {
        mapView.mapType = .satellite
    }
    
    private func standardStyleButtonPressed() {
        mapView.mapType = .standard
    }
    
    @objc
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        }
        else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchMapCoordinate =  self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = CapitalAnnotation(title: "You long pressed here", coordinate: touchMapCoordinate, info: "")
            self.mapView.addAnnotation(annotation)
            if locationManager.location != nil {
                let starttLatitude: Double = locationManager.location!.coordinate.latitude
                let startLongitude: Double = locationManager.location!.coordinate.longitude
                let loc1 = CLLocationCoordinate2D.init(latitude: starttLatitude, longitude: startLongitude)
                let loc2 = CLLocationCoordinate2D.init(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
                showRouteOnMap(pickupCoordinate: loc1, destinationCoordinate: loc2)
            }
        }
    }
    
    @objc private func removeAnnotationsButtonPressed() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
    }
    
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Определение локации невозможно")
        case .notDetermined:
            print("Определение локации не запрошено")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            mapView.setCenter(
                location.coordinate,
                animated: true
            )
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
}

extension LocationViewController: MKMapViewDelegate {

    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                if let route = unwrappedResponse.routes.first {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }
            }
        }
    
    //this delegate function is for displaying the route overlay and styling it
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.red
         renderer.lineWidth = 5.0
         return renderer
    }
    

    
}

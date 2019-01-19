//
//  MarsRoverPhotosFiltersController.swift
//  NASACapstone
//
//  Created by Erik Carlson on 1/17/19.
//  Copyright © 2019 Round and Rhombus. All rights reserved.
//

import UIKit

/// Allows the user to select which filters they want to apply for Mars rover photos fetch.
class MarsRoverPhotosFiltersController: UIViewController {
    /// Indexes for timeControl
    enum TimeIndex: Int {
        case sol
        case earthDate
    }
    
    @IBOutlet weak var roverControl: UISegmentedControl!
    @IBOutlet weak var timeControl: UISegmentedControl!
    @IBOutlet weak var solTextField: UITextField!
    @IBOutlet weak var solStepper: UIStepper!
    @IBOutlet weak var earthDateTextField: UITextField!
    @IBOutlet weak var cameraButtonAll: UIButton!
    @IBOutlet weak var cameraButtonFhaz: UIButton!
    @IBOutlet weak var cameraButtonRhaz: UIButton!
    @IBOutlet weak var cameraButtonMast: UIButton!
    @IBOutlet weak var cameraButtonChemcam: UIButton!
    @IBOutlet weak var cameraButtonMahli: UIButton!
    @IBOutlet weak var cameraButtonMardi: UIButton!
    @IBOutlet weak var cameraButtonNavcam: UIButton!
    @IBOutlet weak var cameraButtonPancam: UIButton!
    @IBOutlet weak var cameraButtonMiniTes: UIButton!
    
    /// The starting endpoint.
    var endpoint: MarsRoverPhotosEndpoints.RoversPhotosEndpoint!
    /// Get or set the current rover.
    /// This is linked to roverControl.
    var rover: MarsRoverPhotosEndpoints.Rover {
        get {
            return indexToRover[roverControl.selectedSegmentIndex]!
        }
        
        set {
            roverControl.selectedSegmentIndex = roverToIndex[newValue]!
        }
    }
    /// Check if the selected time units are sol (not earth dates)
    var isTimeSol: Bool {
        return timeControl.selectedSegmentIndex == TimeIndex.sol.rawValue
    }
    /// Get or set the current camera. nil means all cameras.
    /// This is linked to the camera buttons.
    var camera: MarsRoverPhotosEndpoints.Camera? {
        get {
            return buttonToCamera[selectedCameraButton]
        }
        
        set {
            guard let cam = newValue, let button = cameraToButton[cam] else {
                selectedCameraButton = cameraButtonAll
                return
            }
            
            selectedCameraButton = button
        }
    }
    /// Callback for when the user has finished updating the filters.
    var endpointUpdated: ((MarsRoverPhotosEndpoints.RoversPhotosEndpoint) -> Void)?
    /// The camera button that is currently selected.
    private var selectedCameraButton: UIButton! {
        didSet {
            var cameraButtons = Array(buttonToCamera.keys)
            cameraButtons.append(cameraButtonAll)
            // Update all buttons' selected state.
            for button in cameraButtons {
                button.isSelected = button == selectedCameraButton
            }
        }
    }
    /// Mapping from rover enum to rover control index.
    private let roverToIndex: [MarsRoverPhotosEndpoints.Rover: Int] = [
        .curiosity: 0,
        .opportunity: 1,
        .spirit: 2
    ]
    /// Mapping from rover control index to rover enum.
    private var indexToRover: [Int: MarsRoverPhotosEndpoints.Rover] = [:]
    /// Mapping from camera enum to camera button
    private var cameraToButton: [MarsRoverPhotosEndpoints.Camera: UIButton] = [:]
    /// Mapping from camera button to camera enum. Inverse of `cameraToButton`.
    private var buttonToCamera: [UIButton: MarsRoverPhotosEndpoints.Camera] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIndexToRover()
        setupCameraToButton()
        setupButtonToCamera()
        
        solTextField.addDoneButtonToKeyboard()
        setupEarthDateTextField()
        
        configure()
    }
    
    /// Update which time views are shown.
    @IBAction func timeUnitsChanged(_ sender: UISegmentedControl) {
        updateTimeViewsHidden()
    }
    
    @IBAction func solTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text, let value = Double(text) else { return }
        solStepper.value = value
    }
    
    /// Update sol or earth days.
    @IBAction func solStepperChanged(_ sender: UIStepper) {
        solTextField.text = String(Int(sender.value))
    }
    
    /// Update earth date text field with the new date chosen.
    @IBAction func earthDateChanged(_ sender: UITextField) {
        guard let datePicker = sender.inputView as? UIDatePicker else { return }
        earthDateTextField.text = NasaApi.dateFormatter.string(from: datePicker.date)
    }
    
    /// Update which button is selected.
    @IBAction func cameraButtonTouched(_ sender: UIButton) {
        selectedCameraButton = sender
    }
    
    /// The user is done. Pass the new endpoint back.
    @IBAction func done(_ sender: UIBarButtonItem) {
        if isTimeSol {
            let solText = solTextField.text ?? "0"
            let sol = Int(solText)!
            let newEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: rover, sol: sol, camera: camera, page: 1)
            endpointUpdated?(newEndpoint)
        } else {
            let earthDateText = earthDateTextField.text ?? ""
            guard let earthDate = NasaApi.dateFormatter.date(from: earthDateText) else {
                showAlert(title: "Bad Date", message: "Earth date must be in the format 'YYYY-MM-DD'.")
                return
            }
            let newEndpoint = MarsRoverPhotosEndpoints.RoversPhotosEndpoint(rover: rover, earthDate: earthDate, camera: camera, page: 1)
            endpointUpdated?(newEndpoint)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// Setup earth date with a default date and change the keyboard to a date picker.
    private func setupEarthDateTextField() {
        earthDateTextField.text = NasaApi.dateFormatter.string(from: Date())
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        earthDateTextField.inputView = datePicker
        earthDateTextField.addDoneButtonToKeyboard()
    }
    
    /// Setup mapping of enum camera to button camera.
    private func setupCameraToButton() {
        cameraToButton[.fhaz] = cameraButtonFhaz
        cameraToButton[.rhaz] = cameraButtonRhaz
        cameraToButton[.mast] = cameraButtonMast
        cameraToButton[.chemcam] = cameraButtonChemcam
        cameraToButton[.mahli] = cameraButtonMahli
        cameraToButton[.mardi] = cameraButtonMardi
        cameraToButton[.navcam] = cameraButtonNavcam
        cameraToButton[.pancam] = cameraButtonPancam
        cameraToButton[.minites] = cameraButtonMiniTes
    }
    
    /// Setup mapping of button camera to enum camera.
    /// `setupCameraToButton` must be called first since this mapping is just the inverse.
    private func setupButtonToCamera() {
        for (key, value) in cameraToButton {
            buttonToCamera[value] = key
        }
    }
    
    /// Setup mapping of segment indexes to rover enums.
    private func setupIndexToRover() {
        for (key, value) in roverToIndex {
            indexToRover[value] = key
        }
    }
    
    /// Configure the view with the current endpoint.
    func configure() {
        rover = endpoint.rover
        setTime()
        camera = endpoint.camera
    }
    
    /// Set the type of time (sol/earthDate) and the time value using the current endpoint.
    func setTime() {
        if let sol = endpoint.sol {
            timeControl.selectedSegmentIndex = TimeIndex.sol.rawValue
            solStepper.value = Double(sol)
            solTextField.text = String(sol)
        } else if let earthDate = endpoint.earthDate {
            timeControl.selectedSegmentIndex = TimeIndex.earthDate.rawValue
            earthDateTextField.text = NasaApi.dateFormatter.string(from: earthDate)
        } else {
            print("MarsRoverPhotosFiltersController.configure: Error: endpoint does not have sol or earthDate.")
        }
        
        updateTimeViewsHidden()
    }
    
    /// Update which time views (sol/earthDate) are hidden.
    func updateTimeViewsHidden() {
        let isSol = isTimeSol
        solTextField.isHidden = !isSol
        solStepper.isHidden = !isSol
        earthDateTextField.isHidden = isSol
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

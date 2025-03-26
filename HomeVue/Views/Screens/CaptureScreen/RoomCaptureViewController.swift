import UIKit
import RoomPlan

class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    
    @IBOutlet var doneButton: UIBarButtonItem?
    @IBOutlet var cancelButton: UIBarButtonItem?

    private var isScanning: Bool = false
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?

    var roomName: String?
    var roomCategory: RoomCategoryType?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomCaptureView()
    }

    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        view.insertSubview(roomCaptureView, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }

    override func viewWillDisappear(_ flag: Bool) {
        super.viewWillDisappear(flag)
        stopSession()
    }

    private func startSession() {
        isScanning = true
        roomCaptureView?.captureSession.run(configuration: roomCaptureSessionConfig)
        setActiveNavBar()
    }

    private func stopSession() {
        isScanning = false
        roomCaptureView?.captureSession.stop()
        setCompleteNavBar()
    }

    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
    }
    
    @IBAction func doneScanning(_ sender: UIBarButtonItem) {
        if isScanning {
            stopSession()
        }

        if !isScanning, let capturedRoom = finalResults {
            let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).usdz")

            do {
                try capturedRoom.export(to: tempFileURL)

                let room3DVC = Room3DViewController()
                room3DVC.roomName = roomName
                room3DVC.modelURL = tempFileURL

                // Create a new navigation controller for the 3D view
                let navController = UINavigationController(rootViewController: room3DVC)
                navController.modalPresentationStyle = .fullScreen

                // Present the navigation controller instead of the view directly
                self.present(navController, animated: true)

            } catch {
                // Error handling
            }
        }
    }

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    private func setActiveNavBar() {
        UIView.animate(withDuration: 1.0) {
            self.cancelButton?.tintColor = .white
            self.doneButton?.tintColor = .white
        }
    }
    
    private func setCompleteNavBar() {
        UIView.animate(withDuration: 1.0) {
            self.cancelButton?.tintColor = .systemBlue
            self.doneButton?.tintColor = .systemBlue
        }
    }
}

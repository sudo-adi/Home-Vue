//
//  homeVueViewController.swift
//  Auth
//
//  Created by student-2 on 04/12/24.
//

import UIKit

class homeVueViewController: UIViewController {

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailPhoneButton: UIButton!
    @IBOutlet weak var bgImageview: UIImageView!
    
    private let overlay = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.addCornerRadius()
        emailPhoneButton.addCornerRadius()
        
        setupOverlay()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure navigation bar stays hidden
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Keep navigation bar hidden when leaving this view
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupOverlay() {
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        bgImageview.addSubview(overlay)
        
        // Set Auto Layout constraints to match bgImageview
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: bgImageview.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: bgImageview.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: bgImageview.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: bgImageview.bottomAnchor)
        ])
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

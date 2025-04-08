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
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.addCornerRadius()
        emailPhoneButton.addCornerRadius()
        let overlay = UIView(frame: bgImageview.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        bgImageview.addSubview(overlay)
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

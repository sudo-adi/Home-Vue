import UIKit

class forgotPasswordViewController: UIViewController {

    @IBOutlet weak var forgotPassView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var enterEmailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var passwordRulesLabel: UILabel!
    
    private var currentStep: ForgotPasswordStep = .enterEmail
    
    private enum ForgotPasswordStep {
        case enterEmail
        case enterOTP
        case changePassword
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.applyOverlay()
        forgotPassView.addCornerRadius(30)
        forgotPassView.applyGlassmorphism()
        
        enterEmailTextField.configureText(
            placeholder: "Enter your Email",
            placeholderColor: UIColor.lightGray)
        enterEmailTextField.setPadding(left: 10, right: 10)
        enterEmailTextField.addCornerRadius()
        
        otpTextField.configureText(
            placeholder: "Enter OTP",
            placeholderColor: UIColor.lightGray)
        otpTextField.setPadding(left: 10, right: 10)
        otpTextField.addCornerRadius()
        
        newPasswordTextField.configureText(
            placeholder: "Enter your New Password",
            placeholderColor: UIColor.lightGray)
        newPasswordTextField.setPadding(left: 10, right: 10)
        newPasswordTextField.addCornerRadius()
        
        confirmPasswordTextField.configureText(
            placeholder: "Confirm your New Password",
            placeholderColor: UIColor.lightGray)
        confirmPasswordTextField.setPadding(left: 10, right: 10)
        confirmPasswordTextField.addCornerRadius()
        
        continueButton.addCornerRadius()
    
        passwordRulesLabel = setupPasswordRulesLabel(in: stackView, below: newPasswordTextField)
        passwordRulesLabel.isHidden = true
                
        // Add text field editing changed action
        newPasswordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(isPasswordEqual), for: .editingChanged)
        enterEmailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
        otpTextField.addTarget(self, action: #selector(otpTextFieldDidChange), for: .editingChanged)
        
        // Initial setup
        setupInitialState()
    }
    
    private func setupInitialState() {
        // Initial state: only email field visible
        enterEmailTextField.isHidden = false
        otpTextField.isHidden = true
        newPasswordTextField.isHidden = true
        confirmPasswordTextField.isHidden = true
        continueButton.setTitle("Send OTP", for: .normal)
        passwordRulesLabel.isHidden = true
        continueButton.isEnabled = false
        
        continueButton.setTitleColor(.lightGray, for: .disabled)
        continueButton.backgroundColor = .black
        continueButton.alpha = 0.7
    }
    
    @objc private func emailTextFieldDidChange(_ textField: UITextField) {
        guard let email = textField.text else { return }
        continueButton.isEnabled = isValidEmail(email)
        continueButton.alpha = continueButton.isEnabled ? 1 : 0.7
    }
    
    @objc private func isPasswordEqual(_ textField: UITextField) {
        guard let password = textField.text, let confirmPassword = newPasswordTextField.text else { return }
        continueButton.isEnabled = password == confirmPassword
        continueButton.alpha = continueButton.isEnabled ? 1 : 0.7
    }
    
    @objc private func otpTextFieldDidChange(_ textField: UITextField) {
        guard let otp = textField.text else { return }
        continueButton.isEnabled = isValidOTP(otp)
        continueButton.alpha = continueButton.isEnabled ? 1 : 0.7
    }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        let isValid = validatePassword(textField.text, rulesLabel: passwordRulesLabel)
        
        UIView.animate(withDuration: 0.25) {
            if textField.text?.isEmpty ?? true {
                // Hide when field is empty
                self.passwordRulesLabel.isHidden = true
                self.stackView.setCustomSpacing(20, after: self.newPasswordTextField)
            } else if isValid {
                // Hide when valid
                self.passwordRulesLabel.isHidden = true
                self.stackView.setCustomSpacing(20, after: self.newPasswordTextField)
            } else {
                // Show when invalid and not empty
                self.passwordRulesLabel.isHidden = false
                self.stackView.setCustomSpacing(20, after: self.passwordRulesLabel)
            }
            self.view.layoutIfNeeded()
        }
        
        guard let password = textField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            continueButton.isEnabled = false
            return
        }
        
        continueButton.isEnabled = isValid && password == confirmPassword
        continueButton.alpha = continueButton.isEnabled ? 1 : 0.7
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        switch currentStep {
        case .enterEmail:
            guard let email = enterEmailTextField.text, isValidEmail(email) else {
                showAlert(on: self, message: "Please enter a valid email address.")
                return
            }
            // Proceed to OTP step
            currentStep = .enterOTP
            enterEmailTextField.isHidden = false
            otpTextField.isHidden = false
            continueButton.setTitle("Verify OTP", for: .normal)
            continueButton.isEnabled = false
            
        case .enterOTP:
            guard let otp = otpTextField.text, isValidOTP(otp) else {
                showAlert(on: self, message: "Please enter a valid OTP (4-6 digits).")
                return
            }
            // Proceed to password change step
            currentStep = .changePassword
            otpTextField.isHidden = true
            newPasswordTextField.isHidden = false
            confirmPasswordTextField.isHidden = false
            continueButton.setTitle("Confirm", for: .normal)
            continueButton.isEnabled = false
            
        case .changePassword:
            
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

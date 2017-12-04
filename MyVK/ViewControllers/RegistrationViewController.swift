import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registrationScrollView: UIScrollView!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateBirthdayPickerTextField: UITextField!
    @IBOutlet weak var sexSegmentControl: UISegmentedControl!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    
    
    let datePicker = UIDatePicker()
    var textFieldsArray = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTextFieldsArray()
        createDatePicker()
        prepareNotifications()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func pressedContinue(_ sender: Any) {
        guard checkInfo() == true else {return}
        addUserToUserRepository()
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Other methods
    
    func fillTextFieldsArray() {
        textFieldsArray.append(nameTextField)
        textFieldsArray.append(surnameTextField)
        textFieldsArray.append(cityTextField)
        textFieldsArray.append(passwordTextField)
    }
    
    func addUserToUserRepository() {
        let userName = nameTextField.text
        let userSurname = surnameTextField.text
        let userEmail = emailTextField.text
        let userSex = sexSegmentControl.titleForSegment(at: sexSegmentControl.selectedSegmentIndex)
        let userDateBirthday = dateBirthdayPickerTextField.text
        let userCity = cityTextField.text
        let userPassword = passwordTextField.text
        UsersRepository.instance.register(user: UserWithRegistration(name: userName!, surname: userSurname!, email: userEmail!, sex: userSex!, dateBirthday: userDateBirthday!, city: userCity!, password: userPassword!))
    }
    
    //MARK: - Data Picker
    
    func createDatePicker(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        dateBirthdayPickerTextField.inputAccessoryView = toolbar
        dateBirthdayPickerTextField.inputView = datePicker
    }
    
    @objc func donePressed(){
        let dateBirthdayFormatter = DateFormatter()
        dateBirthdayFormatter.dateStyle = .medium
        dateBirthdayFormatter.timeStyle = .none
        dateBirthdayFormatter.dateFormat = "dd.MM.yyyy"
        dateBirthdayPickerTextField.text =  dateBirthdayFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //MARK: - Scroll & Keybord methods
    
    func prepareNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
 
    @objc func keyboardWillShow(notification: NSNotification){
        if var userInfo = notification.userInfo {
            var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            var contentInset:UIEdgeInsets = self.registrationScrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            registrationScrollView.contentInset = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        registrationScrollView.contentInset = .zero
    }
    
    
    //MARK: - Check methods
    
    func checkInfo() -> Bool {
        var check:Bool = true
        for currentTextField in textFieldsArray {
            if let currectText = currentTextField.text, !currectText.isEmpty {
                currentTextField.setClearBorder()
            }
            else {
                currentTextField.setRedBorder()
                check = false
            }
        }
        
        if let email = emailTextField.text, email.characters.contains("@") {
            emailTextField.setClearBorder()
        } else {
            emailTextField.setRedBorder()
            check = false
        }
        
        
        if let dateBirthday = dateBirthdayPickerTextField.text, !dateBirthday.isEmpty {
            let checkDate = checkCurrectDate(with: dateBirthday)
            if (checkDate) {
                dateBirthdayPickerTextField.setClearBorder()
            } else {
                check = false
                dateBirthdayPickerTextField.setRedBorder()
            }
        } else {
            check = false
            dateBirthdayPickerTextField.setRedBorder()
        }
        
        var userPassword = ""
        if let password = passwordTextField.text, !password.isEmpty {
            passwordTextField.setClearBorder()
            userPassword = password
        } else {
            check = false
            passwordTextField.setRedBorder()
        }
        
        if let passwordRepeat = passwordRepeatTextField.text, !passwordRepeat.isEmpty {
            let checkRepeatPassword = checkCurrectRepeatPassword(with: userPassword, and: passwordRepeat)
            if (checkRepeatPassword) {
                passwordRepeatTextField.setClearBorder()
            } else {
                passwordRepeatTextField.setRedBorder()
                check = false
            }
        } else {
            passwordRepeatTextField.setRedBorder()
            check = false
        }
        
        return check
    }
    
    func checkCurrectDate(with date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateBirthday = dateFormatter.date(from: date)
        let currentDate = NSDate()
        
        if (currentDate as Date > dateBirthday!) {
            return true
        } else {
            return false
        }
    }
    
    func checkCurrectRepeatPassword(with password: String, and repeatPassword: String) -> Bool {
        if (password == repeatPassword) {
            return true
        } else {
            return false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

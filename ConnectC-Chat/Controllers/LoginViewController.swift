//
//  LoginViewController.swift
//  ConnectC-Chat
//
//  Created by Karthikeyan Anbu on 24/04/22.
//

import UIKit

enum segueName: String{
    
    case Login
    
    var name: String {
        get { return String(describing: self) }
    }
}


enum UserType: Int, CaseIterable {
    
    case Candidate = 2, Recruiter, Direct_Recruiter
    
    var getType: Int{
        return self.rawValue
    }
    
    var name: String {
        get { return String(describing: self) }
    }
}


class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnUserType: UIButton!
    var getFCMToken: String{
        return "c2aK9KHmw8E:APA91bF7MY9bNnvGAXgbHN58lyDxc9KnuXNXwsqUs4uV4GyeF06HM1hMm-etu63S_4C-GnEtHAxJPJJC4H__VcIk90A69qQz65toFejxyncceg0_j5xwoFWvPQ5pzKo69rUnuCl1GSSv"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // resign keyboard
        self.setupToHideKeyboardOnTapOnView()
        // Do any additional setup after loading the view.
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         if segue.identifier ==  segueName.Login.name {
                 if let dataModel = sender as? LoginModel, let controller = segue.destination as? ViewController {
                     controller.loginModel = dataModel
                 }
             }
     }
    
    
}

extension LoginViewController{
    // MARK: - UserType
    @IBAction func LoginActions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            // user type
            showUserType(sender: sender)
            break
        case 2:
            // login
            loginAction()
            break
        default:
            break
        }
    }
    
    func showUserType(sender: UIButton){
        let alertController = UIAlertController(title: "User Type", message: "Select type of login", preferredStyle: .actionSheet)

        for item in UserType.allCases{
                alertController.addAction( UIAlertAction(title: item.name , style: .default, handler: { (action) in
                    print(item.name)
                sender.setTitle(item.name, for: .normal)

                }))
            }
        self.present(alertController, animated: true, completion: {
                    alertController.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController)))
        })
     }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginAction(){
        guard let emailText = txtUserName.text.nilIfEmpty, !emailText.isEmpty else { alert(message: "Email field is empty", title: "Email text")
            return }
        guard let passwordText = txtPassword.text.nilIfEmpty, !passwordText.isEmpty else { alert(message: "password field is empty", title: "Password text")
            return }
        
        guard let getUserType = btnUserType.currentTitle, getUserType != "Logintype" else { alert(message: "select loginType", title: "Login type")
            return }
        
        let body: Parameter = [ "email_or_phone": emailText, "password": passwordText, "fcm_token": getFCMToken, "user_type": checkUserType ]
        
        JSONService.login(id: body).request(type: LoginModel.self) { result in
            switch result {
            case .success(let loginModel):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: segueName.Login.name, sender: loginModel)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
 
    }
    
    var checkUserType: Int{
         for item in UserType.allCases where item.name == btnUserType.currentTitle {
            return  item.getType
        }
        
        return 2
    }
    
   
    
}

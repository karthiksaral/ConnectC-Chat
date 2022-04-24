//
//  ViewController.swift
//  ConnectC-Chat
//
//  Created by Karthikeyan Anbu on 23/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    var loginModel: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI(){
        if let getModel = loginModel{
            self.title = getModel.message
        }
        captureObserver()
        fetchChatHistory()
        fetchChatHistoryViaSocket()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

   
}

extension ViewController{
    // fetch chat history
    
    func fetchChatHistory(){
        let body: Parameter = ["user": 2]
         JSONService.fetchHistory(id: body, header: loginModel?.jwtToken ?? "").request(type: LoginModel.self) { result in
            switch result {
            case .success(let loginModel):
                 break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
    }
    
    func fetchChatHistoryViaSocket(){
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.chatMessages.append(messageInfo)
//                self.tblChat.reloadData()
//                self.scrollToBottom()
//            })
        }
    }
   
}

extension ViewController{
    func captureObserver(){
        // Here is the way how we can subscribe as observer
        NotificationCenter.default.addObserver(forName: .private_eventss, object: nil, queue: nil) { [weak self] notif in
            guard let self = self, let userInfo = notif.userInfo else { return } // Because self used more than once
             
        }
    }
    
}


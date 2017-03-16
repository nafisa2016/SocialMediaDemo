//
//  ViewController.swift
//  SocialMediaDemo
//
//  Created by Nafisa Rahman on 3/16/17.
//  Copyright © 2017 Nafisa. All rights reserved.
//  This demo shows :-
//    how to post a Twitter message
//    how to post a Facebook message
//    how to send an email

import UIKit
import Social
import MessageUI

class ViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    //MARK:- declarations
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myTextView.delegate =  self
        imagePicker.delegate = self
        
        
        myTextView.layer.cornerRadius = 5.0
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        twitterBtn.layer.cornerRadius = twitterBtn.layer.frame.width/2
        twitterBtn.clipsToBounds = true
        
        facebookBtn.layer.cornerRadius = facebookBtn.layer.frame.width/2
        facebookBtn.clipsToBounds = true
        
        mailBtn.layer.cornerRadius = mailBtn.layer.frame.width/2
        mailBtn.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- text view delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        myTextView.text = ""
        myTextView.textColor = UIColor.darkGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            myTextView.text = "Type your message"
            myTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
        
    }
    
    
    
    
    //MARK: image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard  let pickedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imgView.contentMode = .scaleAspectFit
        imgView.image = pickedImg
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- add image from photo library
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK:- twitter
    @IBAction func twitterBtnClicked(_ sender: UIButton) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let twitterMessageComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterMessageComposer?.setInitialText(myTextView.text)
            
            if imgView.image != nil {
                twitterMessageComposer?.add(imgView.image)
            }
            
            
            present(twitterMessageComposer!, animated: true, completion: nil)
            
        }else {
            showAlert(title: "Error", message: "Twitter is not available")
        }
    }
    
    //MARK:- facebook
    @IBAction func facebookBtnClicked(_ sender: UIButton) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            
            let fbMessageComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbMessageComposer?.setInitialText(myTextView.text)
            
            if imgView.image != nil {
                fbMessageComposer?.add(imgView.image)
            }
            
            present(fbMessageComposer!, animated: true, completion: nil)
            
        }else {
            showAlert(title: "Error", message: "Facebook is not available")
        }
        
        
    }
    
    //MARK:- email
    @IBAction func mailBtnClicked(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail(){
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["xxx@yyy.com"])
            mail.setSubject("swift testing")
            mail.setMessageBody(myTextView.text, isHTML: true)
            
            //attachment
            
            if let image = imgView.image {
                
                let data = UIImagePNGRepresentation(image)
                mail.addAttachmentData(data!, mimeType: "image/png", fileName: "image")
            }
            
            
            present(mail, animated: true, completion: {
                print("email sent")
            })
            
        }
        else{
            showAlert(title: "Error", message: "Email can't be sent")
        }
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- alert
    func showAlert(title: String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
        
    }
}


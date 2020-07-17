//
//  DetailedPictureViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 23/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI

class DetailedPictureViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var auteur: UILabel!
    @IBOutlet weak var pictureTitle: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    var selectedPicture: Picture?
    var pictureIndex = 0
    
    // MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date.text = selectedPicture?.dateText
        auteur.text = selectedPicture?.author
        pictureTitle.text = selectedPicture?.description
        
        if let url = selectedPicture?.imageUrl {
            //load image with some radius
            let processor = RoundCornerImageProcessor(cornerRadius: 10.0)
            pictureView.kf.setImage(with: url, placeholder: UIImage(named:"imageNotAvailable"), options: [.processor(processor)])
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            let viewController = segue.destination as? FullPictureViewController,
            id == "ShowFullPicture" {
            // pass the imageUrl to the next view
            viewController.imageUrl = selectedPicture?.imageUrl
        }
    }
    
    // MARK: - Actions
    
    /// Save picture to the device Photos album
    @IBAction func saveAction(_ sender: Any) {
        guard let inputImage = pictureView?.image else {return }
        UIImageWriteToSavedPhotosAlbum(inputImage, self, #selector(image(_:didFinishSavingWithError:)), nil)
    }
    
    /// Share the photo with system activity view
    @IBAction func shareAction(_ sender: Any) {
        if let image = pictureView?.image {
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(activity, animated: true)
        }
    }
    
    /// Send message to the picture's email owner
    /// Show simple alert if not able to use the MailCompose
    @IBAction func emailAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([selectedPicture?.email ?? ""])
            mail.setMessageBody("<p>It's about your awesome picture!</p>", isHTML: true)
            present(mail, animated: true)
            
        } else {
            // show failure alert
            let alert = UIAlertController(title: "Send error", message: "Cannot send email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    ///  Callback when saving picture is done
    ///  Show alert to confirm the save is it's done
    /// - Parameter error: saving error if occured
    ///
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "The picture has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

  // MARK: - MFMailComposeViewControllerDelegate

extension DetailedPictureViewController: MFMailComposeViewControllerDelegate {
    
    /// Close the MailComposeView when finished
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

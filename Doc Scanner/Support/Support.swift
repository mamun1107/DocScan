//
//  Support.swift
//  Doc Scanner
//
//  Created by Fahim Rahman on 7/1/21.
//

import UIKit
import AVFoundation
import RealmSwift
import Toast_Swift

// MARK: - Custom Navigation Bar Design and Function


extension UIViewController {
    
    func setCustomNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: Custom View Background Color
    
    func setViewCustomColor(view: UIView, color: UIColor) {
        
        view.backgroundColor = color
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Write Folder To Realm
    
    func writeFolderToRealm(folderName: String) {
        
        let realm = try! Realm() // realm object
        let disk = Disk() // disk object
        let myFolder = Folders() // folder object
        
        realm.beginWrite()
        
        let folder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
        
        if folderName != folder.first?.folderName {
            
            myFolder.folderName = folderName
            myFolder.folderDateAndTime = Date.getCurrentDateAndTime()
            myFolder.isPasswordProtected = false
            
            disk.folders.append(myFolder)
            
            realm.add(disk)
            do {
                try realm.commitWrite()
                self.showToast(message: "Folder Created", duration: 3.0, position: .bottom)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        else {
            self.showToast(message: "Folder Exists", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Write Document To Realm
    
    func writeDocumentToRealm(folderName: String, documentName: String, documentData: Data, documentSize: Int) {
        
        let realm = try! Realm() // realm object
        let document = Documents() // document object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
        let filteredDocument = realm.objects(Documents.self).filter("documentName == '\(documentName)'")
        
        if documentName != filteredDocument.first?.documentName {
            
            document.documentName = documentName + Date.getCurrentTime()
            document.documentData = documentData
            document.documentSize = documentSize
            document.documentDateAndTime = Date.getCurrentDateAndTime()
            document.isPasswordProtected = false
            filteredfolder.first?.documents.append(document)
            
            realm.add(document)
            do {
                try realm.commitWrite()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Document Exists", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Read Document From Realm
    
    func readDocumentFromRealm(folderName: String, sortBy: String) -> [Documents] {
        
        let realm = try! Realm() // realm object
        var myDocuments = [Documents]()
        
        let folders = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
        
        for folder in folders {
            
            for document in folder.documents.sorted(byKeyPath: sortBy, ascending: false) {
                
                myDocuments.append(document)
            }
        }
        return myDocuments
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Read Folder From Realm
    
    func readFolderFromRealm(sortBy: String) -> [Folders] {
        
        let realm = try! Realm() // realm object
        
        var myFolders = [Folders]()
        
        let folders = realm.objects(Folders.self).sorted(byKeyPath: sortBy, ascending: false)
        
        for folder in folders {
            
            if folder.folderName != "Default" {
                myFolders.append(folder)
            }
        }
        return myFolders
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Delete Folder From Realm
    
    func deleteFolderFromRealm(folderName: String) {
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let folder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
        
        if folderName == folder.first?.folderName {
            
            realm.delete(folder)
            
            do {
                try realm.commitWrite()
                self.showToast(message: "Folder(s) Deleted", duration: 3.0, position: .bottom)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "No Folder(s) Deleted", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Delete Document From Realm
    
    func deleteDocumentFromRealm(documentName: String) {
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let document = realm.objects(Documents.self).filter("documentName == '\(documentName)'")
        
        if documentName == document.first?.documentName {
            
            realm.delete(document)
            
            do {
                try realm.commitWrite()
                self.showToast(message: "Document(s) Deleted", duration: 3.0, position: .bottom)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "No Document(s) Deleted", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Update Document To Realm
    
    func updateDocumentToRealm(folderName: String, currentDocumentName: String, newDocumentName: String, newDocumentData: Data, newDocumentSize: Int) {
        
        let realm = try! Realm() // realm object
        let document = Documents() // document object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
        let filteredDocument = realm.objects(Documents.self).filter("documentName == '\(currentDocumentName)'")
    
        if currentDocumentName == filteredDocument.first?.documentName {
            
            document.documentName = newDocumentName + Date.getCurrentTime()
            document.documentData = newDocumentData
            document.documentSize = newDocumentSize
            document.documentDateAndTime = Date.getCurrentDateAndTime()
            document.isPasswordProtected = false
            
            filteredfolder.first?.documents.append(document)
            
            realm.add(document, update: .modified)
            do {
                try realm.commitWrite()
                self.showToast(message: "Modified", duration: 3.0, position: .bottom)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Couldn't Update", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Set Folder Password To Realm
    
    func setFolderPasswordToRealm(folderName: String, password: String) {
        
        print("")
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
    
        if folderName == filteredfolder.first?.folderName {
         
            realm.create(Folders.self,
                         
                         value: ["folderName": folderName,
                                 "isPasswordProtected": true,
                                 "password": password],
                         update: .modified)
            
            do {
                
                try realm.commitWrite()
                self.showToast(message: "Password Protected", duration: 3.0, position: .bottom)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Password Protection Failed", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Set Document Password To Realm
    
    
    func setDocumentPasswordToRealm(documentName: String, password: String) {
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Documents.self).filter("documentName == '\(documentName)'")
    
        if documentName == filteredfolder.first?.documentName {
         
            realm.create(Documents.self,
                         
                         value: ["documentName": documentName,
                                 "isPasswordProtected": true,
                                 "password": password],
                         update: .modified)
            
            do {
                
                try realm.commitWrite()
                self.showToast(message: "Password Protected", duration: 3.0, position: .bottom)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Password Protection Failed", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Set Rename Folder To Realm
    
    func setRenameFolderToRealm(folderName: String, newName: String, setpassword:Bool) {
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Folders.self).filter("folderName == '\(folderName)'")
    
        if folderName == filteredfolder.first?.folderName {
         
            realm.create(Folders.self,
                         
                         value: ["folderName": newName,
                                 "isPasswordProtected": setpassword,
                                 "password": filteredfolder.first?.password ?? ""],
                         update: .modified)
            
            do {
                
                try realm.commitWrite()
                self.showToast(message: "Password Protected", duration: 3.0, position: .bottom)
                
                HomeVC().myFolders.removeAll()
                HomeVC().myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
                
                HomeVC().myDocuments.removeAll()
                HomeVC().myDocuments = self.readDocumentFromRealm(folderName: folderName, sortBy: "documentSize")
                
                DispatchQueue.main.async {
                    //HomeVC().docsAndFoldsTableView.reloadData()
                    //HomeVC().docsAndFoldsCollectionView.reloadData()
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Password Protection Failed", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Set Rename Document To Realm
    
    func setRenameDocumentToRealm(documentName: String, newName: String,setpassword:Bool) {
        
        let realm = try! Realm() // realm object
        
        realm.beginWrite()
        
        let filteredfolder = realm.objects(Documents.self).filter("documentName == '\(documentName)'")
    
        if documentName == filteredfolder.first?.documentName {
         
            realm.create(Documents.self,
                         
                         value: ["documentName": newName,
                                 "isPasswordProtected": true,
                                 "password": filteredfolder.first?.password ?? ""],
                         update: .modified)
            
            do {
                
                try realm.commitWrite()
                self.showToast(message: "Password Protected", duration: 3.0, position: .bottom)
                
                HomeVC().myFolders.removeAll()
                HomeVC().myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
                
                HomeVC().myDocuments.removeAll()
                HomeVC().myDocuments = self.readDocumentFromRealm(folderName: documentName, sortBy: "documentSize")
                
                DispatchQueue.main.async {
                    //HomeVC().docsAndFoldsTableView.reloadData()
                    //HomeVC().docsAndFoldsCollectionView.reloadData()
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        else {
            self.showToast(message: "Password Protection Failed", duration: 3.0, position: .bottom)
            realm.cancelWrite()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Toast
    
    func showToast(message: String, duration: Double, position: ToastPosition) {
        
        var toastStyle = ToastStyle()
        toastStyle.messageColor = .white
        toastStyle.backgroundColor = .black
        
        self.view.makeToast(message, duration: duration, position: position, style: toastStyle)
    }
    
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK:- Use Hex Code For Color Selection

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init(hex: "ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Get Image Size In MB

extension Data {
    
    func getSizeInMB() -> Double {
        return (Double(self.count) / 1024 / 1024).rounded()
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Get Current Date Helper

extension Date {
    
    static func getCurrentDateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Zoom In An UIImage View

extension UIImageView {
    
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Alerts

class Alerts {

    func showOptionActionSheet(controller: HomeVC, folderName: String, from:String, passwordProtected:Bool, index_option:Int) {
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Set Password", style: .default, handler: { (_) in
            
            Alerts().showSetPassAlert(controller: controller, folderName: folderName, from: from)
        }))

        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (_) in
            
            if (passwordProtected == true){
                //Alerts().setRename(controller: controller, folderName: folderName, passwordProtection:passwordProtected, from:from)
                //Alerts().showSetPassAlert(controller: controller, folderName: folderName, from: from)
                if from == "folder"{
                    Alerts().showGetPassAlert(controller: controller, currentPassword: controller.myFolders[index_option].password!, index: index_option, from: "folder", for_using:"rename", passwordProtected:passwordProtected)
                }else if (from == "doc"){
                    Alerts().showGetPassAlert(controller: controller, currentPassword: controller.myDocuments[index_option].password!, index: index_option, from: "doc", for_using:"rename", passwordProtected:passwordProtected)
                }
                
                
            }else if (passwordProtected == false){
                Alerts().setRename(controller: controller, folderName: folderName, passwordProtection:passwordProtected, from:from)

            }
           // Alerts().setRename(controller: controller, folderName: folderName, passwordProtection:passwordProtected, from:from)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            UIViewController().deleteFolderFromRealm(folderName: folderName)
            UIViewController().deleteDocumentFromRealm(documentName: folderName)
        }))
        

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        controller.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    func showSetPassAlert(controller: UIViewController, folderName: String, from: String) {
        
        let alertController = UIAlertController(title: "Set a password", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Set", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                
                if from == "folder"{
                    UIViewController().setFolderPasswordToRealm(folderName: folderName, password: text)
                }else if (from == "doc"){
                    UIViewController().setDocumentPasswordToRealm(documentName: folderName, password: text)
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    

    //work for password 
    func showGetPassAlert(controller:HomeVC, currentPassword: String, index: Int, from: String, for_using: String, passwordProtected:Bool) {
        
        //print(index)
        
        let alertController = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                
                // section for folder with Password match for  Option SetPassword
                if (from == "folder" && for_using == "password") {
                    if text == currentPassword{
                        //print("password match!!!")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "folderGalleryVC") as! FolderGalleryVC
                        newViewController.folderName = controller.myFolders[index].folderName!
                        
                        controller.navigationController?.pushViewController(newViewController, animated: false)
                    }else{
                        controller.showMessageToUser(title: "Message", msg: "your password is worng try again")
                    }
                    
                }
                
                // second section for Rename
                
                else if (from == "folder" && for_using == "rename") {
                    if text == currentPassword{
                        Alerts().setRename(controller: controller, folderName: controller.myFolders[index].folderName!, passwordProtection:passwordProtected, from:from)
                    }else{
                        controller.showMessageToUser(title: "Message", msg: "your password is worng try again")
                    }
                    
                }
                
                
                // for document and setpassword option
                else if (from == "doc" && for_using == "password"){
                    
                    if text == currentPassword{
                        //print("password match!!!")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let editVC = storyBoard.instantiateViewController(withIdentifier: "editVC") as! EditVC
                        editVC.editImage = UIImage(data: controller.myDocuments[index].documentData ?? Data()) ?? UIImage()
                        editVC.currentDocumentName = controller.myDocuments[index].documentName ?? String()
                        
                        controller.navigationController?.pushViewController(editVC, animated: false)
                    }
                    else{
                        controller.showMessageToUser(title: "Message", msg: "your password is worng try again")
                    }
                    
                }
                //document and rename option calling...
                else if (from == "doc" && for_using == "rename") {
                    if text == currentPassword{
                        Alerts().setRename(controller: controller, folderName: controller.myDocuments[index].documentName!, passwordProtection:passwordProtected, from:from)
                    }else{
                        controller.showMessageToUser(title: "Message", msg: "your password is worng try again")
                    }
                    
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true,completion: nil)
        
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    func setRename(controller: UIViewController, folderName: String, passwordProtection:Bool, from:String) {
        
        let alertController = UIAlertController(title: "Set a name", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Set", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
               
                if from == "folder"{
                    UIViewController().setRenameFolderToRealm(folderName: folderName, newName: text, setpassword:passwordProtection)
                } else if(from == "doc"){
                    UIViewController().setRenameDocumentToRealm(documentName: folderName, newName: text, setpassword:passwordProtection)
                }
                
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController{
    
     func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

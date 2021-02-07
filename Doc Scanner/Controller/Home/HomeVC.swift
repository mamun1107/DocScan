//
//  HomeViewController.swift
//  Doc Scanner
//
//  Created by Fahim Rahman on 7/1/21.
//

import UIKit
import VisionKit
import RealmSwift

// MARK: Home VC

class HomeVC: UIViewController {
    
    // MARK: - Variables
    
    var galleryButtonSelected = Bool()
    var folderButtonSelected = Bool()
    
    var docsAndFoldsTableView: UITableView = UITableView()
    var docsAndFoldsCollectionView: UICollectionView!
    
    var myDocuments = [Documents]()
    var myFolders = [Folders]()
    
    var mySelectedFolder = [String]()
    var mySelectedDocument = [String]()
    
    var folderName: String = "Default"
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var topBarStackView: UIStackView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var folderButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryButtonSelected = false
        self.folderButtonSelected = true
        
        self.setCustomNavigationBar(largeTitleColor: UIColor.black, backgoundColor: UIColor.white, tintColor: UIColor.black, title: "Library", preferredLargeTitle: true)
        
        self.setViewCustomColor(view: self.view, color: UIColor(hex: "EEEEEE"))
        
        self.setNavigationElements()
        
        self.setGalleryAndFolderButtonColor()
        
        self.setDocumentCollectionView()

        self.docsAndFoldsTableView.tableFooterView = UIView()
        
        self.myDocuments.removeAll()
        
        self.myDocuments = self.readDocumentFromRealm(folderName: self.folderName, sortBy: "documentSize")
        
        self.myFolders.removeAll()
        
        self.myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
        
       // let realm = try! Realm()
        //print(realm.configuration.fileURL)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - View Did Appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
        self.setCustomNavigationBar(largeTitleColor: UIColor.black, backgoundColor: UIColor.white, tintColor: UIColor.black, title: "Library", preferredLargeTitle: true)
        
        self.setRefreshTVandCV(tvSortBy: "folderDateAndTime", cvSortBy: "documentSize")
        
        self.showToast(message: "Synced", duration: 1.0, position: .center)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("after ")
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.setCustomNavigationBar(largeTitleColor: UIColor.black, backgoundColor: UIColor.white, tintColor: UIColor.black, title: "Library", preferredLargeTitle: true)
        
        self.setRefreshTVandCV(tvSortBy: "folderDateAndTime", cvSortBy: "documentSize")
        
        self.docsAndFoldsTableView.reloadData()
        self.docsAndFoldsCollectionView.reloadData()
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Navigation Settings
    
    @objc func settingsAction() {
        print(#function)
        if let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Selection
    
    @objc func selection() {
        print(#function)
        
        // MARK: - List Button Selected
        
        //        if !self.docsAndFoldsTableView.isHidden {
        //
        //            self.docsAndFoldsTableView.isEditing = !self.docsAndFoldsTableView.isEditing
        //
        //            if self.docsAndFoldsTableView.isEditing {
        //
        //                self.navigationItem.rightBarButtonItem?.title = "Delete"
        //            }
        //            else {
        //
        //                self.navigationItem.rightBarButtonItem?.title = "Select"
        //
        //                if !mySelectedFolder.isEmpty {
        //
        //                    for deleteFolder in mySelectedFolder {
        //
        //                        self.deleteFolderFromRealm(folderName: deleteFolder)
        //
        //                        self.myFolders.removeAll()
        //                        self.myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
        //                    }
        //
        //                    self.mySelectedFolder.removeAll()
        //
        //                    DispatchQueue.main.async {
        //                        self.docsAndFoldsTableView.reloadData()
        //                    }
        //                }
        //
        //
        //                if !self.mySelectedDocument.isEmpty {
        //
        //                    for deleteDocument in mySelectedDocument {
        //
        //                        self.deleteDocumentFromRealm(documentName: deleteDocument)
        //
        //                        self.myDocuments.removeAll()
        //                        self.myDocuments = self.readDocumentFromRealm(folderName: self.folderName, sortBy: "documentSize")
        //                    }
        //
        //                    self.mySelectedDocument.removeAll()
        //
        //                    DispatchQueue.main.async {
        //                        self.docsAndFoldsTableView.reloadData()
        //                    }
        //                }
        //            }
        //        }
        
        
        
        //-------------------------------------------------------------------------------------------------------------------------------------------------
        
        
        
        // MARK: - Grid Button Selected
        
        if !self.docsAndFoldsCollectionView.isHidden {
            
            self.docsAndFoldsCollectionView.allowsMultipleSelection = !self.docsAndFoldsCollectionView.allowsMultipleSelection
            
            if self.docsAndFoldsCollectionView.allowsMultipleSelection {
                
                self.navigationItem.rightBarButtonItem?.title = "Delete"
            }
            else {
                
                self.navigationItem.rightBarButtonItem?.title = "Select"
                
                //                if !self.mySelectedDocument.isEmpty {
                //                    print(self.mySelectedDocument)
                //                    for deleteDocument in mySelectedDocument {
                //                        print("for loop")
                //                        self.deleteDocumentFromRealm(documentName: deleteDocument)
                //                    }
                //
                //                    self.mySelectedDocument.removeAll()
                //
                //                    //self.myDocuments.removeAll()
                //                    //self.myDocuments = self.readDocumentFromRealm(folderName: self.folderName, sortBy: "documentSize")
                //
                //                    self.setRefreshTVandCV(tvSortBy: "folderDateAndTime", cvSortBy: "documentSize")
                //                    DispatchQueue.main.async {
                //                        print("reload data")
                //                        self.docsAndFoldsCollectionView.reloadData()
                //                    }
                //                }
                
                
                //                if !self.mySelectedFolder.isEmpty {
                //
                //                    for deleteFolder in mySelectedFolder {
                //
                //                        self.deleteFolderFromRealm(folderName: deleteFolder)
                //                    }
                //
                //                    self.mySelectedFolder.removeAll()
                //
                //                    //self.myFolders.removeAll()
                //                    //self.myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
                //
                //                    self.setRefreshTVandCV(tvSortBy: "folderDateAndTime", cvSortBy: "documentSize")
                //                    DispatchQueue.main.async {
                //                        self.docsAndFoldsCollectionView.reloadData()
                //                    }
                //                }
            }
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Add Folder
    
    @IBAction func addFolderPressed(_ sender: UIButton) {
        print(#function)
        if let createFolderVC = self.storyboard?.instantiateViewController(withIdentifier: "createFolderVC") as? CreateFolderVC {
            
            self.navigationController?.present(createFolderVC, animated: true)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Folders
    
    @IBAction func foldersPressed(_ sender: UIButton) {
        print(#function)
        
        
        if self.folderButtonSelected == true {
            
            self.docsAndFoldsCollectionView.isHidden = true
            self.docsAndFoldsTableView.isHidden = false
            
            self.docsAndFoldsCollectionView.removeFromSuperview()
            
            self.setFolderButtonColor()
            
            self.setFolderTableView()
            
            // when folder button is selected do -
            
            self.myFolders.removeAll()
            self.myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
            
            self.myDocuments.removeAll()
            self.myDocuments = self.readDocumentFromRealm(folderName: folderName, sortBy: "documentSize")
            
            DispatchQueue.main.async {
                self.docsAndFoldsTableView.reloadData()
            }
            
            self.galleryButtonSelected = true
            self.folderButtonSelected = false
            //self.setDocumentCollectionView()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Gallery
    
    @IBAction func galleryPressed(_ sender: UIButton) {
        print(#function)
        
        if self.galleryButtonSelected == true {
            
            self.docsAndFoldsTableView.isHidden = true
            self.docsAndFoldsCollectionView.isHidden = false
            
            self.docsAndFoldsTableView.removeFromSuperview()
            
            self.setGalleryButtonColor()
            
            self.setDocumentCollectionView()
            
            // When gallery button is selected do -
            
            self.myFolders.removeAll()
            self.myFolders = self.readFolderFromRealm(sortBy: "folderDateAndTime")
            
            self.myDocuments.removeAll()
            self.myDocuments = self.readDocumentFromRealm(folderName: folderName, sortBy: "documentSize")
            
            DispatchQueue.main.async {
                self.docsAndFoldsCollectionView.reloadData()
            }
            
            self.galleryButtonSelected = false
            self.folderButtonSelected = true
            //self.setFolderTableView()
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Filter
    
    @IBAction func filterPressed(_ sender: UIButton) {
        print(#function)
        
        self.setActionSheet()
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Search
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(#function)
        
        print("search Pressed!!!")
        if let createSearchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            createSearchVC.totalFolders = self.myFolders
            createSearchVC.totalDocuments = self.myDocuments
            
            self.navigationController?.present(createSearchVC, animated: true)
        }
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.modalPresentationStyle = .popover
//
//        alert.overrideUserInterfaceStyle = .light
//
//        let image = UIImage(named: "folder_image")
//        let imageView = UIImageView()
//        imageView.image = image
//        imageView.frame =  CGRect(x: view.frame.midX - (view.frame.midX)/2.0 - 20, y: 18, width: 24, height: 24)
//        alert.view.addSubview(imageView)
//
//        let image1 = UIImage(named: "folder_lock_image")
//        let imageView1 = UIImageView()
//        imageView1.image = image1
//        alert.view.addSubview(imageView1)
//        imageView1.frame = CGRect(x: view.frame.midX - (view.frame.midX)/2.0 - 20, y: 75, width: 24, height: 24)
//
//        let shareExternal = UIAlertAction(title: NSLocalizedString("Share External Link", comment: ""), style: .default) { action in
//            print("hello inside")
//        }
//        let shareInApp = UIAlertAction(title: "Share within", style: .default)   {
//            action in
//            print("hello outside")
//        }
//        alert.view.tintColor = .black
//        alert.addAction(shareInApp)
//        alert.addAction(shareExternal)
//
//        present(alert, animated: true, completion: nil)
        
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Camera
    @IBAction func cameraPressed(_ sender: UIButton) {
        print(#function)
        
        let vnDocVC = VNDocumentCameraViewController()
        vnDocVC.delegate = self
        present(vnDocVC, animated: false)
        
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Home VC Folder Table View

extension HomeVC: UITableViewDelegate, UITableViewDataSource, CellDelegateTV {
    
    // MARK: - Number Of Rows In Section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Number Of Section
    
    func numberOfSections(in tableView: UITableView) -> Int { return self.myFolders.count + self.myDocuments.count }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - TV Cell Option Button
    
    func optionButtonTV(index: Int) {
        
        if index < self.myFolders.count {
            Alerts().showOptionActionSheet(controller: self, folderName: self.myFolders[index].folderName ?? "", from: "folder", passwordProtected:self.myFolders[index].isPasswordProtected, index_option:index)
        }
        else {
            Alerts().showOptionActionSheet(controller: self, folderName: self.myDocuments[index - self.myFolders.count].documentName ?? "", from: "doc", passwordProtected:self.myDocuments[index - self.myFolders.count].isPasswordProtected,index_option:index - self.myFolders.count)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Cell For Row At
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = docsAndFoldsTableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! docsAndFoldsTVCell
        
        cell.cellDelegate = self
        
        if indexPath.section < self.myFolders.count {
            
            if self.myFolders[indexPath.section].isPasswordProtected == true{
                cell.docsAndFoldsImageView.image = UIImage(named: "folder_lock_image")
                
            }else{
                //here changed the image of folder images
                cell.docsAndFoldsImageView.image = UIImage(named: "folder_image")
                
            }
            cell.nameLabel.text = self.myFolders[indexPath.section].folderName
            cell.numberOfItemsLabel.text = String(self.myFolders[indexPath.section].documents.count) + " Document(s)"
            
            cell.optionButton.tag = indexPath.section
            
            
        }
        
        else {
            
            if self.myDocuments[indexPath.section - self.myFolders.count].isPasswordProtected == true{
                cell.docsAndFoldsImageView.image = UIImage(named: "file_lock_image")
                
            }else{
                //here changed the image of folder images
                cell.docsAndFoldsImageView.image = UIImage(data: self.myDocuments[indexPath.section - self.myFolders.count].documentData ?? Data())
                
            }
            cell.nameLabel.text = self.myDocuments[indexPath.section - self.myFolders.count].documentName
            cell.numberOfItemsLabel.text = "1 Document"
            
            cell.optionButton.tag = indexPath.section
        }
        
        return self.setFolderCell(cell: cell)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Height For Row At
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - Height For Header In Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - View For Header In Section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Did Select Row At
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, indexPath.section)
        
        if !self.docsAndFoldsTableView.isEditing {
            
            if indexPath.section < self.myFolders.count {
                print("for only folder!! tableView section")
                
                if let folderGalleryVC = self.storyboard?.instantiateViewController(withIdentifier: "folderGalleryVC") as? FolderGalleryVC {
                    
                    if self.myFolders[indexPath.section].isPasswordProtected == false {
                        
                        folderGalleryVC.folderName = self.myFolders[indexPath.section].folderName!
                        
                        self.navigationController?.pushViewController(folderGalleryVC, animated: false)
                    }
                    else {
                        print("here it is")
                        
                        Alerts().showGetPassAlert(controller: self, currentPassword: self.myFolders[indexPath.section].password!, index: indexPath.section, from: "folder", for_using: "password", passwordProtected: true)
                        
                    }
                }
            }
            else {
                
                print("for document tableView Section")
                
                
                
                if let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editVC") as? EditVC {
                    
                    if self.myDocuments[indexPath.section - self.myFolders.count].isPasswordProtected == false {
                        print("false")
                        editVC.editImage = UIImage(data: self.myDocuments[indexPath.section - self.myFolders.count].documentData ?? Data()) ?? UIImage()
                        editVC.currentDocumentName = self.myDocuments[indexPath.section - self.myFolders.count].documentName ?? String()
                        
                        self.navigationController?.pushViewController(editVC, animated: true)
                    }else{
                        print("true")
                        Alerts().showGetPassAlert(controller: self, currentPassword: self.myDocuments[indexPath.section - self.myFolders.count].password!, index: indexPath.section - self.myFolders.count, from: "doc", for_using: "password", passwordProtected: true)
                    }
                    
                    
                    
                }
            }
        }
        else {
            
            if indexPath.section < self.myFolders.count {
                
                self.mySelectedFolder.append(self.myFolders[indexPath.section].folderName!)
            }
            else {
                
                self.mySelectedDocument.append(self.myDocuments[indexPath.section - self.myFolders.count].documentName!)
            }
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Did Deselect Row At
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print(#function, indexPath.section)
        
        if self.docsAndFoldsTableView.isEditing {
            
            if indexPath.section < self.myFolders.count {
                
                self.mySelectedFolder.removeAll(where: { $0 == self.myFolders[indexPath.section].folderName })
            }
            else {
                
                self.mySelectedDocument.removeAll(where: { $0 == self.myDocuments[indexPath.section - self.myFolders.count].documentName })
            }
        }
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: - Document Collection View

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CellDelegateCV {
    
    
    // MARK: - Number Of Items In Section
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.myFolders.count + self.myDocuments.count
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - CV Cell Option Button
    
    func optionButtonCV(index: Int) {
        
        if index < self.myFolders.count {
            Alerts().showOptionActionSheet(controller: self, folderName: self.myFolders[index].folderName ?? "", from: "folder", passwordProtected:self.myFolders[index].isPasswordProtected, index_option:index)
        }
        else {
            print("here it is call for doc...")
            Alerts().showOptionActionSheet(controller: self, folderName: self.myDocuments[index - self.myFolders.count].documentName ?? "",from: "doc", passwordProtected:self.myDocuments[index - self.myFolders.count].isPasswordProtected, index_option:index - self.myFolders.count)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Cell For Item At
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = docsAndFoldsCollectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as! DocsAndFoldsCVCell
        
        cell.cellDelegate = self
      
        if indexPath.row < self.myFolders.count {
            
            if self.myFolders[indexPath.row].isPasswordProtected == true{
                cell.docsAndFoldsImageView.image = UIImage(named: "folder_lock_image")
                
            }else{
                //here changed the image of folder images
                cell.docsAndFoldsImageView.image = UIImage(named: "folder_image")
                
            }
            
            //cell.docsAndFoldsImageView.image = UIImage(named: "folder_image")
            cell.nameLabel.text = self.myFolders[indexPath.row].folderName
            cell.numberOfItemsLabel.text = String(self.myFolders[indexPath.row].documents.count) + " Document(s)"
            
            cell.optionButton.tag = indexPath.row
        }
        else {
            
            if self.myDocuments[indexPath.row - self.myFolders.count].isPasswordProtected == true{
                cell.docsAndFoldsImageView.image = UIImage(named: "file_lock_image")
                
            }else{
                //here changed the image of folder images
                cell.docsAndFoldsImageView.image = UIImage(data: self.myDocuments[indexPath.row - self.myFolders.count].documentData ?? Data())
                
            }
            
            //cell.docsAndFoldsImageView.image = UIImage(data: self.myDocuments[indexPath.row - self.myFolders.count].documentData ?? Data())
            cell.nameLabel.text = self.myDocuments[indexPath.row - self.myFolders.count].documentName
            cell.numberOfItemsLabel.text = "1 Document"
            
            cell.optionButton.tag = indexPath.row
        }
        
        return self.setDocumentCell(cell: cell)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Collection View Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsInRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))
        
        return CGSize(width: size, height: size + 30)
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Did Select Item At
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell : UICollectionViewCell = self.docsAndFoldsCollectionView.cellForItem(at: indexPath)!
        
        cell.backgroundColor = UIColor(hex: "EB5757")
        
        if !self.docsAndFoldsCollectionView.allowsMultipleSelection {
            
            if indexPath.row < self.myFolders.count {
                print("multiple section called!!!")
                
                if self.myFolders[indexPath.row].isPasswordProtected == false {
                    
                    if let folderGalleryVC = self.storyboard?.instantiateViewController(withIdentifier: "folderGalleryVC") as? FolderGalleryVC {
                        
                        folderGalleryVC.folderName = self.myFolders[indexPath.row].folderName!
                        
                        self.navigationController?.pushViewController(folderGalleryVC, animated: false)
                    }
                }
                else {
                    Alerts().showGetPassAlert(controller: self, currentPassword: self.myFolders[indexPath.row].password!, index: indexPath.row, from: "folder", for_using: "password", passwordProtected: true)
                }
            }
            else {
                print("single section called!!!")
                print(indexPath.row - self.myFolders.count)
                if self.myDocuments[indexPath.row - self.myFolders.count].isPasswordProtected == true{
                    print("true")
                    Alerts().showGetPassAlert(controller: self, currentPassword: self.myDocuments[indexPath.row - self.myFolders.count].password!, index: indexPath.row - self.myFolders.count, from: "doc", for_using: "password", passwordProtected: true)
                } else{
                    
                    if let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editVC") as? EditVC {
                        editVC.editImage = UIImage(data: self.myDocuments[indexPath.row - self.myFolders.count].documentData ?? Data()) ?? UIImage()
                        editVC.currentDocumentName = self.myDocuments[indexPath.row - self.myFolders.count].documentName ?? String()
                        
                        self.navigationController?.pushViewController(editVC, animated: true)
                    }
                    
                }
            }
        }
        else {
            
            if indexPath.row < self.myFolders.count {
                
                self.mySelectedFolder.append(self.myFolders[indexPath.row].folderName!)
            }
            else {
                self.mySelectedDocument.append(self.myDocuments[indexPath.row - self.myFolders.count].documentName!)
            }
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    // MARK: - Did Deselect Item At
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function, indexPath.row)
        
        let cell : UICollectionViewCell = self.docsAndFoldsCollectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = .white
        
        if self.docsAndFoldsCollectionView.allowsMultipleSelection {
            
            if indexPath.row < self.myFolders.count {
                
                self.mySelectedFolder.removeAll(where: { $0 == self.myFolders[indexPath.row].folderName })
                
            }
            else {
                
                self.mySelectedDocument.removeAll(where: { $0 == self.myDocuments[indexPath.row - self.myFolders.count].documentName })
            }
        }
    }
}




//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------------




// MARK: - VN Document Camera View Controller Delegates

extension HomeVC: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        var rawImages: [UIImage] = [UIImage]()
        
        for pageNumber in 0..<scan.pageCount {
            
            let image = scan.imageOfPage(at: pageNumber)
            rawImages.append(image)
        }
        
        if scan.pageCount == 1 {
            
            if let imageData = rawImages.first?.jpegData(compressionQuality: 0.9) {
                
                self.writeDocumentToRealm(folderName: self.folderName, documentName: "Doc", documentData: imageData, documentSize: Int(imageData.getSizeInMB()))
            }
        }
        else {
            
            let createdCustomFolderName = "Custom\(Date.getCurrentTime())"
            
            for rawImage in 0..<rawImages.count {
                
                if let imageData = rawImages[rawImage].jpegData(compressionQuality: 0.9) {
                    
                    self.writeFolderToRealm(folderName: createdCustomFolderName)
                    
                    self.writeDocumentToRealm(folderName: createdCustomFolderName, documentName: "Doc", documentData: imageData, documentSize: Int(imageData.getSizeInMB()))
                }
            }
        }
        //edit:
        controller.dismiss(animated: true)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error.localizedDescription)
        controller.dismiss(animated: true)
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}

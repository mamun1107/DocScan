//
//  SearchViewController.swift
//  Doc Scanner
//
//  Created by LollipopMacbook on 6/2/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    // variable
    var totalFolders = [Folders]()
    var totalDocuments = [Documents]()
    
    var searchallName = [String]()
    var totalallName = [String]()

    
    var searching = false
    var selected: String?

    
   
    
    var totaldata = Int()
    var searchdata = Int()
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        print(totalFolders.count + totalDocuments.count)
        insertData()
        //totaldata = totalFolders.count + totalDocuments.count
        
        setupSearchTableView()

        // Do any additional setup after loading the view.
        //self.searchBar.barTintColor = UIColor.colorFromHex("#BC214B")
        //self.searchBar.tintColor = UIColor.white
        // Show/Hide Cancel Button
        self.searchBar.showsCancelButton = true
    
        // Change TextField Colors
        let searchTextField = self.searchBar.searchTextField
        //searchTextField.textColor = UIColor.white
        searchTextField.clearButtonMode = .whileEditing
        //searchTextField.clearsOnBeginEditing =
    
//        let glassIconView = searchTextField.leftView as! UIImageView
//        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
       // glassIconView.tintColor = UIColor.colorFromHex("#BC214B")
        
        
        self.searchBar.keyboardAppearance = .dark
        //tableView.separatorColor = UIColor.red
        
        self.tableView.separatorStyle = .none
        //self.tableView.tintColor = UIColor.white
        //self.tableView.backgroundColor = UIColor.colorFromHex("#9E1C40")
        
        //self.listOfCountries()
    }
 
    func insertData(){
         let totaldata = self.totalFolders.count
        
        for i in 0..<totaldata{
            self.totalallName.append(self.totalFolders[i].folderName ?? "")
           // self.totalallImage.append(self.totalFolders[i].)
        }
        
        let totaldocdata = self.totalDocuments.count
        
        for i in 0..<totaldocdata{
            self.totalallName.append(self.totalDocuments[i].documentName ?? "")
        }
    }
    
    
    func setupSearchTableView(){
        self.tableView.register(UINib(nibName: "FolderTVCell", bundle: nil), forCellReuseIdentifier: "folderCell")
    }
//
//    func listOfCountries() {
//        for code in NSLocale.isoCountryCodes as [String] {
//            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
//            let name = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
//            countryList.append(name + " " + countryFlag(country: code))
//            tableView.reloadData()
//        }
//    }
    
    // Add Flag Emoji
//    func countryFlag(country: String) -> String {
//        let base: UInt32 = 127397
//        var s = ""
//        for v in country.unicodeScalars {
//            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
//        }
//        return String(s)
//    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Number Of Rows In Section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Number Of Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return self.searchallName.count
        } else {
            return self.totalallName.count
        }
        
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Cell For Row At
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = docsAndFoldsTableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! docsAndFoldsTVCell
//
//        if indexPath.section < self.myFolders.count {
//            //here changed the image of folder images
//            cell.docsAndFoldsImageView.image = UIImage(named: "folder_image")
//            cell.nameLabel.text = self.myFolders[indexPath.section].folderName
//            cell.numberOfItemsLabel.text = String(self.myFolders[indexPath.section].documents.count) + " Document(s)"
//        }
//
//        else {
//
//            cell.docsAndFoldsImageView.image = UIImage(data: self.myDocuments[indexPath.section - self.myFolders.count].documentData ?? Data())
//            cell.nameLabel.text = self.myDocuments[indexPath.section - self.myFolders.count].documentName
//            cell.numberOfItemsLabel.text = "1 Document"
//        }
//
//        return self.setFolderCell(cell: cell)
//    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Height For Row At
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - Height For Header In Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    // MARK: - View For Header In Section
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! docsAndFoldsTVCell
        
        if searching {
 
            cell.nameLabel.text = self.searchallName[indexPath.section]
        
        } else {
            
            cell.nameLabel.text = self.totalallName[indexPath.section]

        }
        
        
        return self.setFolderCell(cell: cell)
    }
    
    func setFolderCell(cell: UITableViewCell) -> UITableViewCell {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        cell.multipleSelectionBackgroundView = view
        cell.backgroundColor = .white
        
        //cell.selectionStyle = .default
        //cell.tintColor = UIColor(hex: "EB5757")
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    
   
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        if searching {
//            cell.textLabel?.text = searchedCountry[indexPath.row]
//        } else {
//            cell.textLabel?.text = countryList[indexPath.row]
//        }
//       // cell.textLabel?.textColor = UIColor.white
//       // cell.backgroundColor = UIColor.clear
//        let myCustomSelectionColorView = UIView()
//       // myCustomSelectionColorView.backgroundColor = UIColor.colorFromHex("#BC214B")
//        cell.selectedBackgroundView = myCustomSelectionColorView
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if searching {
//            let selectedCountry = searchedCountry[indexPath.row]
//            selected = selectedCountry
//        } else {
//            let selectedCountry = countryList[indexPath.row]
//            selected = selectedCountry
//        }
//        performSegue(withIdentifier: "detailsviewcontrollerseg", sender: self)
//        // Remove highlight from the selected cell
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Close keyboard when you select cell
//        self.searchBar.searchTextField.endEditing(true)
//    }
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchedCountry = countryList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searchallName = totalallName.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        tableView.reloadData()
    }
//every thing s is ok
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

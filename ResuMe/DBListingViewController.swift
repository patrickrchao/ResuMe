//
//  TableViewController.swift
//  SwiftyDropDataListing
//
//  Created by Sahil on 18/04/17.
//  Copyright © 2017 SahilBeri. All rights reserved.
//
import UIKit
import SwiftyDropbox

protocol SelectedDropboxData {
    func getDropboxSelectedData(_ dataArr: [String])
}

class DBListingViewController: UITableViewController, UISearchBarDelegate {
    
    var filesArr: [Files.Metadata] = []
    var filteredArr:[Files.Metadata] = []
    var searchActive : Bool = false
    var delegate:SelectedDropboxData?
    var request: DownloadRequestFile<Files.FileMetadataSerializer, Files.DownloadErrorSerializer>?
    var cache:NSCache<AnyObject, AnyObject> = NSCache()
    var loaderBGView: UIView!
    var progressView: UIProgressView!
    var lblPercentage: UILabel!
    var cancelBtn: UIButton!
    var searchBar:UISearchBar!
    var activityIndicatorBGView: UIView?
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cr
        let logoutBarBtn = UIBarButtonItem(title:"Log Out", style:UIBarButtonItemStyle.plain, target: self, action:#selector(self.logoutBtnClicked))
        self.navigationItem.rightBarButtonItem = logoutBarBtn
        
        self.tableView.register(DropboxListingCell.self, forCellReuseIdentifier: "DropboxListingCell")
        if activityIndicatorBGView == nil{
            makeActivityIndicator()
        }
        addSearchBar()
        makeLoader()
    }
    
    // Unlink dropbox
    func logoutBtnClicked(_ sender: UIBarButtonItem)  {
        // signout
        DropboxClientsManager.unlinkClients()
    }
    
    // MARK: - Table view data source and delegate methods.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DropboxListingCell") as! DropboxListingCell
        cell = DropboxListingCell(style: .default, reuseIdentifier: "DropboxListingCell")
        
        if let image = loadImage(name: "sp_folder") {
            cell.listImageView.image = image.withRenderingMode(.alwaysTemplate)
            cell.listImageView.tintColor = UIColor.init(colorLiteralRed: 248/255.0, green: 204/255.0, blue: 69/255.0, alpha: 1.0)
        }
        
        let fileInfo = filteredArr[indexPath.row]
        
        switch (fileInfo.name as NSString).pathExtension {
        case "bmp" , "cr2", "gif", "ico", "ithmb", "jpeg", "jpg", "nef", "png", "raw", "svg", "tif", "tiff", "wbmp", "webp":
            
            // saving image in cache
            if self.cache.object(forKey: fileInfo.pathLower as AnyObject) != nil {
                cell.listImageView.image = self.cache.object(forKey: fileInfo.pathLower as AnyObject) as? UIImage
            }
            else {
                
                if let image = loadImage(name: "sp_page_dark_picture"){
                    image.withRenderingMode(.alwaysTemplate)
                    cell.listImageView.image = image.imageWithColor(UIColor.lightGray)
                }
                if let client = DropboxClientsManager.authorizedClient {
                    client.files.download(path: fileInfo.pathLower!)
                        .response(completionHandler: { (file, error) in
                            if let fileInfo = file {
                                cell.listImageView.image = UIImage(data: (fileInfo.1))
                                self.cache.setObject(cell.listImageView.image!, forKey: fileInfo.0.id as AnyObject)
                            }
                        })
                }
            }
        //document
        case "csv", "doc", "docx", "docm", "ods", "odt", "pdf", "rtf", "xls", "xlsm", "xlsx":
            if let image = loadImage(name: "sp_page_dark_excel"){
                image.withRenderingMode(.alwaysTemplate)
                // cell.listImageView.image = image.imageWithColor(UIColor.init(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0))
                cell.listImageView.image = image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.tintColor = UIColor.red
            }
            
            //sp_page_dark_excel
        //presentation
        case "odp" , "pps" ,"ppsm" ,"ppsx", "ppt", "pptm", "pptx":
            if let image = loadImage(name: "sp_page_dark_powerpoint"){
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.init(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0))
            }
            
            //sp_page_dark_powerpoint
        //video
        case "3gp", "3gpp", "3gpp2", "asf", "avi", "dv", "flv", "m2t", "m2t", "m4v", "mkv", "mov", "mp4", "mpeg", "mpg", "mts", "oggtheora", "ogv", "rm", "ts", "vob", "webm", "wmv":
            if let image = loadImage(name: "sp_page_dark_film"){
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.init(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0))
            }
            //sp_page_dark_film
        //AUDIO
        case "aac", "m4a", "mp3", "oga", "wav":
            if let image = loadImage(name: "sp_page_dark_mp3"){
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.red)
            }
        //sp_page_dark_mp3
        case "url", "webloc", "website":
            if let image = loadImage(name: "sp_page_dark_webcode") {
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.black)
            }
            //sp_page_dark_webcode
        //Text
        case "as", "as3", "asm", "aspx", "bat", "c", "cc", "cmake", "coffee", "cpp" , "cs", "css", "cxx" ,"diff", "erb", "erl", "groovy", "gvy", "h", "haml", "hh", "hpp", "hxx", "java", "js", "json", "jsx", "less", "lst", "m", "make", "markdown", "md", "mdown", "mkdn", "ml", "mm", "out", "patch", "php", "pl", "plist", "properties", "py", "rb", "sass", "scala", "scm", "script", "scss", "sh", "sml", "sql", "txt", "vb", "vi", "vim", "xhtml", "xml", "xsd", "xsl", "yaml", "yml":
            if let image = loadImage(name: "sp_page_dark_text"){
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.gray)
            }
        //sp_page_dark_text
        case "zip":
            if let image = loadImage(name: "sp_page_dark_compressed"){
                image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.image = image.imageWithColor(UIColor.init(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0))
            }
        //sp_page_dark_compressed
        default:
            if let image = loadImage(name: "sp_folder"){
                //        image.withRenderingMode(.alwaysTemplate)
                //        cell.listImageView.image = image.imageWithColor(UIColor.init(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0))
                cell.listImageView.image = image.withRenderingMode(.alwaysTemplate)
                cell.listImageView.tintColor = UIColor.init(colorLiteralRed: 248/255.0, green: 204/255.0, blue: 69/255.0, alpha: 1.0)
                
            }
            //sp_folder
        }
        cell.fileName.text = fileInfo.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (filteredArr[indexPath.row].name as NSString).pathExtension == "" {
            activityIndicatorBGView?.isHidden = false
            activityIndicatorView.startAnimating()
            if let client = DropboxClientsManager.authorizedClient {
                
                // List folder
                client.files.listFolder(path: filteredArr[indexPath.row].pathLower!).response { response, error in
                    
                    print("*** List folder ***")
                    
                    if let result = response {
                        self.activityIndicatorBGView?.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                        print(result)
                        print("Folder contents:")
                        let tableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableViewController") as! DBListingViewController
                        tableViewController.filesArr = result.entries
                        tableViewController.filteredArr = result.entries
                        self.navigationController?.pushViewController(tableViewController, animated: true)
                    } else {
                        
                        //TODO: show message here to user
                    }
                }
            }
        } else {
            loaderBGView.isHidden = false
            progressView.progress = 0
            lblPercentage.text = "\(progressView.progress) %"
            // self.view.isUserInteractionEnabled = false
            //[self.downloadButton startProgressing];
            if let client = DropboxClientsManager.authorizedClient {
                let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    let fileManager = FileManager.default
                    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    print("@@@@@@@@@@ ")
                    print(directoryURL)
                    print("!!!!!!!!!!!!!")
                    let dataPath = directoryURL.appendingPathComponent("DropboxData")
                    print(dataPath)
                    if !FileManager.default.fileExists(atPath: dataPath.path) {
                        do {
                            // create Resumes folder
                            try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
                        } catch let error as NSError {
                            print(error.localizedDescription);
                        }
                    }
                    
                    let pathComponent = directoryURL.appendingPathComponent("DropboxData")
                    let path = pathComponent.appendingPathComponent(self.filteredArr[indexPath.row].name)
                    print(path)
                    
                    // if file is already exist then delete it first
                    if FileManager.default.fileExists(atPath: path.path) {
                        do {
                            try FileManager.default.removeItem(atPath: path.path)
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                    }
                    return path
                }
                
                print(destination)
                
                // download file here in destination.
                self.request = client.files.download(path: self.filteredArr[indexPath.row].pathLower!, destination: destination)
                
                request?.progress{ progressData in
                    self.progressView.progress = Float(progressData.fractionCompleted)
                    self.lblPercentage.text = String(format: "%.0f %%", (progressData.fractionCompleted*100))
                }

            
                client.sharing.listSharedLinks(path: self.filteredArr[indexPath.row].pathLower!).response { response, error in
                    if let link = response {
                        print("@@@@@@@@#$%@#$^@#$^@#$%@$#%@$#%")
                       
                    } else {
                        print("*************")
                        print(error)
                    }
                }
                let link = "https://www.dropbox.com/s/xyjveh14e57807q/Patrick%20Chao%20Resume.pdf?dl=1"
                
                client.sharing.createSharedLinkWithSettings(path: self.filteredArr[indexPath.row].pathLower!).response { response, error in
                    if let link = response {
                        print("@@@@@@@@#$%@#$^@#$^@#$%@$#%@$#%")
                        print(link)
                        
                    } else {
                        print("*************")
                        print(error)
                    }
                }

                request?.response { response, error in
                    self.loaderBGView.isHidden = true
                    if let (metadata, url) = response {
                        
                        print(url.pathExtension)
                        print(url)
                        
                        let data = try? Data(contentsOf: url)
                        print("Downloaded file name: \(metadata.name)")
                        print("Downloaded file url: \(url)")
                        print("Downloaded file data: \(data)")
                        self.delegate?.getDropboxSelectedData([url.absoluteString])
                        //  self.getSelectedData!([url.absoluteString])
                        let _ = self.navigationController?.popViewController(animated: true)
                        //self.performSegue(withIdentifier: "FileViewerViewController", sender: nil)
                    } else {
                        print(error?.description)
                        
                        // Utilities.showAlertForMessage(message: (error?.description)!)
                    }
                }
            }
        }
        
    }
    
    /// show dropbox data in tableview
    func showDropboxData() {
        
        // check user is authorizedClient or not
        // if yes then hit dropbox api and save data in dropboxData  and dropboxDataPath variables.
        if activityIndicatorBGView == nil{
            makeActivityIndicator()
        }
        activityIndicatorBGView?.isHidden = false
        activityIndicatorView.startAnimating()
        if let client = DropboxClientsManager.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            client.files.listFolder(path: "", recursive: false, includeMediaInfo: true, includeDeleted: false, includeHasExplicitSharedMembers: true)
                .response { response, error in
                    print("*** List folder ***")
                    self.activityIndicatorBGView?.isHidden = true
                    self.activityIndicatorView.stopAnimating()
                    if let result = response {
                        print("Folder contents:%@", result)
                        self.filesArr = result.entries
                        self.filteredArr = result.entries
                        self.tableView.reloadData()
                    } else {
                        //show error message
                        print("error")
                    }
            }
        }
    }
    
    //MARK: IBACTIONS
    
    func cancelBtnClicked(_ sender: AnyObject){
        request?.cancel()
    }
    
    //MARK: CUSTOM METHODS
    
    func getDBClient() -> DropboxClient?{
        return DropboxClientsManager.authorizedClient
    }
    
    func addSearchBar(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44.0))
        self.searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        
    }
    
    func makeLoader(){
        loaderBGView = UIView(frame: self.view.frame)
        loaderBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        progressView = UIProgressView(frame: CGRect(x: 30, y: ((self.view.frame.size.height/2) - 10), width: self.view.frame.size.width-60, height: 10.0))
        progressView.progress = 0.0
        progressView.tintColor = UIColor(colorLiteralRed: 200/255.0, green: 200/255.0, blue: 48/255.0, alpha: 1.0)
        progressView.trackTintColor = UIColor.white
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        
        let lblDownload = UILabel(frame: CGRect(x: 30, y: progressView.frame.origin.y-30, width: self.view.frame.size.width-60, height: 20.0))
        lblDownload.text = "Downloading"
        lblDownload.textColor = UIColor.white
        lblDownload.textAlignment = .center
        
        lblPercentage = UILabel(frame: CGRect(x: 30, y: progressView.frame.size.height + progressView.frame.origin.y+5, width: self.view.frame.size.width-60, height: 15.0))
        lblPercentage.textColor = UIColor.white
        lblPercentage.textAlignment = .center
        lblPercentage.font = UIFont.systemFont(ofSize: 15.0)
        
        cancelBtn = UIButton(frame: CGRect(x: self.view.frame.size.width-120, y: 20, width: 100, height: 50))
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.tintColor = UIColor.white
        cancelBtn.addTarget(self, action: #selector(DBListingViewController.cancelBtnClicked(_:)), for: .touchUpInside)
        
        loaderBGView.addSubview(cancelBtn)
        loaderBGView.addSubview(lblDownload)
        loaderBGView.addSubview(progressView)
        loaderBGView.addSubview(lblPercentage)
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(loaderBGView)
        loaderBGView.isHidden = true
    }
    
    func makeActivityIndicator(){
        activityIndicatorBGView = UIView(frame: self.view.frame)
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.frame = CGRect(x: (UIScreen.main.bounds.size.width/2 - activityIndicatorView.frame.size.width/2), y: (UIScreen.main.bounds.size.height/2 - activityIndicatorView.frame.size.height/2), width: activityIndicatorView.frame.size.width, height: activityIndicatorView.frame.size.height)
        activityIndicatorBGView?.addSubview(activityIndicatorView)
        activityIndicatorBGView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        activityIndicatorBGView?.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(activityIndicatorBGView!)
    }
    
    func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: DBListingViewController.self)
        if let url = podBundle.url(forResource: "DroplightIcons", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
    
    //MARK: UISearchbarDelegate methods
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true {
            filteredArr = self.filesArr
        }else{
            filteredArr = self.filesArr.filter ({ (fileInfo) -> Bool in
                let range = fileInfo.name.range(of: searchBar.text!, options: String.CompareOptions.caseInsensitive)
                if range == nil
                {
                    return false
                }
                return true
            })
        }
        self.tableView.reloadData()
    }
}

extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


class DropboxListingCell: UITableViewCell {
    
    var listImageView: UIImageView = UIImageView()
    var fileName: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(listImageView)
        self.contentView.addSubview(fileName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        listImageView.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        fileName.frame = CGRect(x: (listImageView.frame.origin.x + listImageView.frame.size.width + 10), y: 10, width: UIScreen.main.bounds.size.width-65, height: 30)
    }
    
}
extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}


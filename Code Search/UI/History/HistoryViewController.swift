//
//  HistoryViewController.swift
//  Code Search
//
//  Created by Kis User on 4/28/21.
//

import UIKit

protocol HistoryViewControllerDelegate {
    func onDeleteAll()
}

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var histories: [BarcodeModel] = []
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nib = UINib(nibName: "ContentTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "cellContent")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(rgb: 0xE8EDF1)
        
        tableView.allowsMultipleSelection = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = self.tabBarController?.tabBar
        tabBar?.backgroundColor = .white
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicate(color: UIColor.init(rgb: 0x0D47A1), size: CGSize(width: tabBar!.frame.width/CGFloat(tabBar!.items!.count), height:  tabBar!.frame.height), lineWidth: 5.0)
        tabBarController?.tabBar.tintColor = UIColor.init(rgb: 0x0D47A1)
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(rgb: 0x0D47A1)
        self.updateData()
    }
    
    // MARK: Private functions
    func deleteItem(indexPath: IndexPath) {
        let model = histories[indexPath.row]
        BarcodeCoreDataHelper.delete(value: model.value)
        self.histories.remove(at: indexPath.row)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }
    
    func getTextOfTimestamp(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date as Date)
    }
    
    func openItem(content: String) {
        BarcodeCoreDataHelper.update(opened: true, updateDate: false, value: content)
        self.updateData()
        if CodeDetector.detectEmail(code: content) {
            CodeDetector.navigateEmail(content)
        } else if CodeDetector.detectPhone(code: content) {
            CodeDetector.navigatePhone(content)
        } else if CodeDetector.detectMap(code: content) {
            CodeDetector.navigateMap(content)
        } else if CodeDetector.detectWeb(code: content) {
            CodeDetector.navigateWeb(content)
        } else{
            CodeDetector.navigateWebWithQuerry(content)
        }
    }
    
    func updateData() {
        self.histories = BarcodeCoreDataHelper.readCodeList()
        self.histories.sort { model1, model2 in
            model1.compare(model2)
        }
        self.tableView.reloadData()
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension HistoryViewController: HistoryViewControllerDelegate {
    func onDeleteAll() {
        BarcodeCoreDataHelper.deleteAll()
        updateData()
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = histories[indexPath.row]
        self.openItem(content: model.value)
    }

}

@available(iOS 13.0, *)
extension HistoryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContent", for: indexPath) as! ContentTableViewCell
        let model = histories[indexPath.row]
        if model.opened {
            cell.cellView.backgroundColor = UIColor(rgb: 0xDCEBED)
        } else {
            cell.cellView.backgroundColor = .white
        }
        cell.contentLabel.text = CodeDetector.displayOfCode(model.value)
        cell.cellView.layer.cornerRadius = 5
        cell.dateLabel.text = self.getTextOfTimestamp(model.date)
        cell.selectionStyle = .none
        
        let contentOfCell = model.value
        
        if CodeDetector.detectEmail(code: contentOfCell) {
            cell.contentImage.image = UIImage.init(named: "mail")
        } else if CodeDetector.detectMap(code: contentOfCell) {
            cell.contentImage.image = UIImage.init(named: "ic_map")
        } else if CodeDetector.detectPhone(code: contentOfCell) {
            cell.contentImage.image = UIImage.init(named: "phone")
        } else if CodeDetector.detectWeb(code: contentOfCell) {
            cell.contentImage.image = UIImage.init(named: "website")
        } else{
            cell.contentImage.image = UIImage.init(named: "unknownWebsite")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteItem(indexPath: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteItem(indexPath: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
}

@available(iOS 13.0, *)
extension HistoryViewController: UIPopoverPresentationControllerDelegate {
  
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}


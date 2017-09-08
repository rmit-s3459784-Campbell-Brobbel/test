//
//  DealerListViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 9/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class DealerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DelegateNotifier {
    
    
    @IBOutlet weak var dealerTableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let del = UIApplication.shared.delegate as! AppDelegate
        del.notifier = self
        
        self.navigationItem.title = "Area Managers"
        self.dealerTableView.delegate = self
        self.dealerTableView.dataSource = self
        self.dealerTableView.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    
    // MARK: - Table View Data Source/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DealerManager.shared.dealers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dealer = DealerManager.shared.dealers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealerInfoCell")! as! ManagerInfoTableViewCell
        cell.managerNameLabel.text = "\(dealer.getFirstName()) \(dealer.getSecondName())"
        cell.managerIDLabel.text = "\(DealerManager.shared.dealers[indexPath.row].getID())"
        cell.managerNameLabel.textColor = UIColor.white
        cell.managerIDLabel.textColor = UIColor.white
        
        let numberOfAssessments = AssessmentManager.shared.numberOfAssessmentsFor(dealer: dealer)
        
        if numberOfAssessments >= 200 {
            cell.numberOfAssessmentsLabel.textColor = .green

        }
        else if numberOfAssessments < 200 && numberOfAssessments >= 100 {
            cell.numberOfAssessmentsLabel.textColor = .yellow

        }
        else {
            cell.numberOfAssessmentsLabel.textColor = .red

        }
        cell.backgroundColor = UIColor.black
        cell.numberOfAssessmentsLabel.text = "Number Of Assessments: \(numberOfAssessments)"
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dealerOptionVC") as! DealerOptionViewController
        vc.dealer = DealerManager.shared.dealers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Did deselect")
        
    }
    
    func assessmentsDownloadComplete() {
        self.dealerTableView.reloadData()
    }
    
    func dealerDownloadComplete() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

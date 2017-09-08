//
//  AssessmentViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 30/6/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

class AssessmentViewController: UIViewController {
    
    // MARK: - Variables
    
    // Must contain 2 tables with a dealer on each in order to create an assessment.
    // index 0 will be the "Assessed Dealer" and index 1 will be Comparison Dealer
    
    var assessedDealer : Dealer!
    var comparisonDealers : [Dealer]  = []
    var assessedDealerImage : UIImage?
    var comparisonDealerImages : [UIImage] = []
    
    var assessments : [Assessment] = []
    
    var currentAssessmentIndex : Int = 0;
    var assessedDealerIsBetter : Bool!
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var assessedDealerImageButton: DealerImageButton!
    @IBOutlet weak var assessedDealerNameLabel: UILabel!
    @IBOutlet weak var comparisonDealerImageButton: DealerImageButton!
    @IBOutlet weak var comparisonDealerNameLabel: UILabel!
    @IBOutlet weak var assessmentTitleLabel: UILabel!
    @IBOutlet weak var submitAssessmentButton : UIButton!
    
    // MARK: - IBActions
    
    
    // Displays next assessment on the screen
    @IBAction private func nextAssessment(sender : Any) {
        if currentAssessmentIndex == comparisonDealers.count-1 {
            currentAssessmentIndex = 0
        }
        else {
            currentAssessmentIndex += 1
        }
        
        if self.refreshAssessmentView() {
            print("Refreshed Successully")
        }
    }
    /* 
     func description is previous
     */
    @IBAction private func previousAssessment(sender : Any) {
        if currentAssessmentIndex == 0 {
            currentAssessmentIndex = comparisonDealers.count-1
        }
        else {
            currentAssessmentIndex -= 1
        }
        
        if self.refreshAssessmentView() {
            print("Refreshed Successully")
        }
    }
    
    @IBAction private func assessedDealerButtonPressed(sender : Any) {
        self.assessedDealerImageButton.show(border: true)
        self.comparisonDealerImageButton.show(border: false)
        self.refreshSubmitButton()
        let currentAssessment = self.assessments[currentAssessmentIndex]
        let currentComparisonDealer = comparisonDealers[currentAssessmentIndex]
        
        if !currentAssessment.setAssessmentDealers(greaterDealer: assessedDealer, improvementDealer: currentComparisonDealer) {
            
            // Swap assessment winner if the winner id and assessed dealer id dont match
            if assessments[currentAssessmentIndex].greaterDealer!.getID() != assessedDealer.getID() {
                currentAssessment.swapGreaterDealer()
            }
            
        }
        
        refreshSubmitButton()

    }
    @IBAction private func comparisonDealerButtonPressed(sender : Any) {
        self.assessedDealerImageButton.show(border: false)
        self.comparisonDealerImageButton.show(border: true)
        self.refreshSubmitButton()
        
        let currentAssessment = self.assessments[currentAssessmentIndex]
        let currentComparisonDealer = comparisonDealers[currentAssessmentIndex]
        
        if !currentAssessment.setAssessmentDealers(greaterDealer: currentComparisonDealer, improvementDealer: assessedDealer) {
            
            // Swap assessment winner if the winner id and assessed dealer id dont match
            if currentAssessment.greaterDealer!.getID() != currentComparisonDealer.getID() {
                currentAssessment.swapGreaterDealer()
            }
        }
        
        refreshSubmitButton()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        
                
        let bool = AssessmentManager.shared.add(assessments: self.assessments) {
            
            self.navigationController?.popViewController(animated: true)

        }
        
        print(bool)
        
    }
    
    //MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAssessments()
        updateDealerPhotos()
        
        //Update the labels to contain Assessment data.
        refreshSubmitButton()
    }
    
    func updateDealerPhotos() {
        

        self.assessedDealer.downloadDealerImage() {
            self.refreshAssessmentView()
        }

        
        for compDealer in comparisonDealers {
            compDealer.downloadDealerImage() {
                self.refreshAssessmentView()
                
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        refreshAssessmentView()

        if self.assessedDealerNameLabel.font.pointSize < self.comparisonDealerNameLabel.font.pointSize {
            print("Comparison Font Is Bigger")
            self.comparisonDealerNameLabel.font = UIFont(name: self.assessedDealerNameLabel.font.fontName, size: self.assessedDealerNameLabel.font.pointSize)
            
        }
        else if self.assessedDealerNameLabel.font.pointSize > self.comparisonDealerNameLabel.font.pointSize {
            
            print("Assessed Font Is Bigger")
            self.assessedDealerNameLabel.font = UIFont(name: self.assessedDealerNameLabel.font.fontName, size: self.comparisonDealerNameLabel.font.pointSize)
        }
        //Makes the buttons have rounded edges
        assessedDealerImageButton.editRadius()
        comparisonDealerImageButton.editRadius()
    }
    
    //MARK: - Other Methods
    
    private func createAssessments() {
        
        for _ in 0...comparisonDealers.count-1 {
            
            let assessment = Assessment(assessmentType: AssessmentManager.shared.generateRandomAssessmentType()!)
            self.assessments.append(assessment)
            
            
        }
    }
    
    private func refreshSubmitButton() {
        //Show/Hide Submit Button
        print("Refresh Submit")
        for a in self.assessments {
            if a.greaterDealer == nil {
                print("Refresh Submit True")
                self.submitAssessmentButton.isHidden = true
                break
            }
            else {
                print("Refresh Submit True")
                self.submitAssessmentButton.isHidden = false
            }
        }
    }
    
    
    
    private func refreshAssessmentView() -> Bool {
        
        if assessments.count == 0 {
            return false
        }
        
        
        //Update Labels
        
        let comparisonDealer = comparisonDealers[currentAssessmentIndex]
        
        self.assessedDealerNameLabel.text = "\(assessedDealer.getID()) \(assessedDealer.getFirstName()) \(assessedDealer.getSecondName())"
        if assessedDealer.dealerImage != nil {
            
            self.assessedDealerImageButton.setImage(assessedDealer.dealerImage, for: .normal)
        }
        if comparisonDealer.dealerImage != nil {
            self.comparisonDealerImageButton.setImage(comparisonDealer.dealerImage, for: .normal)
        }
        self.comparisonDealerNameLabel.pushTransition(0.3)
        self.comparisonDealerNameLabel.text = "\(comparisonDealer.getID()) \(comparisonDealer.getFirstName()) \(comparisonDealer.getSecondName())"
        self.assessmentTitleLabel.pushTransition(0.3)
        self.assessmentTitleLabel.text = assessments[currentAssessmentIndex].assessmentType.type
        
        let currentAssessment = assessments[currentAssessmentIndex]
        
        if currentAssessment.greaterDealer != nil {
            if currentAssessment.greaterDealer!.getID() == assessedDealer.getID() {
                self.assessedDealerImageButton.show(border: true)
                self.comparisonDealerImageButton.show(border: false)
            }
            else {
                self.assessedDealerImageButton.show(border: false)
                self.comparisonDealerImageButton.show(border: true)
            }
        }
        else {
            self.assessedDealerImageButton.show(border: false)
            self.comparisonDealerImageButton.show(border: false)
        }
        
        
            
        
        self.refreshSubmitButton()
        
        return true
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

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
}

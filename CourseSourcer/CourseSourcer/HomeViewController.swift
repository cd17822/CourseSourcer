//
//  HomeViewController.swift
//  CourseSourcer
//
//  Created by Charlie on 6/17/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var courses_container: UIView!
    @IBOutlet weak var schedule_container: UIView!
    @IBOutlet weak var segment_controller: UISegmentedControl!
    @IBOutlet weak var me_bar_button: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //addTestUser() // ONLY FOR TESTING
        configureSegmentController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Testing
    
    func addTestUser(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(User(value: ["name": "Charlie DiGiovanna", "email": "cdigiov1@binghamton.edu"]))
        }
    }
    
    // MARK: - Personal
    
    func configureSegmentController() {
        //segment_controller.setTitleTextAttributes(["font": "Avenir Book 12"], forState: .Application) //FONT
        segment_controller.addTarget(self, action: #selector(HomeViewController.segmentChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func segmentChanged(gesture: UIGestureRecognizer){
        if segment_controller.selectedSegmentIndex == 0 {
            courses_container.hidden = false
            schedule_container.hidden = true
        }else{
            courses_container.hidden = true
            schedule_container.hidden = false
        }
    }
    
    @IBAction func compose_button_pressed(sender: AnyObject) {
        if segment_controller.selectedSegmentIndex == 0 { // Courses selected
            performSegueWithIdentifier("HomeToCourseSearch", sender: nil)
        }else{ // Schedule Selected
            // present nib to create a new assignment/exam
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeToCourse" {
            let vc = segue.destinationViewController as! CourseViewController
            vc.course = sender as? Course
            print("COURSE:", (vc.course?.name)!)
        }
    }
}

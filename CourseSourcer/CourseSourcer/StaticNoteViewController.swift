//
//  StaticNoteViewController.swift
//  CourseSourcer
//
//  Created by Charlie on 6/10/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import UIKit

class StaticNoteViewController: UIViewController {
    var course: Course?
    var note: StaticNote?
    
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var content_textview: UITextView!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var subject_label: UILabel!
    @IBOutlet weak var delimiter_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureFields()
        configureDelimiter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Personal
    
    func configureNavigationBar() {
        navigationItem.title = course!.name
    }
    
    func configureFields() {
        score_label.text = note?.score.description
        content_textview.text = note?.text
        date_label.text = note?.created_at?.prettyDateTimeDescription
        subject_label.text = note?.title
    }
    
    func configureDelimiter() {
        delimiter_view.backgroundColor = pastelFromInt(course!.color)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

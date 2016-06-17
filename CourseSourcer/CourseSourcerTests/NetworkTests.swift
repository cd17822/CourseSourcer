//
//  NetworkTests.swift
//  CourseSourcer
//
//  Created by Charlie on 6/16/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

/*  Tests account for the following endpoints:
    POST /users
    POST /courses
    POST /notes
    GET  /notes/<courseid>
    PUT  /users/addCourse
*/

import Foundation
import Alamofire
import SwiftyJSON

var posts = 0
var userid: String? = nil
var courseid: String? = nil

func tryMore(){
    if posts == 2 {
        POST("/notes", parameters: ["text": "texty","title": "titley","course": courseid!,"user": userid!], callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
            print("post notes")
            if (err != nil) {print(err!)}
            if (res != nil) {print(res!)}
            GET("/notes/\(courseid!)", callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
                print("get notes")
                if (err != nil) {print(err!)}
                if (res != nil) {print(res!)}
            })
        })
        
        PUT("/users/addCourse", parameters: ["user_id": userid!, "course_id": courseid!],  callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
            print("put course in user")
            if (err != nil) {print(err!)}
            if (res != nil) {print(res!)}
        })
    }
}

func testRequests(){
    POST("/users", parameters: ["name":"Charlie", "email":"cdg@bing.edu", "password":"nsonat"], callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
        print("post user")
        if (err != nil) {print(err!)}
        if (res != nil) {print(res!); userid = res!["user"]["id"].string; posts++; tryMore()}
    })
    
    POST("/courses", parameters: ["name": "graph theory","term": "Fall 2015","school": "Binghamton"],  callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
        print("post course")
        if (err != nil) {print(err!)}
        if (res != nil) {print(res!); courseid = res!["course"]["id"].string; posts++; tryMore()}
    })
}
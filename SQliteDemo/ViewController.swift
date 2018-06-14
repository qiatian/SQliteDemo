//
//  ViewController.swift
//  SQliteDemo
//
//  Created by sanjingrihua on 17/7/4.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let result1 = Student.update(sql: "update t_stu set  money = money - 10 where name = 'zhangsan'")
        let result2 = Student.update(sql: "update t_stu set money = money + 10 where name = 'lisi'")
        
        if result1 && result2 {
            SQLiteTool.shareInstance.commitTransaction()
        }else{
            SQLiteTool.shareInstance.rollbackTransaction()
        }
    }
    
    func test1() -> () {
        //        createTable()
        //4.45948696136475   1000
        //0.0179899930953979  1000
        //        0.00146001577377319  1000
        //        0.00128000974655151  10000
        
        let beginTime = CFAbsoluteTimeGetCurrent();
        let stu = Student(name:"zhangsan",age:18,score:2)
        stu.fenjieBind()
        //        for _ in 0..<1000{
        //
        ////            stu.insertStudent()
        //            stu.bindInsert()
        //        }
        let endTime = CFAbsoluteTimeGetCurrent();
        
        print(endTime - beginTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


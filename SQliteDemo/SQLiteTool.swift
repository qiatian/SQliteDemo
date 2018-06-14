//
//  SQLiteTool.swift
//  SQliteDemo
//
//  Created by sanjingrihua on 17/7/4.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

import UIKit

class SQLiteTool: NSObject {
    static let shareInstance = SQLiteTool()
    var db: OpaquePointer? = nil
    override init(){
        super.init()
        
        //创建一个数据库
        //打开一个指定的数据库，如果数据库不存在，就创建， 存在 就直接打开，并且赋值给参数2  参数1:数据库路径 参数2:一个已经打开的数据库
        let path = "/Users/sanjingrihua/Desktop/DataBase/demo.sqlite"
        
        if sqlite3_open(path,&db) == SQLITE_OK{
            print("执行成功")
            
        }else{
            print("执行失败")
        }
    }
    
    func createTable() -> () {
        let sql = "create table t_stu(id integer primary key autoincrement,name text not null, age integer, score real default 60)"
        
        let result = execute(sql: sql)
        if result {
            print("yes")
        }
        
        //参数1:已经打开的数据库 参数2:要执行的sql字符串 参数3:执行回调 参数4:参数3，参数1  参数5：错误信息
        
//        if sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK{
//            print("创建表成功")
//        }else{
//            print("创建表失败")
//        }
    }
    
    func dropTable() -> () {
        let sql = "drop table if exists t_stu"
        
        if sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK {
            
            print("删除表成功")
        }else{
            print("删除表失败")
        }
    }
    
    func execute(sql:String) -> Bool {
        return (sqlite3_exec(db, sql, nil, nil
            , nil) == SQLITE_OK)
    }
    
    func beginTransaction() -> () {
        let sql = "begin transaction"
        execute(sql: sql)
        
    }
    func commitTransaction() -> () {
        let sql = "commit transaction"
        execute(sql: sql)
    }
    func rollbackTransaction() -> () {
        let sql = "rollback transaction"
        execute(sql: sql)
    }
    //优化方案：如果使用sqlite3_exec 或者 sqlite3_step()来执行sql语句，会自动开启一个事务，然后，自动提交‘事务’
    //结局方案：只需要手动开启事务，手动提交事务，这时候，函数内部 就不会自动开启事务和提交事务

}

//
//  Student.swift
//  SQliteDemo
//
//  Created by sanjingrihua on 17/7/4.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

import UIKit

class Student: NSObject {

    var name:String = ""
    var age:Int = 0
    var score:Float = 0.0
    
    init(name:String,age:Int,score:Float) {
        super.init()
        self.name = name
        self.age = age
        self.score = score
    }
    
    class func queryAllStmt() {
        //准备语句 历程
        let sql = "select * from t_stu"
//        创建 准备语句 参数1:打开的数据库 参数2:sql字符串 参数3:字符串，取的长度－1代表取所有的 参数4:准备语句的指针 参数5：剩余sql字符串
        let db = SQLiteTool.shareInstance.db
        var stmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK{
            print("预处理失败")
            return
        }
//        绑定参数 这一步可以省略
//        执行准备语句 sqlite3_step 执行DQL 会把结果 放到 准备语句 stmt里面
        while sqlite3_step(stmt) == SQLITE_ROW {
            
//            读取结果 从准备语句里面进行读取  计算预处理语句里面得到的结果是多少列
            let count = sqlite3_column_count(stmt)
            for i in 0..<count{
                //取出列的名称
                let columnName = sqlite3_column_name(stmt, i)
                let columnNameStr = String(cString: columnName!,encoding:String.Encoding.utf8)
                
                print(columnNameStr ?? "")
                
//                取出列的值 不同的数字类型，是通过不同的函数进行获取的
//                获取这一列的类型
                let type = sqlite3_column_type(stmt, i)
                //根据不同的类型，使用不同的函数 获取结果
                if type == SQLITE_INTEGER{
                    let value = sqlite3_column_int(stmt, i)
                    print(value)
                }
                if type == SQLITE_FLOAT{
                    let value = sqlite3_column_double(stmt, i)
                    print(value)
                }
                if type == SQLITE_TEXT{
                    let value = sqlite3_column_text(stmt, i)
                    let valueInt8 = unsafeBitCast(value, to: UnsafePointer<CChar>.self)//
                    let valueStr = String(cString: valueInt8,encoding:String.Encoding.utf8)
                    print(valueStr ?? "")
                }
            
                
                
            }
        }
//        重置 准备语句
//        释放 准备语句
    }
    
    class func queryAll() -> () {
        let sql = "select * from t_stu"
        
        let db = SQLiteTool.shareInstance.db
//        参数1: 一个打开的数据库 参数2:sql语句 参数3:回调代码块 参1:传递过来的值 参2:列的个数 参3:值的数组 参4:列名称的数组 返回值：0继续查询，1终止查询  参数4：传递到参数3里面的第一个参数 参数5:错误信息
        let result = sqlite3_exec(db, sql, { (firstValue, columnCount, values, columnNames) -> Int32 in
            
            for i in 0..<columnCount{
                
//                let offsetPointer = i+1
                //列的名称
                let columnName = columnNames?[Int(i)]
//                let columnNameStr = String(CString:columnName,encoding:String.Encoding.utf8)
                
//                值
                let value = values?[Int(i)]
//                let valueStr = String(CString:value,encoding:String.Encoding.utf8)
                
                print(columnName ?? "test",value ?? "test")
                
            }
            return 1
        }, nil, nil)
        
        if result == SQLITE_OK{
            print("查询成功")
        }else{
            print("查询失败")
        }
    }
    
    class func update(sql:String) -> (Bool) {
        return SQLiteTool.shareInstance.execute(sql: sql)
    }
    
    func fenjieBind() -> () {
        let sql = "insert into t_stu(name,age,score values (?,?,?)"
        //参数1:已经打开的数据库  参数2: sql 参数3:取出字符串的长度“2” －1:代表自动计算 参数4:与处理语句 参数5:根据参数3的长度，取出参数2的值以后，剩余的参数
        
        let db = SQLiteTool.shareInstance.db
        var stmt:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK{
            print("预处理失败")
            return
        }
        
        
        //手动开启事务
        SQLiteTool.shareInstance.beginTransaction()
        for i in 0..<10000{
            //        绑定参数 参数1:准备语句 参数2:绑定值的索引，索引从1 开始 参数3:需要绑定的值
            let value = Int32(i)
            sqlite3_bind_int(stmt, 2, value)
            sqlite3_bind_double(stmt,32, 59.9)
            
            //绑定文本（）参数1:准备语句 参数2:绑定的索引1 参数3：绑定的值 参数4: 值取出的长度，－1：代表取出所有 参数5:值的处理方式 Sqlite_static:人为参数是一个常量，不会被释放，处理方案：不做任何引用  SQLITE_TRANSIENT：会对参数进行一个引用
            
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_text(stmt, 1, "test123", -1, SQLITE_TRANSIENT)
            
            //执行语句
            if sqlite3_step(stmt) == SQLITE_OK {
                print("执行成功")
            }
            
            //重置语句
            sqlite3_reset(stmt)
        }
        //提交事务
        SQLiteTool.shareInstance.commitTransaction()
        
        //释放准备语句
        sqlite3_finalize(stmt)
    }
    
    func bindInsert() -> () {
        let sql = "insert into t_stu(name,age,score values (?,?,?)"
        //参数1:已经打开的数据库  参数2: sql 参数3:取出字符串的长度“2” －1:代表自动计算 参数4:与处理语句 参数5:根据参数3的长度，取出参数2的值以后，剩余的参数
        
        let db = SQLiteTool.shareInstance.db
        var stmt:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK{
            print("预处理失败")
            return
        }
        
//        绑定参数 参数1:准备语句 参数2:绑定值的索引，索引从1 开始 参数3:需要绑定的值
        sqlite3_bind_int(stmt, 2, 20)
        sqlite3_bind_double(stmt,32, 59.9)
        
        //绑定文本（）参数1:准备语句 参数2:绑定的索引1 参数3：绑定的值 参数4: 值取出的长度，－1：代表取出所有 参数5:值的处理方式 Sqlite_static:人为参数是一个常量，不会被释放，处理方案：不做任何引用  SQLITE_TRANSIENT：会对参数进行一个引用
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        sqlite3_bind_text(stmt, 1, "test123", -1, SQLITE_TRANSIENT)
        
        //执行语句
        if sqlite3_step(stmt) == SQLITE_OK {
            print("执行成功")
        }
        
        //重置语句
        sqlite3_reset(stmt)
        
        //释放准备语句
        sqlite3_finalize(stmt)
    }
    
    func insertStudent() -> () {
        let sql = "insert into t_stu(name,age,score) values('\(name)','\(age)','\(score)')"
        if SQLiteTool.shareInstance.execute(sql: sql) {
//            print("插入成功")
        }
    }
    class func deleteStu(name:String) -> () {
        let sql = "delete from t_stu where name = '\(name)'"
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("删除成功")
        }
    }
    func alterStu(newStu:Student) -> () {
        let sql = "update t_stu set name = '\(newStu.name)',age = '\(newStu.age), score = \(newStu.score)' where name = '\(name)'"
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("修改成功")
        }else{
            print("修改失败")
        }
    }
    
}

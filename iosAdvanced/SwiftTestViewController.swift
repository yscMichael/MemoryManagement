//
//  SwiftTestViewController.swift
//  iosAdvanced
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

import UIKit

class SwiftTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red

        let myString = "Hello, Swift!"
        print(myString)

        //创建一个ContactAdd类型的按钮
        let button:UIButton = UIButton(type:.contactAdd)
        //设置按钮位置和大小
        button.frame = CGRect(x:10, y:150, width:100, height:30)
        //设置按钮文字
        button.setTitle("按钮", for: .normal)
        self.view.addSubview(button)

        let ocDemo:TestOCDemo = TestOCDemo();
        ocDemo.show()
    }
}

func testOne(temp:String) -> Void
{

}



//总结:
// 1、var(引用类型)和let(值类型)
//    let(值类型):在被赋给一个变量,或被传给函数时,实际是做了一次拷贝(不同内存地址).
//    var(引用类型):在被赋给一个变量,或被传给函数时,传递的是引用(指向同一个内存地址).
//    注意:let 用于定义常量，定义完后不能修改。
//        var 用于定义变量，可以修改
//
//2、optionals(可选类型)
//   a、概念:Optional值未经初始化虽然为nil,但普通变量连nil都没有
//   b、定一个optionals类型,只需要在类型后面加上问号(?)就行了
//      eg:
//      var str: String?(未经初始化就为nil)
//      var str: Optional<String>
//
//3、typealias(类别名)
//   typealias Feet = Int
//
//4、类型安全
//   以下会检查类型错误:(因为没有指明类型,会帮你推断类型)
//   var varA = 42
//   varA = "This is hello"
//   print(varA)
//
//菜鸟教程看到:
// Swift可选类型
//


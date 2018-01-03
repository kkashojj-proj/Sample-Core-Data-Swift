//
//  ViewController.swift
//  ImaginIOT
//
//  Created by Koushik Kashojjula on 1/2/18.
//  Copyright © 2018 Koushik Kashojjula. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var key: UITextField!
    @IBOutlet weak var value: UITextField!
    
    var context : NSManagedObjectContext!
    var mappy = [Mappy]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        results.text = ""
    }

    @IBAction func showData(_ sender: Any) {
        showAllData()
    }
    
    @IBAction func deleteData(_ sender: Any) {
        delete(key: Int(key.text!)!)
    }
    
    @IBAction func updateData(_ sender: Any) {
        updateData(key: Int(key.text!)!, val: Int(value.text!)!)
    }
    
    @IBAction func insertData(_ sender: Any) {
        insert(key: Int(key.text!)!, val: Int(value.text!)!)
    }
    
    func insert(key : Int , val : Int){
        do{
            let request : NSFetchRequest = Mappy.fetchRequest()
            mappy = try context.fetch(request)
            var present = false
            if mappy.count > 0{
                present = mappy.contains { $0.key == key }
            }
            if(!present){
                let map = Mappy(context: context)
                map.key = Int32(key)
                map.value = Int32(val)
                try context.save()
                print("added")
            }
            showAllData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func showAllData(){
        do{
            let request : NSFetchRequest = Mappy.fetchRequest()
            mappy = try context.fetch(request)
            var s = ""
            for map in mappy{
                s += "\(map.key) \(map.value) \n"
            }
            results.text = s
        }catch{
            print(error)
        }
    }
    
    func delete(key : Int) {
        do{
            let request : NSFetchRequest = Mappy.fetchRequest()
            request.predicate = NSPredicate.init(format: "key == \(key)")
            if let result = try? context.fetch(request){
                for object in result{
                    context.delete(object)
                }
                try context.save()
            }
            showAllData()
        }catch{
            print(error)
        }
    }
    
    func updateData(key : Int , val : Int){
        delete(key: key)
        insert(key: key, val: val)
        showAllData()
    }
}


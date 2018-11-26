//
//  TaskViewController.swift
//  ToDoUsingCoreData
//
//  Created by sivakumar on 25/11/18.
//  Copyright © 2018 sivakumar. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveTask { (done) in
            if done{
                print("we need to return")
                navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else{
                print("try again")
            }
        }
    }
    
    
    
    func saveTask(completion :(_ finshed : Bool) -> ()){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let task = Task(context: managedContext)
        task.taskDescription = taskTextView.text
        task.taskStatus = false
        do{
            try managedContext.save()
            print("data saved")
            completion(true)
        }catch{
            print("failed to save the data")
            completion(false)
        }
        
        
    }

}

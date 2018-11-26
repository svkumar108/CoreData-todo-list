//
//  ViewController.swift
//  ToDoUsingCoreData
//
//  Created by sivakumar on 25/11/18.
//  Copyright © 2018 sivakumar. All rights reserved.
//

import UIKit
import CoreData

// to implement coredata
// 1. create shared instance (appdelegate)
// 2. save the task ( create save task function,means assign the data to task and save the task=mngcontex.save)
// 3.create fetch request( create fetch data function and present the data where ever you want)
// 4. call fetchData function in view will or did Apper not in viewDidLoad because viewDidLoad function call only once viewwill or view did func call for every time when view changes or appears
//5. for delete the data in coredata we need to use delete data function after deleting the data we need to update

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class ViewController: UIViewController {
    
    @IBOutlet weak var tv: UITableView!
    
    var taskArray = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
       tv.reloadData()
       fetchyData()
    }
    
    func fetchyData(){
        fetchData { (done) in
            if done{
                if taskArray.count > 0 {
                    tv.isHidden = false
                }else {
                    tv.isHidden = true
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell
        let task = taskArray[indexPath.row]
        cell?.taskLabel.text = task.taskDescription
        if task.taskStatus == true {
            cell?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell?.taskLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletea") { (action, indepath) in
            self.deleteData(indexpath: indexPath)
            self.fetchyData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let taskStausAction = UITableViewRowAction(style: .destructive, title: "completed") { (action, indexpath) in
            self.updateTaskStauts(indexpath: indexpath)
            self.fetchyData()
            tableView.reloadRows(at: [indexpath], with: .automatic)
         }
        taskStausAction.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction, taskStausAction]
    }
}

extension ViewController {
    
    func fetchData(completion : (_ complete : Bool) ->()){

        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do{
            taskArray = try managedContext.fetch(request) as! [Task]
            print("data fetched")
            completion(true)


        }catch{
            print("unable to fetch data", error.localizedDescription)
            completion(false)
        }

    }
    
    func deleteData(indexpath: IndexPath){
         guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(taskArray[indexpath.row])//this will delete the data in selcted row and in coredata
        do{
            try managedContext.save()
            print("data deleted and updated")
        }catch{
            print("error in deleting data", error.localizedDescription)
        }
        
    }
    
    func updateTaskStauts(indexpath:IndexPath){
         guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let task = taskArray[indexpath.row]
        if task.taskStatus == true{
            task.taskStatus = false
        }else{
            task.taskStatus = true
        }
        do{
            try managedContext.save()
            print("Task updated")
        }catch{
            print("failed to update task", error.localizedDescription)
        }
        
        
    }
}


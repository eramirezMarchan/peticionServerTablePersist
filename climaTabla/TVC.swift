//
//  TVC.swift
//  climaTabla
//
//  Created by Faktos on 03/06/16.
//  Copyright © 2016 ERM. All rights reserved.
//

import UIKit
import CoreData

struct Seccion {
    var titulo:String
    var autores:[String]
    var portada : UIImage
    var isbn : String
    
    init (titulo: String,autores:[String], portada:UIImage, isbn: String){
        self.titulo = titulo
        self.autores = autores
        self.portada = portada
        self.isbn = isbn
    }
}

var libros = [Seccion]()

class TVC: UITableViewController {
    var contexto  : NSManagedObjectContext? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        let seccionEntidad = NSEntityDescription.entityForName("Libros", inManagedObjectContext: self.contexto!)
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        do {
            let seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            for seccionEntidad2 in seccionesEntidad! {
                let titulo = seccionEntidad2.valueForKey("titulo") as! String
                let autores = seccionEntidad2.valueForKey("autor") as! String
                let isbn = seccionEntidad2.valueForKey("isbn") as! String
                let portada = UIImage(data:seccionEntidad2.valueForKey("portada") as! NSData)
                libros.append(Seccion(titulo: titulo,autores:autores.componentsSeparatedByString(","), portada:portada!,isbn:isbn))
            }
        }
        catch{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return libros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = libros[indexPath.row].titulo
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "search"{
            _ = segue.destinationViewController as! ControlLibro
        }
        else if segue.identifier == "info" {
            let ivc = segue.destinationViewController as! InfoVC
            let ip = self.tableView.indexPathForSelectedRow
            
            ivc.ip = (ip?.item)!
        }
        
    }

}

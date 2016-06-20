//
//  ControlCiudad.swift
//  climaTabla
//
//  Created by Faktos on 03/06/16.
//  Copyright © 2016 ERM. All rights reserved.
//

import UIKit
import CoreData

class ControlLibro: UIViewController,UITextFieldDelegate {
        
    @IBOutlet weak var img_portada: UIImageView!
    @IBOutlet weak var lbl_autor: UILabel!
    @IBOutlet weak var lbl_titulo: UILabel!
    @IBOutlet weak var txt_search: UITextField!
    
    var contexto  : NSManagedObjectContext? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_search.delegate = self
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        if(self.txt_search.text != ""){
            
            let seccionEntidad = NSEntityDescription.entityForName("Libros", inManagedObjectContext: self.contexto!)
            let peticion = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn":self.txt_search.text!])
            
            do {
                
                let seccionEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
                if (seccionEntidad2?.count > 0) {
                    self.txt_search.text = nil
                    let titulo = seccionEntidad2![0].valueForKey("titulo") as! String
                    let autores = seccionEntidad2![0].valueForKey("autor") as! String
                    let isbn = seccionEntidad2![0].valueForKey("isbn") as! String
                    let portada = UIImage(data:seccionEntidad2![0].valueForKey("portada") as! NSData)
                    self.lbl_titulo.text = titulo
                    self.lbl_autor.text = autores
                    self.img_portada.image = portada
                    self.txt_search.text = isbn
                    
                    
                    return false
                }
            }
            catch{
                
            }

            
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
            let urlSearch = urls + txt_search.text!
            let url = NSURL(string: urlSearch)
            let session = NSURLSession.sharedSession()
            let bloque = { (datos:NSData?, resp:NSURLResponse?, error : NSError?) -> Void in
                if(error?.code != -1009){
                    var titulo = ""
                    var autores :[String] = []
                    var imgurl = ""
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                        let dico1 = json as! NSDictionary
                        if let dico2 = dico1["ISBN:"+self.txt_search.text!] as? NSDictionary{
                            titulo = dico2["title"] as! NSString as String
                            if let dico3 = dico2["authors"] as? NSArray{
                                for autor in dico3{
                                    autores.append(autor["name"]as! NSString as String)
                                }
                            }
                            
                            if let dico4 = dico2["cover"] as? NSDictionary{
                                imgurl = dico4["medium"] as! NSString as String
                            }
                        }
                        else{
                            titulo = "NO ENCONTRADO"
                        }
                        
                    }
                    catch _ {
                        
                    }
                    dispatch_sync(dispatch_get_main_queue()) {
                        self.lbl_titulo.text = titulo
                        self.lbl_autor.text = autores.joinWithSeparator(",")
                        if imgurl != ""{
                            let url = NSURL(string: imgurl)
                            let data = NSData(contentsOfURL: url!)
                            self.img_portada.image = UIImage(data: data!)
                        }
                        else{
                            self.img_portada.image = UIImage(named: "not")
                        }
                        
                        if(titulo != "NO ENCONTRADO"){
                            let libro = Seccion(titulo: titulo, autores: autores,portada: self.img_portada.image!,isbn: self.txt_search.text!)
                            libros.append(libro)
                            
                            let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Libros", inManagedObjectContext: self.contexto!)
                            nuevaSeccionEntidad.setValue(self.txt_search.text!, forKey: "isbn")
                            nuevaSeccionEntidad.setValue(titulo, forKey: "titulo")
                            nuevaSeccionEntidad.setValue(autores.joinWithSeparator(","), forKey: "autor")
                            nuevaSeccionEntidad.setValue(UIImagePNGRepresentation(self.img_portada.image!), forKey: "portada")

                        }
                        
                        
                    }
                }
                else{
                    let alert = UIAlertController(title: "Error", message: "No hay conexion a internet", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            let dt = session.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Ingrese un ISBN", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return true
        
    }

    override func viewWillDisappear(animated: Bool) {
        
        do {
            try self.contexto?.save()
        }
        catch {
            
        }
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

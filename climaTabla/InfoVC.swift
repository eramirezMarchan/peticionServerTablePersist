//
//  InfoVC.swift
//  PeticionServerTabla
//
//  Created by Faktos on 04/06/16.
//  Copyright © 2016 ERM. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_autor: UILabel!
    @IBOutlet weak var img_portada: UIImageView!
    @IBOutlet weak var lbl_isbn: UILabel!
    
    var ip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_title.text = libros[ip].titulo
        lbl_autor.text = libros[ip].autores.joinWithSeparator(",")
        img_portada.image = libros[ip].portada
        lbl_isbn.text = libros[ip].isbn
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//
//  IMDetailMovieViewController.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class IMDetailMovieViewController: UIViewController {
    
    
    //MARK: - Variables locales
    var movie : MovieModel?
    let dataProvider = LocalCoreDataService()
    
    //MARK: - OUTLET
    
    @IBOutlet weak var myImageViewMovie: UIImageView!
    @IBOutlet weak var myTitleMovie: UILabel!
    @IBOutlet weak var myDirectorMovie: UILabel!
    @IBOutlet weak var myCategoryMovie: UILabel!
    @IBOutlet weak var myButtonSelectedFavoriteMovie: UIButton!
    @IBOutlet weak var mySummaryMovie: UITextView!
    
    
    
    //MARK: - ACTION
    
    @IBAction func checkFavoriteACTION(_ sender: Any) {
        if let movieData = movie{
            dataProvider.markUnMarkFavorite(movieData)
            configuracionBTN()
        }
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let movieData = movie{
            if let imageData = movieData.image{
                myImageViewMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!))
            }
            
            myTitleMovie.text = movieData.title
            self.title = movieData.title
            mySummaryMovie.text = movieData.summary
            myCategoryMovie.text = movieData.category
            myDirectorMovie.text = movieData.director
            configuracionBTN()
            
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - utils
    
    func configuracionBTN(){
        
        if let movieData = movie{
            if dataProvider.isMovieFavorite(movieData){
                myButtonSelectedFavoriteMovie.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myButtonSelectedFavoriteMovie.setTitle("Quiero verla", for: .normal)
            }else{
                myButtonSelectedFavoriteMovie.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myButtonSelectedFavoriteMovie.setTitle("No me interesa", for: .normal)
            }
        }
        
    }
    
    

}

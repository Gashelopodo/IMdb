//
//  IMListFavoritesViewController.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class IMListFavoritesViewController: UIViewController {
    
    //MARK:- variables locales

    var movies = [MovieModel]()
    var collectionPading : CGFloat = 0
    let dataProvider = LocalCoreDataService()
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var myCollectionView: UICollectionView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        loadData()
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let indexPathSelected = myCollectionView.indexPathsForSelectedItems?.last{
                let selectedMovie = movies[indexPathSelected.row]
                let detalleVC = segue.destination as! IMDetailMovieViewController
                detalleVC.movie = selectedMovie
            }
        }
    }
    
    //MARK: Utils
    
    func loadData(){
        
        if let movieData = dataProvider.getFavoriteMovies(){
            movies = movieData
            myCollectionView.reloadData()
        }
        
    }

    
    
    

}


//MARK: - extención de collection delegate

extension IMListFavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    
    
    
    /****************************************** UICOLLECTION VIEW DELEGATE *****************************************************/
    
    
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionPading = (anchoPantalla - (3 * 113)) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionPading, left: collectionPading, bottom: collectionPading, right: collectionPading)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return collectionPading
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if movies.count == 0{
            let imageView = UIImageView(image: #imageLiteral(resourceName: "sin-favoritas"))
            imageView.contentMode = .center
            myCollectionView.backgroundView = imageView
        }else{
            myCollectionView.backgroundView = UIView()
        }
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IMDetailCustomViewCell
        
        let model = movies[indexPath.row]
        configuredCell(cell, withMovie: model)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    func configuredCell(_ cell : IMDetailCustomViewCell, withMovie movie : MovieModel){
        
        if let imageData = movie.image{
            //outlet de la celda
            
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!), placeholder: #imageLiteral(resourceName: "img-loading"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    
    
}

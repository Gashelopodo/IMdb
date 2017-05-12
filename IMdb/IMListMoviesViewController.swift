//
//  IMListMoviesViewController.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class IMListMoviesViewController: UIViewController {

    
    //MARK:- variables locales
    
    var movies = [MovieModel]()
    var collectionPading : CGFloat = 0
    let customRefresh = UIRefreshControl()
    let dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    
    
    //MARK:- IBOutlet

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearch: UISearchBar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        customRefresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = UIColor.white
        myCollectionView.refreshControl = customRefresh
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        loadData()
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearch.delegate = self
        
        
        /*
        let remote = RemoteItunesMovieService()
        remote.getTopMovies { (resultData) in
            print("\(resultData)")
        }
        */

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
    
    //MARK: Utils
    
    func loadData(){
        
        dataProvider.topMovie({ (localResult) in
            
            if let movieData = localResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }else{
                print("No hay registro en CoreData")
            }
            //self.customRefresh.endRefreshing()
        }) { (remoteResult) in
            
            if let movieData = remoteResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefresh.endRefreshing()
                }
            }
            
        }
        
    }
    
    func hideKeyboard(){
        
    }

}


//MARK: - extención de collection delegate

extension IMListMoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
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
    
    
    /****************************************** UICOLLECTION VIEW DELEGATE *****************************************************/
    
    
    
    
    
    
    /****************************************** SEARCH DELEGATE *****************************************************/
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(tapGR)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            loadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text{
            //invocamos CoreData
            dataProvider.searchMovie(term, remoteHandler: { (resultMovie) in
                if let movieData = resultMovie{
                    self.movies = movieData
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
            })
        }
    }
    
    
    
    
    /****************************************** SEARCH DELEGATE *****************************************************/
    
    
    
    
    
    
    
    
}

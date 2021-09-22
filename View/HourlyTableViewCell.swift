//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Mikael Galliot on 26/08/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var hourlyForCast:[HourlyForCastDetails] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData( hourlyForCast:[HourlyForCastDetails]  ) {
        self.hourlyForCast = hourlyForCast
        collectionView.reloadData()
    }

}

extension HourlyTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyForCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HorlyCollectionViewCell", for: indexPath) as? HorlyCollectionViewCell else {
               return UICollectionViewCell()
            }
            
         let hourlyForCast = self.hourlyForCast[indexPath.row]
            cell.hourLabel.text = hourlyForCast.date
            cell.tempLabel.text = hourlyForCast.temp
        
     
            
       return cell
    }
    
    
}

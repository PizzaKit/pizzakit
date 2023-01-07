import UIKit
import PizzaCore

public protocol PizzaCollectionViewFlowLayoutPlugin {
    func prepareAttributes(
        _ attributes: PizzaCollectionViewFlowLayoutPluginableLayoutAttributes,
        in collectionView: UICollectionView,
        scrollDirection: UICollectionView.ScrollDirection,
        alignment: PizzaCollectionViewFlowLayoutPluginableAlignment?,
        sectionInset: UIEdgeInsets
    ) -> PizzaCollectionViewFlowLayoutPluginableLayoutAttributes
}

public extension PizzaCollectionViewFlowLayoutPlugin {

    func prepareAttributes(
        _ attributes: PizzaCollectionViewFlowLayoutPluginableLayoutAttributes,
        in collectionView: UICollectionView,
        scrollDirection: UICollectionView.ScrollDirection,
        alignment: PizzaCollectionViewFlowLayoutPluginableAlignment?,
        sectionInset: UIEdgeInsets
    ) -> PizzaCollectionViewFlowLayoutPluginableLayoutAttributes {
        return attributes
    }

}

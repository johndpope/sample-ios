//
//  Extension.swift
//  OMGShop
//
//  Created by Mederic Petit on 20/10/17.
//  Copyright © 2017-2018 Omise Go Ptd. Ltd. All rights reserved.
//

import OmiseGO
import BigInt

func dispatchMain(_ block: @escaping EmptyClosure) {
    DispatchQueue.main.async { block() }
}

extension MintedToken {

    func display(forAmount amount: BigUInt) -> String {
        return Double(amount).displayablePrice(withSubunitToUnitCount: self.subUnitToUnit)
    }

}

extension UIColor {

    static func color(fromHexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        let hexint = Int(colorInteger(fromHexString: fromHexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

        return color
    }

    private static func colorInteger(fromHexString: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: fromHexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)

        return hexInt
    }

}

extension String {

    func isValidEmailAddress() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                                             options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    }

    func isValidPassword() -> Bool {
        return self.count >= 8
    }

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

}

extension UITableView {

    public func registerNib(tableViewCell: UITableViewCell.Type) {
        self.register(UINib.init(nibName: String(describing: tableViewCell), bundle: nil),
                      forCellReuseIdentifier: String(describing: tableViewCell))
    }

    public func registerNibs(tableViewCells: [UITableViewCell.Type]) {
        tableViewCells.forEach { (tableViewCell) in
            self.registerNib(tableViewCell: tableViewCell)
        }
    }

}

extension UITableViewCell {

    class func identifier() -> String {
        return String(describing: self)
    }

}

extension UIImageView {

    func downloaded(from url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }

}

extension Double {

    func displayablePrice(withSubunitToUnitCount subUnitToUnit: Double = 100) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "THB"
        formatter.currencySymbol = "฿"
        let displayableAmount: Double = self / subUnitToUnit
        return formatter.string(from: NSNumber(value: displayableAmount)) ?? ""
    }

}

extension UIViewController {

    class func newInstance<T: UIViewController>(fromStoryboard storyboard: Storyboard) -> T? {
        let identifier = String(describing: self)

        return UIStoryboard(name: storyboard.name, bundle: nil).instantiateViewController(withIdentifier:
            identifier) as? T
    }

}

extension Date {

    func toString(withFormat format: String? = "dd MMM yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

}

extension UIView {

    func addDropShadow(withColor color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

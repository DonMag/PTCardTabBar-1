//
//  ShowHideExample.swift
//  PTCardTabBar_Example
//
//  Created by Don Mag on 9/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import PTCardTabBar

class BaseTableViewController: UITableViewController {
	var myData: [String] = []
	var mySegueID: String = ""
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
		c.textLabel?.text = myData[indexPath.row]
		return c
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let ptcTBC = tabBarController as? PTCardTabBarController {
			ptcTBC.showTabBar(indexPath.row % 2 == 0, animated: true)
		}
		performSegue(withIdentifier: mySegueID, sender: indexPath)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? BaseDetailViewController,
		   let indexPath = sender as? IndexPath {
			vc.theString = myData[indexPath.row]
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let ptcTBC = tabBarController as? PTCardTabBarController {
			ptcTBC.tintColor = .red
		}
		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let ptcTBC = tabBarController as? PTCardTabBarController {
			ptcTBC.showTabBar(true, animated: true)
		}
	}
}
class TabATableViewController: BaseTableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		myData = (1...30).map { "Tab A Table row \($0)" }
		myData[0] = "Odd rows leave CustomTabBar showing"
		myData[1] = "Even rows will hide the CustomTabBar"
		mySegueID = "tabADetailSegue"
	}
}
class TabBTableViewController: BaseTableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		myData = (1...30).map { "Tab B Table row \($0)" }
		myData[0] = "Odd rows leave CustomTabBar showing"
		myData[1] = "Even rows will hide the CustomTabBar"
		mySegueID = "tabBDetailSegue"
	}
}
class BaseDetailViewController: UIViewController {
	@IBOutlet var theLabel: UILabel!
	var theString: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		theLabel.text = theString
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}
class DetailAViewController: BaseDetailViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .green
	}
}

class DetailBViewController: BaseDetailViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .yellow
	}
}


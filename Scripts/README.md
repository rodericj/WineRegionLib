# Fetching AVA information

#Dependencies

- [BeautifulSoup](https://macdown.uranusjr.com)
   - `pip3 install BeautifulSoup4`
- [pygithub](https://pygithub.readthedocs.io/en/latest/introduction.html)
   - `pip3 install pygithub`
- [Requests](https://requests.readthedocs.io/en/master/)
   - `pip3 install requests`

## USA
The united states geojson data comes from [UCDavis' American Viticultural Areas (AVA) Project](https://github.com/rodericj/ava/tree/master) which did a great job of collecting all of the Wine regions across the United States. 

### The origin data
The state specific avas are described in [`avas_by_state/CA_avas.geojson`](https://github.com/rodericj/ava/blob/master/avas_by_state/CA_avas.geojson) (with `CA` being replaced by the appropriate 2 letter abbreviation. 

### The script
In the python script [`getUSA.py`](https://github.com/rodericj/WineRegionLib/blob/main/Scripts/getUSA.py) we parse out the information from the origin data and build a tree using [AnyTree](https://github.com/rodericj/WineRegionLib/blob/main/Scripts/getUSA.py). We do this by determining the value of the `within` for each region in the origin data for the deepest node. For example: `santa_clara_valley` is within both Central Coast and San Francisco Bay so we use San Francisco Bay because Central Coast is a top level region (depth of 0) and San Francisco Bay is 1 step deeper.

We grab both Oregon and California data and add these to a [`USA.json`](https://github.com/rodericj/WineRegionLib/blob/main/Scripts/USA.json). 



## Italy

### Origin Data
The Italian Ministry of agricultural, food and forestry policy has provided a [website](https://dopigp.politicheagricole.gov.it/en/web/guest/mappa-delle-denominazioni?idProdotto=730&idDisciplinare=761) which links to each of the regions in Italy. If we search for wines, we get a list of 525 wine subregion names paired with their region.


### The script
The regions and subregions are then grok'd by [getItaly.py](https://github.com/rodericj/WineRegionLib/blob/main/Scripts/getItaly.py) using [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) with some massaging of the data. These files are then referenced in [this json blob](https://github.com/rodericj/WineRegionLib/blob/main/Scripts/Italy.json).

## Storage

Both Italy and USA json files are stored in the same json format. These can then be read by an app in a standard [`Codable`](https://developer.apple.com/documentation/swift/codable) friendly way.

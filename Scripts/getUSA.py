from typing import Any

import json
import anytree
# from anytree.exporter import JsonExporter
from AVAFeatureNode import AVAFeatureNode

# Straight up copy paste of California
def getState(abbreviation, stateName):
    fileName = "/Users/roderic/dev/rodericj/WineRegionLib/Data/" + abbreviation + "_avas.geojson"
    file = open(fileName, 'r')
    print(fileName)
    data = json.load(file)

    allFeatures = data["features"]

    stateNode = AVAFeatureNode(stateName,
                                    "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/" + stateName.replace(" ", "") + ".geojson")
    for feature in allFeatures:
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        thisfeatureAsNode = AVAFeatureNode(name, url)
        if feature["properties"]["within"] is None:
            thisfeatureAsNode.parent = stateNode
            continue

    for feature in allFeatures:
        if feature["properties"]["within"] is None:
            continue  # because we've already added it
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        withinArray = feature["properties"]["within"].split("|")
        allWithin = anytree.findall(stateNode, filter_=lambda node: node.name in withinArray)
        filtered_lst = [(x, y) for x, y in enumerate(allWithin)]

        if len(filtered_lst) == 0:
            continue
        thisfeatureAsNode = AVAFeatureNode(name, url, parent=max(filtered_lst)[1])
    return stateNode

usa = AVAFeatureNode("USA", "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/USA.geojson")

oregonNode = getState("OR", "Oregon")
californiaNode = getState("CA", "California")
washingtonNode = getState("WA", "Washington")
newYorkNode = getState("NY", "New York")

californiaNode.parent = usa
oregonNode.parent = usa
washingtonNode.parent = usa
newYorkNode.parent = usa
usa.depthFirstTreeIteration(None)

# for pre, fill, node in RenderTree(californiaNode):
#     treestr = u"%s%s" % (pre, node.name)
#     print(treestr.ljust(8), node.url)
# exporter = JsonExporter(indent=2, sort_keys=True)



# print(exporter.export(usa))

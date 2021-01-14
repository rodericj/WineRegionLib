from typing import Any

import json
import anytree
import requests

from anytree import NodeMixin, RenderTree, Node
from anytree import Node, RenderTree, AsciiStyle
from anytree.exporter import JsonExporter

## This is the anytree implementation

class MyBaseClass(object):
    avaID = ""
    title = ""
class AVAFeatureNode(MyBaseClass, NodeMixin):  # Add Node feature
    def __init__(self, name, avaID, url, parent=None, children=None):
        self.name = name
        self.title = name
        self.avaID = avaID
        self.url = url
        self.parent = parent
        if children:
            self.children = children

def depthFirstTreeIteration(treeNode, parentID):
    print(parentID, treeNode.name)
    exporter = JsonExporter(indent=2, sort_keys=True)

    # print(exporter.export(usa))
    id = 0
    payload = exporter.export(treeNode)
    payload = {'name': treeNode.name, 'title': treeNode.name, 'url': treeNode.url}
    print(payload)
    headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

    if parentID is None:
        # Post this item, if there is a parent
        # get the unique ID from the response
        # pass the uniqueID in the next call
        print("POST")
        url = 'http://localhost:8080/region'
        regions_post_response = requests.post(url=url, json=payload)
        if regions_post_response.status_code == 200:
            id = regions_post_response.json()['id']
        else:
            print(regions_post_response.status_code)
            return
    else:
        url = 'http://localhost:8080/region/' + parentID
        print("PUT on ", parentID)
        print(url)
        regions_put_response = requests.put(url=url, json=payload)
        if regions_put_response.status_code == 200:
            id = regions_put_response.json()['id']
        else:
            return
        # PUT this item and attach it to parentID
    for child in treeNode.children:
        print("down a level.", len(treeNode.children))
        depthFirstTreeIteration(child, id)
        print("up a level")

# Straight up copy paste of California
def getState(abbreviation, stateName):
    fileName = "/Users/roderic/dev/rodericj/WineRegionLib/Data/" + abbreviation + "_avas.geojson"
    file = open(fileName, 'r')
    print(fileName)
    data = json.load(file)

    allFeatures = data["features"]

    stateNode = AVAFeatureNode(stateName, "none",
                                    "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/" + stateName.replace(" ", "") + ".geojson")
    for feature in allFeatures:
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        thisfeatureAsNode = AVAFeatureNode(name, avaID, url)
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
        thisfeatureAsNode = AVAFeatureNode(name, avaID, url, parent=max(filtered_lst)[1])
    return stateNode

usa = AVAFeatureNode("USA", "none", "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/USA.geojson")

oregonNode = getState("OR", "Oregon")
californiaNode = getState("CA", "California")
washingtonNode = getState("WA", "Washington")
newYorkNode = getState("NY", "New York")

californiaNode.parent = usa
oregonNode.parent = usa
washingtonNode.parent = usa
newYorkNode.parent = usa

depthFirstTreeIteration(usa, None)

# for pre, fill, node in RenderTree(californiaNode):
#     treestr = u"%s%s" % (pre, node.name)
#     print(treestr.ljust(8), node.url)
exporter = JsonExporter(indent=2, sort_keys=True)



# print(exporter.export(usa))

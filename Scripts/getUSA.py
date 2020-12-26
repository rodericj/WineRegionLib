import json
import anytree
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

# Straight up copy paste of California
def getOregon():
    oregonFileName = '/Users/roderic/dev/rodericj/WineRegionLib/Scripts/OR_avas.geojson'
    oregonFile = open(oregonFileName, 'r')
    oregonData = json.load(oregonFile)

    allFeatures = oregonData["features"]

    oregonNode = AVAFeatureNode("Oregon", "none",
                                    "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/Oregon.geojson")
    for feature in allFeatures:
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        thisfeatureAsNode = AVAFeatureNode(name, avaID, url)
        if feature["properties"]["within"] is None:
            thisfeatureAsNode.parent = oregonNode
            continue

    for feature in allFeatures:
        if feature["properties"]["within"] is None:
            continue  # because we've already added it
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        withinArray = feature["properties"]["within"].split("|")
        allWithin = anytree.findall(californiaNode, filter_=lambda node: node.name in withinArray)
        filtered_lst = [(x, y) for x, y in enumerate(allWithin)]

        if len(filtered_lst) == 0:
            continue
        thisfeatureAsNode = AVAFeatureNode(name, avaID, url, parent=max(filtered_lst)[1])
    return oregonNode

def getCalifornia():
    californiaFileName = '/Users/roderic/dev/rodericj/WineRegionLib/Scripts/CA_avas.geojson'
    californiaFile = open(californiaFileName, 'r')
    californiaData = json.load(californiaFile)

    allFeatures = californiaData["features"]
    californiaNode = AVAFeatureNode("California", "none",
                                    "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/USA/California.geojson")
    for feature in allFeatures:
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        thisfeatureAsNode = AVAFeatureNode(name, avaID, url)
        if feature["properties"]["within"] is None:
            thisfeatureAsNode.parent = californiaNode
            continue

    for feature in allFeatures:
        if feature["properties"]["within"] is None:
            continue  # because we've already added it
        name = feature["properties"]["name"]
        avaID = feature["properties"]["ava_id"]
        url = "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID.replace(" ", "") + ".geojson"

        withinArray = feature["properties"]["within"].split("|")
        allWithin = anytree.findall(californiaNode, filter_=lambda node: node.name in withinArray)
        filtered_lst = [(x, y) for x, y in enumerate(allWithin)]

        if len(filtered_lst) == 0:
            continue
        thisfeatureAsNode = AVAFeatureNode(name, avaID, url, parent=max(filtered_lst)[1])
    return californiaNode


usa = AVAFeatureNode("USA", "none", "")

californiaNode = getCalifornia()
oregonNode = getOregon()

californiaNode.parent = usa
oregonNode.parent = usa

# for pre, fill, node in RenderTree(californiaNode):
#     treestr = u"%s%s" % (pre, node.name)
#     print(treestr.ljust(8), node.url)
exporter = JsonExporter(indent=2, sort_keys=True)

print(exporter.export(usa))

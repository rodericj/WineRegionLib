import json

fileName = '/Users/roderic/dev/rodericj/WineRegionLib/Scripts/CA_avas.geojson'
file = open(fileName, 'r')
d = json.load(file)

allFeatures = d["features"]

def childrenOf(features, topLevelFeaturesArray):
    #print("entering children of with features: ... ", len(features))
    children = []
    for firstLevelFeature in features:
        #print("first level feature name ", firstLevelFeature["properties"]["name"])
        avaID = firstLevelFeature["properties"]["ava_id"]
        title = firstLevelFeature["properties"]["name"]
        thisChild = {"title": title,
                     "ava_id": avaID,
                     "url": "https://raw.githubusercontent.com/rodericj/ava/master/avas/" + avaID + ".geojson"
                     }
        # at this point i've decided that subFeatures isn't a thing, we need to do a more global lookup
        topLevelContainsList = firstLevelFeature["properties"]["contains"]

        if topLevelContainsList is None:
            #print("no contains in ", title)
            continue
        otherRegionNamesInsideThisFeature = topLevelContainsList.split("|")
        #print("contains", len(otherRegionNamesInsideThisFeature))

        fullRegionObjectsInsideThisFeature = []
        for regionName in otherRegionNamesInsideThisFeature:
            #print("try to find from the global list", regionName)
            for secondLevelFeature in features: # Iterate through the parameter array of features
                #print("does ", regionName, " = ", secondLevelFeature["properties"]["name"])
                if secondLevelFeature["properties"]["name"] == regionName:
                    #print("found ", regionName, " in ", firstLevelFeature["properties"]["name"])
                    fullRegionObjectsInsideThisFeature.append(secondLevelFeature)
                    # let's retain that feature
        thisChildsChildren = childrenOf(fullRegionObjectsInsideThisFeature, topLevelFeaturesArray)
        if len(thisChildsChildren) != 0:
            thisChild["children"] = thisChildsChildren

        children.append(thisChild)

    return children


california = {
    "title": "California",
    "url" : "http://www.cool.com",
    "children": []
}


californiaChildren = []
theResults = childrenOf(allFeatures, allFeatures)

california["children"] = theResults
# print(california)

print(json.dumps(california, indent=4))

# print(json.dumps(d, indent=4))


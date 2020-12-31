from bs4 import BeautifulSoup
import json
import re
import urllib.request
import urllib
import string

#                                                                                  class="card prduct-card-position col-md-6 col-sm-6 product-card">
#
#                                                                                 <div class="text-white">
#                                                                                         <div class="card-body flex-child">
#                                                                                                 <p class="mb-0 product-title">
#
#
#                                                                                                                 Chianti Classico DOP
#
#                                                                                                 </p>
#
#                                                                                                 <h6 class="mt-2 mb-1 qcont">
#
#                                                                                                                 tuscany
#
#
#
#                                                                                                 </h6>
# Example data
# <p class="mb-0 product-title"> Zafferano di San Gimignano DOP </p> <h6 class="mt-2 mb-1 qcont"> tuscany </h6>
# <h6 class="mt-2 mb-1 qcont">

# For looking up the names of the regions
lookupFileName = "/Users/roderic/dev/rodericj/WineRegionLib/Data/disciplinari.json"
lookupFile = open(lookupFileName, 'r')
lookupData = json.load(lookupFile)

fileName = "/Users/roderic/dev/rodericj/WineRegionLib/Data/italyWebsite.html"

file = open(fileName, 'r')

soup = BeautifulSoup(file.read(), features="html.parser")
tops = soup.find_all("p", class_="product-title")
bottoms = soup.find_all("h6", class_="qcont")
both = zip(tops, bottoms)

tupleArray = []
for result in tuple(both):
    strippedTops = repr(result[0]).replace('\\t', '').replace('\n', '').replace('\\n', '').replace(
        '<p class="mb-0 product-title">', '').replace('</p>', '')
    strippedBottoms = repr(result[1]).replace('\\t', '').replace('\n', '').replace('\\n', '').replace(
        '<h6 class="mt-2 mb-1 qcont">', '').replace('</h6>', '')
    tupleArray.append((strippedBottoms, strippedTops))

# print(tupleArray)

d = {}

branch = "renameItalyGeoJson"


def getRegionTuple(htmlSnippet):
    splits = re.split('\n|\t', htmlSnippet.get_text())
    spaceFiltered = [i for i in splits if i != '' and i != 'Wines']
    return spaceFiltered


pattern = re.compile(r"openProduct\(([0-9]+), [0-9]+")
results = soup.find_all("div", onclick=pattern)
re.split('\n|\t', results[0].get_text())

regionSubRegionPairsArray = [getRegionTuple(x) for x in results]
productID = [re.search(pattern, a["onclick"]).group(1) for a in results]

zippedList = list(zip(productID, regionSubRegionPairsArray))

# print(zippedList)
# print([{"id" : x[0], "region" : x[1][1], "subregion" : x[1][0]} for x in zippedList])

italy = {"title": "Italy",
         "url": "https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_regions.geojson",
         "children": []
         }

italyChildren = {}

for region in zippedList:
    # download the geojson
    regionID = region[0]
    downloadUrl = "https://dopigp.politicheagricole.gov.it/bedopigp/v1/disciplinari/" + regionID + "/mapOpenData"

    # touch up the name
    uneditedSubregionName = \
    [x["prodotto"]["denominazione"] for x in lookupData if x["idDisciplinare"] == int(regionID)][0]

    subRegionName = region[1][0].replace(" ", "") \
        .replace("/", "").replace("'", "") \
        .replace(".", "").replace("’", "").replace("-", "").replace("\"", "").replace("”", "")

    # name the downloaded file
    fileName = subRegionName + ".geojson"


    # encodedName = bytes(subRegionName, 'utf-8').decode('utf-8', 'ignore')

    encodedName = ''.join(x for x in subRegionName if x in string.printable)
    # encodedName = urllib.parse.quote(subRegionName).bytes(line, 'utf-8').decode('utf-8','ignore')
    writeURL = "../WineRegionMaps/Italy/" + encodedName + ".geojson"
    # print("wget", downloadUrl, "--quiet -O ", writeURL + " &")
    # get the appropriate italy child based on the region
    regionName = region[1][1]

    if regionName not in italyChildren.keys():
        italyChildren[regionName] = {"title": regionName,
                                     "children": []}

    dictURL = "https://raw.githubusercontent.com/rodericj/WineRegionMaps/" + branch + "/Italy/" + encodedName + ".geojson"

    # response = urllib.request.urlopen(dictURL)
    # if response.status != 200:
    #     print("Failed: ", response.status, dictURL)
    # print(dictURL)
    subRegionObject = {"title": uneditedSubregionName,
                       "originalURL": downloadUrl,
                       "url": dictURL}

    # find the item that has the appropriate one. italyChildren is an array
    italyChildren[regionName]["children"].append(subRegionObject)
    # add this child to the italy object

italy["children"] = list(italyChildren.values())
print(json.dumps(italy, indent=4))

# https://dopigp.politicheagricole.gov.it/bedopigp/v1/disciplinari/114/mapOpenData

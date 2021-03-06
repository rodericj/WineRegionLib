from bs4 import BeautifulSoup
import json
import re
import urllib.request
import urllib
import string
from AVAFeatureNode import AVAFeatureNode

#  class="card prduct-card-position col-md-6 col-sm-6 product-card">
#
#  <div class="text-white">
# <div class="card-body flex-child">
#   <p class="mb-0 product-title">
#                  Chianti Classico DOP
#  </p>
#<h6 class="mt-2 mb-1 qcont">
#tuscany
#</h6>


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

branch = "main"


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

italyNode = AVAFeatureNode("Italy",
                       "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/allRegions.geojson")
italy = {"title": "Italy",
         "url": "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/allRegions.geojson",
         "children": []
         }

italyChildren = {}

for region in zippedList:
    print(region)
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
    subNode = AVAFeatureNode(regionName, writeURL)
    print(subNode.title, subNode.url)
    if regionName not in italyChildren.keys():
        italyChildren[regionName] = {"title": regionName,
                                     "children": []}
        if regionName == 'abruzzo':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/AbruzzoDOP.geojson'

        if regionName == 'trentino':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/TrentinoDOP.geojson'

        if regionName == 'apulia':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/PugliaIGP.geojson'

        if regionName == 'basilicata':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/BasilicataIGP.geojson'

        if regionName == 'calabria':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/CalabriaIGP.geojson'

        if regionName == 'campania':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/CampaniaIGP.geojson'

        if regionName == 'emilia romagna':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/EmiliadellEmiliaIGP.geojson'

        if regionName == 'friuli venezia giulia' or regionName == 'friuli venezia giulia - veneto' or regionName == 'friuli venezia giulia and other 2':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/VeneziaGiuliaIGP.geojson'

        if regionName == 'lazio' or regionName == 'lazio - umbria':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/LazioIGP.geojson'

        # Lazio - Umbria could be handled automatically since there is only 1 child

        if regionName == 'liguria' or regionName == 'liguria - tuscany':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/Liguria.geojson'

        # Liguria - Tuscany could be handled automatically since there is only 1 child

        if regionName == 'lombardy' or regionName == 'lombardy - veneto':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/Lombardy.geojson'

        if regionName == 'marche':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/MarcheIGP.geojson'

        if regionName == 'molise':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/MolisedelMoliseDOP.geojson'

        if regionName == 'piedmont':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/Piedmont.geojson'

        if regionName == 'sardinia':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/CannonaudiSardegnaDOP.geojson'

        if regionName == 'sicily':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/SiciliaDOP.geojson'

        if regionName == 'trentino' or regionName == 'trentino - veneto':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/Trentino.geojson'

        if regionName == 'tuscany':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/ToscanoToscanaIGP.geojson'

        if regionName == 'umbria':
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/UmbriaIGP.geojson'

        if regionName == "veneto":
            italyChildren[regionName]['url'] = 'https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/VenetoIGP.geojson'

        if regionName == "valle d'aosta":  # remove this
            del italyChildren[regionName]
            
    dictURL = "https://raw.githubusercontent.com/rodericj/WineRegionMaps/" + branch + "/Italy/" + encodedName + ".geojson"

    # response = urllib.request.urlopen(dictURL)
    # if response.status != 200:
    #     print("Failed: ", response.status, dictURL)
    # else:
    #     print("good to go")
    # print(dictURL)


    # Note: There are a few italian regions that are not valid for whatever reason. They have a 0 byte file size
    blacklist = ["AffileCesanesediAffileDOP",
                "AltoAdigeSdtirolSdtirolerdell",
                "AnsonicaCostadellArgentarioDOP",
                "CaldaroKaltererKaltererseeLagodi",
                "CerasuolodiVittoriaDOP",
                "ColliPiacentiniDOP",
                "FalanghinadelSannioDOP",
                "GardaDOP",
                "GhemmeDOP",
                "GutturnioDOP",
                "LisonPramaggioreDOP",
                "OrtrugodeiColliPiacentiniOrtrugoC",
                "ReciotodiSoaveDOP",
                "RivieradelBrentaDOP",
                "RivieraligurediPonenteDOP",
                "RossodiMontepulcianoDOP",
                "SannioDOP",
                "ValledAostaValledAosteDOP",
                "delleVenezieBenekihokolievDOP"]

    subRegionObject = {"title": uneditedSubregionName,
                       "originalURL": downloadUrl,
                       "url": dictURL}

    if encodedName not in blacklist:
        # find the item that has the appropriate one. italyChildren is an array
        italyChildren[regionName]["children"].append(subRegionObject)

italy["children"] = list(italyChildren.values())

for child in italy["children"]:
    print("hi")
    print(child["title"])
    # print(child.keys())
    # print("url is ", child["url"])
    region = AVAFeatureNode(child["title"], child["url"])
    # print("made the region")
    region.parent = italyNode
    # print(child["title"])
    for deepChild in child["children"]:
        subRegion = AVAFeatureNode(deepChild["title"], deepChild["url"])
        subRegion.parent = region
        print("  ", deepChild["title"])
print(italyNode)

italyNode.depthFirstTreeIteration(None)
# print(json.dumps(italy, indent=4))

# https://dopigp.politicheagricole.gov.it/bedopigp/v1/disciplinari/114/mapOpenData

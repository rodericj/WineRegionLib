from bs4 import BeautifulSoup
import json
# Example data
# <p class="mb-0 product-title"> Zafferano di San Gimignano DOP </p> <h6 class="mt-2 mb-1 qcont"> tuscany </h6>
# <h6 class="mt-2 mb-1 qcont">

def StructTitleDecorator(nameOfStruct):
    return nameOfStruct.title().replace("\t", "")#.replace(" ", "").replace("-", "_").replace("'", "")

def CaseTitleDecorator(nameOfCase):
    #allCaps = nameOfCase.title().replace("\"", "")
    allCaps = nameOfCase.title()#.replace("\"", "")
    return allCaps.replace("\t", "").replace("dop", "DOP").replace("igp", "IGP")#replace(" ", "").replace("/", "").replace("...", "").replace("-", "_").replace("'", "").replace(".", "").replace("'", "").replace("’", "").replace("!", "").replace("”", "")
#    return replaced[0].lower() + replaced[1:]

def Convert(tup, di): 
    for a, b in tup: 
        di.setdefault(a, set()).add(CaseTitleDecorator(b))
    return di 

def printSwiftStruct(result):
    print("public struct Italy {")
    for region in result:
        print(f'    public enum {StructTitleDecorator(region)}: String, AppelationDescribable, CaseIterable {{')

        for subRegion in result[region]:
            #print(f'        case {subRegion} ')
            print(f'        case {CaseTitleDecorator(subRegion)} ')

        print("    }")

    print("}")

def convertSubRegionToURL(subRegion):
    root = "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/"
    newSubRegion = subRegion.replace("\t", "") \
        .replace(" ", "").replace("...", "") \
        .replace("-", "_").replace("'", "").replace(".", "") \
        .replace("'", "").replace("’", "").replace("!", "") \
        .replace("”", "").replace("\"", "").replace(" ", "").replace("Dop", "DOP") \
        .replace("Igp", "IGP").replace("/", "")

    return root + newSubRegion + ".geojson"

def convertToJson(result):

    italyChildren = []
    for region in result:
        regionDict = {}
        regionName = StructTitleDecorator(region)
        regionDict["title"] = regionName
        children = []
        for subRegion in result[region]:
            title = CaseTitleDecorator(subRegion)
            url = convertSubRegionToURL(subRegion)
            newValue = {"title": title,
                        "url": url
                        }
#            print(url)
            children.append(newValue)
        regionDict["children"] = children
        italyChildren.append(regionDict)

    # Set up the top level italy map
    italy = { "title" : "Italy",
              "url" : "https://raw.githubusercontent.com/openpolis/geojson-italy/master/geojson/limits_IT_regions.geojson",
              "children": italyChildren
            }

    return italy


fileName = "/Users/roderic/dev/rodericj/WineRegionLib/Scripts/italyWebsite.html"
file = open(fileName, 'r')
soup = BeautifulSoup(file.read(), features="html.parser")
tops = soup.find_all("p", class_="product-title")
bottoms = soup.find_all("h6", class_="qcont")
both = zip(tops, bottoms)

tupleArray = []
for result in tuple(both):
    strippedTops = repr(result[0]).replace('\\t', '').replace('\n', '').replace('\\n', '').replace('<p class="mb-0 product-title">', '').replace('</p>', '')
    strippedBottoms = repr(result[1]).replace('\\t', '').replace('\n', '').replace('\\n', '').replace('<h6 class="mt-2 mb-1 qcont">', '').replace('</h6>', '')
    tupleArray.append((strippedBottoms, strippedTops))

#print(tupleArray)

d = {}
result = Convert(tupleArray, d)


newJsonAbleResult = convertToJson(result)
print(json.dumps(newJsonAbleResult, indent=4))


#printSwiftStruct(result)

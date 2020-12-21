from bs4 import BeautifulSoup

# Example data
# <p class="mb-0 product-title"> Zafferano di San Gimignano DOP </p> <h6 class="mt-2 mb-1 qcont"> tuscany </h6>
# <h6 class="mt-2 mb-1 qcont">

def StructTitleDecorator(nameOfStruct):
    return nameOfStruct.title().replace(" ", "").replace("-", "_").replace("'", "").replace("\t", "")

def CaseTitleDecorator(nameOfCase):
    #allCaps = nameOfCase.title().replace("\"", "")
    allCaps = nameOfCase.title().replace("\"", "")
    replaced = allCaps.replace(" ", "").replace("/", "").replace("...", "").replace("-", "_").replace("'", "").replace(".", "").replace("\t", "").replace("'", "").replace("’", "").replace("!", "").replace("dop", "DOP").replace("igp", "IGP").replace("”", "")
    return replaced[0].lower() + replaced[1:]

def Convert(tup, di): 
    for a, b in tup: 
        di.setdefault(a, set()).add(CaseTitleDecorator(b))
    return di 

fileName = "/Users/roderic/dev/rodericj/WineRegionLib/Scripts/italyWebsite.html"
file = open(fileName, 'r')
soup = BeautifulSoup(file.read())
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
#print(result)

print("public struct Italy {")

for region in result:
    print(f'    public enum {StructTitleDecorator(region)}: String, AppelationDescribable, CaseIterable {{')

    for subRegion in result[region]:
        #print(f'        case {subRegion} ')
        print(f'        case {CaseTitleDecorator(subRegion)} ')

    print("    }")

print("}")

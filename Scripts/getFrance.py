import github
import json
from anytree.exporter import JsonExporter
from AVAFeatureNode import AVAFeatureNode
g = github.Github()

regionFiles = g.get_repo("rodericj/BordeauxWineRegions").get_contents("/")

france = AVAFeatureNode("France", "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/France/France.geojson")
bordeaux = AVAFeatureNode("Bordeaux", "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Bordeaux-AOP_Bordeaux_France.geojson")
bordeaux.parent = france
for regionFile in regionFiles:
    if regionFile.path.endswith(".geojson")\
            and regionFile.path != "Bordeaux_Communes.geojson" \
            and regionFile.path != "Bordeaux-AOP_Bordeaux_France.geojson" \
            and regionFile.path != "Bordeaux-Superior-AOP_Bordeaux_France.geojson":
        dashSplits = regionFile.path.split("-AOP")
        name = dashSplits[0].replace("-", " ").replace(" PDO_Bordeaux_France.geojson", "")
        url = regionFile.download_url
        feature = AVAFeatureNode(name, url)
        feature.parent = bordeaux
# exporter = JsonExporter(indent=2, sort_keys=True)
#
# print(exporter.export(france))

france.depthFirstTreeIteration(None)
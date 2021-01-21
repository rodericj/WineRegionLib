import anytree
import requests

from anytree import NodeMixin, RenderTree, Node
from anytree import Node, RenderTree, AsciiStyle
from anytree.exporter import JsonExporter
## This should definitely be some kind of directory level namespaced type

class MyBaseClass(object):
    title = ""
    avaID = ""

class AVAFeatureNode(MyBaseClass, NodeMixin):  # Add Node feature
    def __init__(self, name, url, parent=None, children=None):
        self.name = name
        self.title = name
        self.url = url
        self.parent = parent
        if children:
            self.children = children

    def depthFirstTreeIteration(self, parentID):
        print(parentID, self.name)
        exporter = JsonExporter(indent=2, sort_keys=True)

        # print(exporter.export(usa))
        id = 0
        payload = exporter.export(self)
        payload = {'name': self.name, 'title': self.name, 'url': self.url}
        print(payload)
        headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        if parentID is None:
            # Post this item, if there is a parent
            # get the unique ID from the response
            # pass the uniqueID in the next call
            print("POST")
            url = 'http://localhost:8080/region'
            regions_post_response = requests.post(url=url, json=payload)
            print(regions_post_response)
            if regions_post_response.status_code == 200:
                id = regions_post_response.json()['id']
            else:
                print("error")
                print(regions_post_response.status_code)
                return
        else:
            url = 'http://localhost:8080/region/' + parentID + "/add"
            print("POST on ", parentID)
            print(url)
            regions_post_response = requests.post(url=url, json=payload)
            if regions_post_response.status_code == 200:
                id = regions_post_response.json()['id']
            else:
                print("error")
                print(regions_post_response.status_code)
                return
            # PUT this item and attach it to parentID
        for child in self.children:
            child.depthFirstTreeIteration(id)

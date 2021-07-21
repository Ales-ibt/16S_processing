#!/usr/bin/env python
# -*- coding: utf-8 -*-
### Before running the program, check ~/.ete exists
from ete3 import NCBITaxa
ncbi = NCBITaxa()
import sys

file_in=sys.argv[1]
file_name=open(file_in)
line = [x.strip('\n') for x in file_name.readlines()]

taxid=ncbi.get_name_translator(line)

taxid_list=[item[0] for item in taxid.values()]

print taxid

tree = ncbi.get_topology(taxid_list, intermediate_nodes=False)

tree.write(format=1, outfile="new_tree.nw")

print tree.get_ascii(attributes=["sci_name"])

tree.render("tree_ete_out.png", dpi=300)

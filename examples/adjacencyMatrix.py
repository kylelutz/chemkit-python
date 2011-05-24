#!/usr/bin/env python

# adjacencyMatrix.py - prints the adjacency matrix of a molecule
# usage: python adjacencyMatrix.py <file>

import sys
import chemkit

# check for and get the input file name from the command line
if len(sys.argv) < 2:
    print 'usage: python adjacencyMatrix.py <file>'
    sys.exit(-1)

fileName = sys.argv[1]

# read molecule from the input file
molecule = chemkit.MoleculeFile.quickRead(fileName)

# print adjacency matrix for molecule
for i in range(molecule.size()):
    a = molecule.atom(i)

    for j in range(molecule.size()):
        b = molecule.atom(j)

        if(a.isBondedTo(b)):
            print "1 ",
        else:
            print "0 ",

    print ""


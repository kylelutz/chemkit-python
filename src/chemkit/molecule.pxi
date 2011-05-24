###############################################################################
##
## Copyright (C) 2009-2011 Kyle Lutz <kyle.r.lutz@gmail.com>
## All rights reserved.
##
## This file is a part of the chemkit project. For more information
## see <http://www.chemkit.org>.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions
## are met:
##
##   * Redistributions of source code must retain the above copyright
##     notice, this list of conditions and the following disclaimer.
##   * Redistributions in binary form must reproduce the above copyright
##     notice, this list of conditions and the following disclaimer in the
##     documentation and/or other materials provided with the distribution.
##   * Neither the name of the chemkit project nor the names of its
##     contributors may be used to endorse or promote products derived
##     from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
## LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
## A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
## LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
## DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
## THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
###############################################################################

import cython
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

from molecule cimport _Molecule

cdef class Molecule:
    """The Molecule class represents a molecule."""

    cdef _Molecule *_molecule
    cdef bool dealloc

    ### Construction and Destruction ##########################################
    def __cinit__(self):
        self._molecule = NULL
        self.dealloc = False

    def __init__(self, char *formula = NULL, char *format = NULL):
        """Creates a new molecule."""

        if formula and format:
            self._molecule = new _Molecule(<string>(formula), <string>(format))
        else:
            self._molecule = new _Molecule()

        self.dealloc = True

    def __dealloc__(self):
        """Destroys the molecule object."""

        if self.dealloc:
            del self._molecule

    ### Properties ############################################################
    def setName(self, char *name):
        """Sets the name for the molecule."""

        self._molecule.setName(<string>(name))

    def name(self):
        """Returns the name of the molecule."""

        return self._molecule.name().c_str()

    def formula(self, char *format = NULL):
        """Returns the formula for the molecule."""

        if format:
            return self._molecule.formula(<string>(format)).c_str()
        else:
            return self._molecule.formula().c_str()

    def size(self):
        """Returns the number of atoms in the molecule."""

        return self._molecule.size()

    def isEmpty(self):
        """Returns True if the molecule is empty."""

        return self._molecule.isEmpty()

    def mass(self):
        """Returns the molecular mass of the molecule."""

        return self._molecule.mass()

    ### Structure #############################################################
    def addAtom(self, element):
        """Adds a new atom to the molecule."""

        e = Element(element)
        if not e.isValid():
            return None

        cdef _Atom *atom = self._molecule.addAtom(cython.operator.dereference(e._element))

        return Atom_toPyObject(atom)

    def removeAtom(self, Atom atom):
        """Removes the atom from the molecule."""

        self._molecule.removeAtom(atom._atom)

    def atom(self, int index):
        """Returns the atom at index in the molecule."""

        return Atom_toPyObject(self._molecule.atom(index))

    def atoms(self):
        """Returns a list of the atoms in the molecule."""

        cdef vector[_Atom *] _atoms = self._molecule.atoms()

        atoms = []
        for i in range(_atoms.size()):
            atoms.append(Atom_toPyObject(_atoms[i]))

        return atoms

    def atomCount(self):
        """Returns the number of atoms in the molecule."""

        return self._molecule.atomCount()

    def addBond(self, Atom a, Atom b, int order = Bond.Single):
        """Adds and returns a new bond between atoms a and b with order."""

        cdef _Bond *bond = self._molecule.addBond(a._atom, b._atom, order)

        return Bond_toPyObject(bond)

    def removeBond(self, Bond bond):
        """Removes bond from the molecule."""

        self._molecule.removeBond(bond._bond)

    def bond(self, int index):
        """Returns the bond at index in the molecule."""

        return Bond_toPyObject(self._molecule.bond(index))

    def bonds(self):
        """Returns a list of the bonds in the molecule."""

        cdef vector[_Bond *] _bonds = self._molecule.bonds()

        bonds = []
        for i in range(_bonds.size()):
            bonds.append(Bond_toPyObject(_bonds[i]))

        return bonds

    def bondCount(self):
        """Returns the number of bonds in the molecule."""

        return self._molecule.bondCount()

    ### Ring Perception #######################################################
    def ring(self, int index):
        """Returns the ring at index in the molecule."""

        return Ring_toPyObject(self._molecule.ring(index))

    def rings(self):
        """Returns a list of rings in the molecule."""

        cdef vector[_Ring*] _rings = self._molecule.rings()

        rings = []
        for i in range(_rings.size()):
            rings.append(Ring_toPyObject(_rings[i]))

        return rings

    def ringCount(self):
        """Returns the number of rings in the molecule."""

        return self._molecule.ringCount()

    ### Fragment Perception ###################################################
    def fragment(self, int index):
        """Returns the fragment at index in the molecule."""

        return Fragment_toPyObject(self._molecule.fragment(index))

    def fragments(self):
        """Returns a list of all the fragments in the molecule."""

        cdef vector[_Fragment*] _fragments = self._molecule.fragments()

        fragments = []
        for i in range(_fragments.size()):
            fragments.append(Fragment_toPyObject(_fragments[i]))

        return fragments
   
    def fragmentCount(self):
        """Returns the number of fragments in the molecule."""

        return self._molecule.fragmentCount()

    def isFragmented(self):
        """Returns True if the molecule contains more than one fragment."""

        return self._molecule.isFragmented()

    def removeFragment(self, Fragment fragment):
        """Removes the fragment from the molecule."""

        self._molecule.removeFragment(fragment._fragment)

cdef Molecule Molecule_toPyObject(_Molecule *molecule):
    if molecule is NULL:
        return None

    cdef Molecule m = Molecule.__new__(Molecule)
    m._molecule = molecule
    return m

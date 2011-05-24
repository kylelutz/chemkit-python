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

from ring cimport _Ring

cdef class Ring:
    """The Ring class represents a cycle of atoms in a molecule."""

    cdef _Ring *_ring

    ### Construction and Destruction ##########################################
    def __cinit__(self):
        self._ring = NULL

    def __init__(self):
        raise TypeError("Ring objects are not constructible")

    #### Properties ###########################################################
    def size(self):
        """Returns the number of atoms in the ring."""

        return self._ring.size()

    def molecule(self):
        """Returns the molecule that the ring is a member of."""

        return Molecule_toPyObject(self._ring.molecule())

    ### Structure #############################################################
    def atom(self, int index):
        """Returns the atom at index in the ring."""

        return Atom_toPyObject(self._ring.atom(index))

    def atoms(self):
        """Returns a list of the atoms in the ring."""

        cdef vector[_Atom *] _atoms = self._ring.atoms()

        atoms = []
        for i in range(_atoms.size()):
            atoms.append(Atom_toPyObject(_atoms[i]))

        return atoms

    def atomCount(self):
        """Returns the number of atoms in the ring."""

        return self._ring.atomCount()

    def bond(self, int index):
        """Returns the bond at index in the ring."""

        return Bond_toPyObject(self._ring.bond(index))

    def bonds(self):
        """Returns a list of bonds in the ring."""

        cdef vector[_Bond *] _bonds = self._ring.bonds()

        bonds = []
        for i in range(_bonds.size()):
            bonds.append(Bond_toPyObject(_bonds[i]))

        return bonds

    def bondCount(self):
        """Returns the number of bonds in the ring."""

        return self._ring.bondCount()

    ### Aromaticity ###########################################################
    def isAromatic(self):
        """Returns True if the ring is aromatic."""

        return self._ring.isAromatic()

cdef Ring Ring_toPyObject(_Ring *ring):
    if ring is NULL:
        return None
    
    cdef Ring r = Ring.__new__(Ring)
    r._ring = ring
    return r


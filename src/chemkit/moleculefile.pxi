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

from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

from moleculefile cimport _MoleculeFile
from moleculefile cimport formats as _MoleculeFile_formats
from moleculefile cimport quickRead as _MoleculeFile_quickRead

cdef class MoleculeFile:
    """The MoleculeFile class represents a file containing molecules."""

    cdef _MoleculeFile *_moleculeFile

    ### Construction and Destruction ##########################################
    def __init__(self, char *fileName = NULL):
        """Creates a new molecule file object."""

        if fileName:
            self._moleculeFile = new _MoleculeFile(<string>(fileName))
        else:
            self._moleculeFile = new _MoleculeFile()

    def __dealloc__(self):
        """Destroys the molecule file object."""

        del self._moleculeFile

    ### Properties ############################################################
    def setFileName(self, char *fileName):
        """Sets the file name for the file to fileName."""

        self._moleculeFile.setFileName(<string>(fileName))

    def fileName(self):
        """Returns the file name of the file."""

        return self._moleculeFile.fileName().c_str()

    def formatName(self):
        """Returns the name of the file format for the file."""

        return self._moleculeFile.formatName().c_str()

    def size(self):
        """Returns the number of molecules in the file."""

        return self._moleculeFile.size()

    def isEmpty(self):
        """Returns True if the file is empty."""

        return self._moleculeFile.isEmpty()

    ### Input and Output ######################################################
    def read(self, char *fileName = NULL, char *formatName = NULL):
        """Reads the file."""

        if fileName is NULL:
            return self._moleculeFile.read()
        else:
            if formatName is NULL:
                return self._moleculeFile.read(<string>(fileName))
            else:
                return self._moleculeFile.read(<string>(fileName), <string>(formatName))

    def write(self, char *fileName = NULL, char *formatName = NULL):
        """Writes the file."""

        if fileName is NULL:
            return self._moleculeFile.write()
        else:
            if formatName is NULL:
                return self._moleculeFile.write(<string>(fileName))
            else:
                return self._moleculeFile.write(<string>(fileName), <string>(formatName))

    ### File Contents #########################################################
    def addMolecule(self, Molecule molecule):
        """Adds molecule to the file."""

        self._moleculeFile.addMolecule(molecule._molecule)

    def removeMolecule(self, Molecule molecule):
        """Removes molecule from the file."""

        return self._moleculeFile.removeMolecule(molecule._molecule)

    def deleteMolecule(self, Molecule molecule):
        """Removes the molecule from the file and deletes it."""

        return self._moleculeFile.deleteMolecule(molecule._molecule)

    def molecule(self, int index = 0):
        """Returns the molecule at index in the file."""

        return Molecule_toPyObject(self._moleculeFile.molecule(index))

    def molecules(self):
        """Returns a list of the molecules in the file."""

        cdef vector[_Molecule*] _molecules = self._moleculeFile.molecules()

        molecules = []
        for i in range(_molecules.size()):
            molecules.append(Molecule_toPyObject(_molecules[i]))

        return molecules

    def moleculeCount(self):
        """Returns the number of molecules in the file."""

        return self._moleculeFile.moleculeCount()

    def contains(self, Molecule molecule):
        """Returns True if the file contains molecule."""

        return self._moleculeFile.contains(molecule._molecule)

    def clear(self):
        """Removes all of the molecules from the file."""

        self._moleculeFile.clear()

    ### Error Handling ########################################################
    def errorString(self):
        """Returns a string describing the last error that occurred."""

        return self._moleculeFile.errorString().c_str()

    ### Static Methods ########################################################
    @classmethod
    def formats(cls):
        """Returns a list of the names of the supported file formats."""

        cdef vector[string] _formats = _MoleculeFile_formats()

        formats = []
        for i in range(_formats.size()):
            formats.append(_formats[i].c_str())

        return formats

    @classmethod
    def quickRead(cls, char *fileName):
        """Reads and returns the molecule from fileName."""

        return Molecule_toPyObject(_MoleculeFile_quickRead(<string>(fileName)))


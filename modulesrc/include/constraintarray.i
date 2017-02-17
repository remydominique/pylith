// -*- C++ -*-
//
// ======================================================================
//
// Brad T. Aagaard, U.S. Geological Survey
// Charles A. Williams, GNS Science
// Matthew G. Knepley, University of Chicago
//
// This code was developed as part of the Computational Infrastructure
// for Geodynamics (http://geodynamics.org).
//
// Copyright (c) 2010-2016 University of California, Davis
//
// See COPYING for license information.
//
// ======================================================================
//

// ----------------------------------------------------------------------
// List of mesh constraints.
%typemap(in) (pylith::feassemble::ConstraintPointwise* constraintArray[],
	      const int numConstraints)
{
  // Check to make sure input is a list.
  if (PyList_Check($input)) {
    const int size = PyList_Size($input);
    $2 = size;
    $1 = (size > 0) ? new pylith::feassemble::ConstraintPointwise*[size] : 0;
    for (int i = 0; i < size; i++) {
      PyObject* s = PyList_GetItem($input,i);
      pylith::feassemble::ConstraintPointwise* constraint = 0;
      int err = SWIG_ConvertPtr(s, (void**) &constraint,
				$descriptor(pylith::feassemble::ConstraintPointwise*),
				0);
      if (SWIG_IsOK(err))
	$1[i] = (pylith::feassemble::ConstraintPointwise*) constraint;
      else {
	PyErr_SetString(PyExc_TypeError, "List must contain constraints.");
	delete[] $1;
	return NULL;
      } // if
    } // for
  } else {
    PyErr_SetString(PyExc_TypeError, "Expected list of constraints.");
    return NULL;
  } // if/else
} // typemap(in) [List of constraints.]

// This cleans up the array we malloc'd before the function call
%typemap(freearg) (pylith::feassemble::ConstraintPointwise* constraintArray[],
		   const int numConstraints) {
  delete[] $1;
}

// End of file
# quickio.py
#
# $Author: andrew $
# $Date: 2009-05-14 16:49:12 +0100 (Thu, 14 May 2009) $

import cPickle, os, sys
from scipy import io

def write(filename, data, overwrite=False):
    """
        Write saves the contents of the given data dictionary object in the specified file
        using Python's Pickle.
        
        Usage: write('filename.sav', dict_object, overwrite) # where overwrite is an optional boolean  
        
        Returns True if succesful, otherwise False
        
    """
    assert isinstance(filename, str), "The file name is required to be of type string.";
    assert isinstance(data, dict), "The input data is required to be a dictionary."
    assert not os.path.exists(filename) or overwrite, "The file already exists. To overwrite, set overwrite flag to True.";
    
    # File exists. Delete file first
    if os.path.exists(filename):
        os.remove(filename);
    
    if filename.lower().endswith('.mat'):
        # MAT file
        try:
            io.savemat(filename, data, False)
            return True
        except BaseException, e:
            print "An error occurred when attempting to write to the file \"" + filename + "\"";
            print "Error: " + str(e)
            return False
    else:
        # Any other type of file    
        try:
            myFile = open(filename, 'w');
            cPickle.dump(data, myFile);
            myFile.close();
            return True;
        except BaseException, e:
            print "An error occurred when attempting to write to the file \"" + filename + "\"";
            print "Error: " + str(e);
            return False;

def read(filename):
    """
        Read a Pickled file and returns the contents.
        
        Usage: dictionary = read('filename.sav')
        
        Returns a dictionary object of saves objects if successful, otherwise False
        
    """    
    assert isinstance(filename, str), "The file name is required to be of type string.";
    assert os.path.exists(filename), "The file to read does not exist.";
    
    if filename.lower().endswith('.mat'):
        # MAT file
        try:
            return io.loadmat(filename)
        except BaseException, e:
            print "An error occurred when attempting to read the file \"" + filename + "\"";
            print "Error: " + str(e);
            return False;
    else:
        # Any other type of file
        try:
            myFile = open(filename, 'r');
            output = cPickle.load(myFile);
            myFile.close();
            return output;
        except BaseException, e:
            print "An error occurred when attempting to read the file \"" + filename + "\"";
            print "Error: " + str(e);
            return False;

def writed(filename, *arg):
    """
        Writed automatically assigns variable names to the input data and saves the data
        in the given file using Python's Pickle.
        
        Usage: writed(filename, object1, object2, ...)
        
        Returns True if succesful, otherwise False
        
    """
    assert isinstance(filename, str), "The file name is required to be of type string.";
    data = dict();
    for i, j in enumerate(arg):
        data['var' + str(i)] = j;
    return write(filename, data, True);

def append(filename, data, bypassParameterCheck = False):
    """
        Append checks for existing variables. If variable were to exist already, 
        the function exits unless the check is bypassed
        
        Usage: append('filename.sav', dict_object)

        Returns True if succesful, otherwise False
                
    """
    assert isinstance(filename, str), "The file name is required to be of type string.";
    assert isinstance(data, dict), "The input data is required to be a dictionary."
    assert os.path.exists(filename), "The file to be append data to does not exist.";
    
    # Open the old file
    oldData = read(filename);
    if data is False:
        print "Could not open file " + filename + "to append data";
        return False;
    
    if not bypassParameterCheck:
        # Check the contents of the file for pre-existing variable names
        # If no check is performed, variables are overwritten
        for a in data:
            if oldData.has_key(a):
                print "Key " + a + " already exists. Use .update method instead."
                return False;
    
    # Now append keys using update method
    oldData.update(data);
    
    # Old file has to be overwritten
    return write(filename, oldData, True);

def appendd(filename, *arg):
    """
        Appendd checks for existing variables in the given filename and gives the input data
        new variable names to avoid clashing with the current file contents.
        
        Usage: appendd('filename.sav', object1, object2, ...)
        
        Returns True if succesful, otherwise False
        
    """
    assert isinstance(filename, str), "The file name is required to be of type string.";
    assert os.path.exists(filename), "The file to be append data to does not exist.";
    
    # File needs to be opened in order to generate names
    data = read(filename);
    if data is False:
        print "Could not open file " + filename + "to append data";
        return False;
        
    # Check names
    offset = 0;
    for i, j in enumerate(arg):
        while data.has_key('var' + str(i + offset)):
            offset += 1; # Key already exists. Increment counter by 1
        data['var' + str(i + offset)] = j;
    
    return append(filename, data, True);

def update(filename, data):
    """
        Update updates the contents of the file and any variables of the same name are overwritten
        
        Usage: update('filename.sav', dict_object)
        
        Returns True if succesful, otherwise False
        
    """
    assert isinstance(filename, str), "The file name is required to be of type string.";
    assert isinstance(data, dict), "The input data is required to be a dictionary."
    assert os.path.exists(filename), "The file to be append data to does not exist.";
    
    return append(filename, data, True);

def save(filename, *arg):
    """
        Save takes the given variable names from the parent workspace and saves them to a file.
        
        Usage: save('filename.sav', 'Object_1', 'Object_2', ...)
               save('filename.sav', 'Object_1, Object_2', ...)
               
        Returns True if succesful, otherwise False
        
    """    
    assert isinstance(filename, str), "The file name is required to be of type string.";
    
    data = dict();
    foundData = False;
        
    parentVars = sys._getframe(1).f_locals;
    # Now it's a case of matching variable names and saving them
    for i in arg:
        # Check data type to ensure variable is string
        if not isinstance(i, str): continue;
        # Split the string up in case it has other elements
        currentArg = i.replace(' ', '').split(',');
        print currentArg
        for j in currentArg:
            # Check to see if the variable exists
            if parentVars.has_key(j):
                # Exists
                data[j] = parentVars[j];
                foundData = True;
            else:
                print "Variable", str(j), "does not exist in the parent workspace.";
    if foundData:
        # Write data using predefined write
        return write(filename, data, True);
    else:
        print "Could not locate variables"

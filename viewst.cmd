/* REXX Scipt to start a windows viewer from WebEx */

/* Obviously, this script expects WebEx to call it like this:
   webst.cmd %s.  That is, it just expects Web Explorer to pass
   the filename of the temporary file it created for whatever it
   just downloaded.  This script can be configured to pass any
   other arguments desired to the actual viewer. */  

/* These first few lines take the name of the temporary file
   passed from Web Explorer, and make a copy of it.  This is necessary
   because WebEx will delete the temporary file it created as soon as
   this REXX script exits, which would mean the temp file wouldn't
   be there for the viewer to open.  The downside is that this new
   file will never be deleted.  I recommend making an object which
   calls a .cmd file which deletes these temp files.  You can put this
   in your startup folder, and also call it whenever you want.
   In my config.sys, I define both the TEMP and TMP environment
   variables, like this:  SET TEMP=f:\temp
                          SET TMP=f:\temp
   Most programs will respect these variables.  The f:\temp can be
   replaces by whatever path is desired.  WebEx, and many other programs
   will now use this directory for their temporary files.  You can now
   create a batch file which, on startup, calls the command "del /n f:\temp\*".
   This will delete all the files in the temp directory on every bootup. */

/* The filename Web Explorer passes is an 8.3 filename.  The character
   right before the period always seems to be a number.  I just map
   this last number into a letter.  This will insure the filename is unique
   (as long as Web Explorer is creating unique filenames), and they
   won't collide with filenames Web Explorer makes. This method has the
   advantage of maintaining the original file's extension. */

parse arg filenmin

periodpos=pos(".",filenmin)
filenlen=length(filenmin)
lastdigit=right(left(filenmin,periodpos-1),1)
fileleft=left(filenmin,periodpos-2)
exten=right(filenmin,filenlen+1-periodpos)
if (lastdigit='0') then lastletter='a'
if (lastdigit='1') then lastletter='b'
if (lastdigit='2') then lastletter='c'
if (lastdigit='3') then lastletter='d'
if (lastdigit='4') then lastletter='e'
if (lastdigit='5') then lastletter='f'
if (lastdigit='6') then lastletter='g'
if (lastdigit='7') then lastletter='h'
if (lastdigit='8') then lastletter='i'
if (lastdigit='9') then lastletter='j'
filenm= fileleft || lastletter || exten

/* filenmin contains Web Explorer's filename. */

'copy' filenmin filenm

/* Finally, call objst.exe, which will start the viewer.  The first
   parameter passed must be the object handle of the object to open,
   obtained with FeelX.  After this, any parameters can be passed to
   the program, with the filename interspersed between them as the
   program needs.  In general it might look like this:
   'objst.exe <handle> <parameters1> <filename> <more parameters>'.
   To add your own parameters, edit the paramstring1, paramstring2
   definitions below.  Right now, they are both set to be empty.
   In this case, 170010 was the object handle of an object on my
   desktop.  There were no other parameters to be passed, except the
   filename.                                                         */

objecthandle='170010'
paramstring1=''
paramstring2=''

'objst.exe' paramstring1 objecthandle paramstring2 filenm


OBJST version 1.10- Start Dos and Windows viewers from Web Explorer!
-------------------------------------------------------------------


Files included
---------------

viewst.cmd:               REXX template for starting the viewer.
objst.exe:                program which starts the viewer
objst.c:                  code for objst.exe
readme.txt:               this file; direction for use
objst.txt:                Archive upload file
proghand.exe:             small program which creates a program object with 
                          known ID
proghand.c:               source for proghand.exe



Description and Instructions
----------------------------

   This program, objst.exe, can be used to start Windows and Dos based
viewers easily from Web Explorer.  It can also be used to start OS/2
viewers.  There are 2 problems it solves, the first is that WebEx won't
easily pass any command line arguments to the program, besides the filename.
You can use this method of starting viewers to do so.  Secondly, for
Windows and Dos programs, there hasn't been a way (AFAIK) to define
any DOS Settings, for example, how much memory, to start the Windows
program seamlessly, to start it in Enhanced Mode, etc.  To tackle these
problems, objst.exe will in fact open a program object you have created
on your desktop.

1) You should put objst.exe somewhere on your path (though not necessary,
   just change the REXX file to locate it. The REXX file must be changed
   anyway, to put in the proper object handle).

2) For each viewer you plan on starting this way, make a program object.
   If you already have a program object for a viewer, great, but you 
   should make a copy of it.  The Parameters field on the first page
   will be overwritten (and not erased), so it shouldn't be the same
   object you use for general purposes.  Make sure the Working Directoy
   field is empty.  don't use a shadow of an existing viewer either (and
   don't copy a shadow, this just makes another shadow).  You will need
   to know the object handle of this program object.  Use the included
   proghand.exe to create this object.  It is placed on the desktop, and
   the program reports back its object handle.  Any parameters passed are used
   for the program object's title.  If no arguments, a default title is
   given.  This program object should be set to "Create Another" on the
   window page of the settings notebook, and you will probably also want
   to _NOT_ use a separate session (for Windows viewers).

3) For each viewer you will need to make a REXX .cmd file.  I have included
   one, which you should make copies of and modify.  The REXX is documented,
   please read it.  WebEx will call this REXX .cmd file, and pass it the 
   filename for the viewer to view.  Basically, the REXX does the following:

   a) Copies the file passed to it (???????n.???) to ???????l.??? where n
      is a number from 0 to 9, and l is a letter from a to j.  Why does it 
      do this?  Well, when the REXX script ends, WebEx will delete the .tmp 
      file, and it will be gone before the viewer can view it.  So, we must 
      copy it before WebEx deletes it.  However, this will litter your temp 
      directory with these copied files, which must manually be deleted.  
      Make a .cmd file wich does something like "del %temp%\*", and make a 
      program object which calls it.  Then you can put it in your startup 
      folder to clean out your temp directory on bootup.

   b) It then calls objst.exe.  The first argument passed is the "object
      handle" (found by creating program object with proghand.exe) of the 
      program object to start.  After this, any command line arguments, 
      and the filename to view, can be passed, in any order.  My REXX 
      script (viewst.cmd) documents this.  objst.exe is the executable 
      which tells OS/2 to open up the program object.

4) Ok, so the REXX script is set up to open the program object.  You could
   try it out now from the command line if you'd like.  You should probably
   put it somewhere on your path, but again I don't think this is necessary,
   you can specify the full path in the Web Explorer.

5) Start Web Explorer.  Go to configure the viewers.  Have it call the
   REXX file you just created.  If you need to edit your extmap.ext and
   mailcap.cap files for this viewer, just call the REXX file followed by %s.
   Volia!  You should now be able to use the Dos or Windows based viewer.


More on using with Web Explorer
-------------------------------
I hope this isn't confusing.  Here's a more specific example.  Say you want
to view Quicktime movies.  You have Quicktime for Windows 2.0 installed,
and can use the Windows Media Player applet to watch them.  But, you want
Web Explorer to load them up also.  First, you'd go make a new program
object for the Windows Media Player, setting the Dos Settings as necessary.
Then you'd copy the sample REXX file to, say, qtw.cmd.  Make this object with
proghand.exe, so you can get the object handle.  Edit qtw.cmd, and put the 
correct object handle on the last line.  Finally, in Web Explorer, configure 
the Quicktime viewer to call qtw.cmd.  Now, when WebEx gets a quicktime movie,
it will load it into the Windows media player applet.  You can give the
media player as much memory as you'd like, make it seamless, separate
session, or fullscreen as you please.  You have the full power of OS/2's
program objects at your disposal to define exactly how you want the viewer
to run.

Another example would be the Real Audio player.  Download it and install it
(http://www.realaudio.com).  Then, use proghand.exe to create a program
object.  Edit it to give it whatever settings you want.  You should use
"Create Another" and "Same Session".  Make it run in 386 Enhanced mode, and
give it a good amount of DPMI memory.  "Create Another" and "Same Session"
will let RealAudio use an already loaded copy of the player, if you've
already been listening to music.  The program object should call pnclient.exe.
Now, copy the sample REXX script, and replace the object handle with the
one for your RealAudio object, which was reported by proghand.exe.  Now,
we need to add a MIME type for Web Explorer to support Realaudio.  First,
edit \tcpip\etc\explore.ini.  Find the advanced section.  It will look
like this:

[advanced]
; advanced user settings - edit with care!
;
; mailcap= specifies full path to user mailcap file
; format is:  mime/type; program_name params %s
; example:    image/jpeg; jview -r %s
; no wildcards allowed, no piping, no unix commands
mailcap=
; extmap= specifies full path to user extension map file
; format is:  mime/type     extension_list
; example:    image/jpeg    jpg jpeg jpe
extmap=

Place pathnames to mailcap.cap and extmap.ext files on the above two lines.
Probably want \tcpip\etc\mailcap.cap and \tcpip\etc\extmap.ext.  Make sure
you aren't running any copies of Web Explorer when running this.

Now, create mailcap.cap and put this line in it:
     audio/x-pn-realaudio;   raclient.cmd %s
Where raclient.cmd is the name of the REXX file used to call the RealAudio
program object.

Finally, edit the extmap.ext and put this file in it:
     audio/x-pn-realaudio    ra ram

This procedure is documented in the Web Explorer help files.

You should now be able to click on RealAudio links, have Web Explorer load
up the RealAudio player, and play the music.


Instructions on using proghand.exe
----------------------------------
All this program does is create a standard OS/2 program object on the desktop.
You can specify a title (including spaces) on the command line for the object.
All setting must be configured once it is created.  proghand.exe will report
back the object handle of this object, which must be passed to objst.exe.


Disclaimer
----------
Use at your own risk.


You are free to look at the code, see how it works, and use it for whatever.
It is actually quite trivial.  If you make any changes, email them to me,
and I will see about including them in an updated version.  Feel free to
email if you have any ideas for enhancements, or a bug report.  You are free
to redistribute this archive, but it must remain unchanged.  This program
is freeware.


Brian Landy
blandy@ucsd.edu


copy of FILE_ID.DIZ
-------------------
(v1.10) Objst: Start WPS program objects
from the command line.  Primarily
useful for starting Dos and Windows
viewers from IBM's Web Explorer.  Can
also be used to pass programs arguments
other than filename from Web Explorer.
Archive contains instructions for setup
with Web Explorer.

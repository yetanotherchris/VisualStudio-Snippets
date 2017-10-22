# VisualStudio Virtual Machine installer

This repo installs all development software _I use_ in one script, and machine customisations. Works nicely with the Azure Visual Studio VM (which costs 13p an hour) - use a DV3 or EV3 size instance to get Docker support.

    iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/yetanotherchris/VisualStudio-VM/master/install.ps1'))
    
or ..

Copy the install.ps1 onto the machine and run it.

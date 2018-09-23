##OUTDATED

A Module to discover and cast Youtube videos to one or all Chromecast devices in your multicast domain.
To discover chromecast devices it uses multicast DNS so the discovery process will only take seconds. The script import necessary .net DLL's from the 'src' folder. You can see the project here > https://github.com/onovotny/Zeroconf.

--------------------------------------------------------------

Import-Module .\Power-Cast.psm1 

Cast  
#Automatically discover and Rickroll all the Chromecast devices in your multicast domain

Discover   
#Discovers all Chromecast devices in your multicast domain

Cast -Video dQw4w9WgXcQ -IPAddresses 192.168.1.48,192.168.1.49  
#Cast Rick to 192.168.1.48 and 192.168.1.49

--------------------------------------------------------------


![image1](https://i.imgur.com/igZJ4J1.png)


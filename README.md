# dockershaper-rpi
A docker image for Mastershaper on the RPI

NOTE : This package makes use of mastershaper, of which you can find here : 
https://github.com/Mithrilhall/MasterShaper

This dockerfile and docker-compose script basically downloads and configures all the required dependencies for this to work.
IN THEORY - this should work. Testing is being done on a rasperry pi running ubuntu server in ARMx64.

Apache webserver based off of webdevops/php-apache
https://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-apache.html

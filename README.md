# my-docker-toolbox
Bash commands to work fluently with Docker and the DockerToolbox
Wndows support : tested with Windows 7, DockerToolbox 1.9, bash shell (comes with the windows git client)
MacOS support  : [WANTED] tester

# 5 minutes tour

From a bash shell, let's create machine, select it, load an image, launch a container

```
> git clone https://github.com/ObjectIsAdvantag/my-docker-toolbox

> source .bashrc-docker

> my-docker

# docker machine commands
dma, dmactive       : docker-machine active
dmcreate            : docker-machine create
dmenv               : prints info about the active machine
dminit [machine]    : (re)sets Docker Toolbox environment, defaults with active machine if unique
dmip, dmhost        : prints active machine ip adddress
dmls                : docker-machine ls
dmreset             : reinstalls certs on docker machine (due to ip address change generally)
dmsize              : displays size of Docker Toolbox machines
dmstart             : docker-machine start
dmstop              : docker-machine stop

# docker image commands
dibuild [name]      : create image from DockerFile
dils                : docker images
dimg [number]       : activate image from images list, show active image if no args
dirm                : removes currently active image

# docker commands
dattach             : attach to latest run container
dcont [number]      : selects container number from container list (dcls)
dls, dps            : docker ps
dlsa, dpsa          : docker ps -a
dlast               : docker ps -l
dlogs               : displays logs of latests container
dopen [port]        : opens a browser for current machine with specified port, defaults to 8080
dopens [port]       : idem dmopen on https
drm                 : interactively remove containers
drmlast             : removes latest launched container
drmall              : removes all containers
drun                : launches a new container

> dmls

> # if you have not created any docker machine yet
> # takes a few minutes to execute
> dmcreate docker-quicktour

> dminit

> dmactive

> dipull centos

> dils

> dimg 1

> drun
docker run centos:latest docker-machine env docker-quicktour
command ?   [command|(default)]: bash
docker run centos:latest bash
detach or interactive ? [d/(i)]:
expose ports ? HOST:CONTAINER :
docker run -it  centos:latest bash ? [(y)|n] :
Launching...

> dps 

```

There you are, done !!!




###############################################################################################################
#
# DOCKER TOOLBOX QUICKIES
# 
###############################################################################################################

#
#
# DOCKER MACHINE COMMANDS
#
#

function my-docker(){
   echo "# docker machine commands"
   my-dm
   echo ""
   echo "# docker image commands"
   my-di
   echo ""
   echo "# docker commands"
   my-d
}

function my-dm() {
   echo "dma, dmactive       : docker-machine active"
   echo "dmcreate            : docker-machine create"
   echo "dmenv               : prints info about the active machine"
   echo "dminit [machine]    : (re)sets Docker Toolbox environment, defaults with active machine if unique"
   echo "dmip, dmhost        : prints active machine ip adddress"
   echo "dmls                : docker-machine ls"
   echo "dmreset             : reinstalls certs on docker machine (due to ip address change generally)"
   echo "dmsize              : displays size of Docker Toolbox machines" 
   echo "dmstart             : docker-machine start"
   echo "dmstop              : docker-machine stop"

}

alias dmls='docker-machine ls 2>/dev/null'

alias dmhelp='docker-machine --help'

function dmsize() {
    (cd  ~/.docker/machine/machines; du -d1 -h .)
}

function dmactive() {
   if [ -z "$DOCKER_HOST" ]; then
      echo "Docker Toolbox environment not initialized, trying to infer running machines"
      echo ""
      docker-machine ls 2>/dev/null | grep "Running" 
      echo ""
      echo "Please run " 
      echo "  dmcreate   : creates a new docker machine hosted in Virtualbox"
      echo "  dminit      : initializes the Docker Toolbox"
      return
   fi

   docker-machine active 2>/dev/null
}

function dmcreate() {
    machine=$1
    if [ -z $machine ]; then
       echo "No machine name specified, exiting..."
       return
    fi

    echo "Creating new machine $machine"
    docker-machine create -d virtualbox $machine
}


function dmstop() {
   machine=$1
   if [ -z "$machine" ]; then
      echo "No docker machine specified"
      machine=$DOCKER_MACHINE_NAME
      if [ -z "$machine" ]; then
         echo "Did not find any default machine, exiting..."
	 return
      fi
      echo "Will stop default machine"
   fi

   echo "Stopping machine $machine"
   docker-machine stop $machine
}


function dmstart() {
   machine=$1
   if [ -z "$machine" ]; then
      echo "No docker machine specified, please try again..."
      dmls
      return
   fi

   echo "Starting machine $machine ..."
   docker-machine start $machine
}


alias dma='dmactive'

# Initialize the Windows Docker Toolbox environment
#   - autmatically detects the running docker machine
function dminit() {
   machine=$1
   if [ -z "$machine" ]; then
        echo "No docker machine specified, looking for a machine currently running..."
   	eval machine="$(docker-machine ls --filter state=Running | grep Running |  cut -f 1 -d ' ')"
	if [ -f "$machine" ]; then
	    echo "No docker machine is currently running"
	    echo "You may "
	    echo "   dmcreate      : create a new docker machine"
	    echo "   dmstart       : start an existing docker maxchine"
	    return
	 fi
	 echo "Found machine $machine"
   fi

   echo "Initializing env for machine $machine ... "
   cmd="docker-machine env $machine"
   eval "$($cmd)" # Note that there is a double $ because we want to execute the command

   if [ $machine != $DOCKER_MACHINE_NAME ]; then
      echo "Machine $machine does not exists"
      echo "Please run dmls to list existing machines, exiting ..."
      return
   fi

   eval DOCKER_HOST_IP="$(echo $DOCKER_HOST | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')"
   export DOCKER_HOST_IP
   echo "Docker environnement initialized with machine: $machine"
}

function dmreset() {
   machine=$1
   if [ -z "$machine" ]; then
        echo "No docker machine specified, looking for a machine currently running..."
   	eval machine="$(docker-machine ls --filter state=Running | grep Running |  cut -f 1 -d ' ')"
	if [ -z "$machine" ]; then
	    echo "No docker machine is currently running"
	    echo "You may "
	    echo "   dmcreate      : create a new docker machine"
	    echo "   dmstart       : start an existing docker maxchine"
	    return
	 fi
	 echo "Found machine $machine"
   fi

   echo "Regenerating certs for machine $machine ... "
   docker-machine regenerate-certs -f $machine


   echo "Initializing docker env..."
   dminit $machine
}


function dmenv() {
	echo "DOCKER_MACHINE_NAME : $DOCKER_MACHINE_NAME"
	echo "DOCKER_HOST_IP      : $DOCKER_HOST_IP"
	echo "DOCKER_HOST         : $DOCKER_HOST"
}

function dmip() {
   machine=$1
   if [ -z "$machine" ]; then
   	eval machine="$(docker-machine active 2>/dev/null)"
   fi
   docker-machine ip $machine
}

alias dmhost='dmip'

#
#
# DOCKER CONTAINERS COMMANDS
#
#

function my-d() {
   echo "dattach             : attach to latest run container"
   echo "dcont [number]      : selects container number from container list (dcls)"
   echo "dls, dps            : docker ps"
   echo "dlsa, dpsa          : docker ps -a"
   echo "dlast               : docker ps -l"
   echo "dlogs               : displays logs of latests container"
   echo "dopen [port]        : opens a browser for current machine with specified port, defaults to 8080"
   echo "dopens [port]       : idem dmopen on https"
   echo "drm                 : interactively remove containers"
   echo "drmlast             : removes latest launched container"
   echo "drmall              : removes all containers"
   echo "drun                : launches a new container"
}

function dopen() {
   port=$1
   if [ -z "$port" ]; then
       echo "No port specified, using 8080..."
       port="8080"
   fi

   echo "start http://$DOCKER_HOST_IP:$port"
   start "http://$DOCKER_HOST_IP:$port"
}

function dopens() {
   port=$1
   if [ -z "$port" ]; then
       echo "No port specified, using 8080..."
       port="8080"
   fi

   echo "start https://$DOCKER_HOST_IP:$port"
   start "https://$DOCKER_HOST_IP:$port"
}

alias dps='docker ps'
alias dls='dps'

alias dpsa='docker ps -a'
alias dlsa='dpsa' 

alias dlast='docker ps -l'

function drmlast() {
   eval container="$(docker ps -l -q)"
   if [ -z "$container" ] 
   then
      echo "No running container, exiting..."
      return
   fi

   echo "Removing last container $container ..."
   docker rm -f $container
}

function dlogs() {
   eval container="$(docker ps -l -q)"
   if [ -z "$container" ] 
   then
      echo "No running container, exiting..."
      return
   fi

   docker logs -f $container
}

function dattach() {
   eval container="$(docker ps -l -q)"
   if [ -z "$container" ]
   then
      echo "No running container, exiting..."
      return
   fi

   echo "Attaching container $container..."
   docker attach $container
}

function drmall() {
   echo "Removing all containers..."
   for f in $(docker ps -a -q 2>/dev/null) 
   do
      #TODO introduce question Y/no/continue for each removal
      docker rm -f $f
   done
}

function drm() {
    while true
    do
       echo "Listing containers..."
       docker ps
       echo ""
       read -p "Remove which container ? [id|(q)]: " answer

       if [ -z "$answer" ] || [ "$answer" == "q" ]
       then
          echo "Exiting..."
	  return
       fi

       echo "Removing container $answer"
       docker rm -f $answer
   done
}

function drun() {

   image=$DOCKER_IMAGE_ID
   if [ -z "$image" ]
   then
      echo "No active image, please select an image with dimg [number]"
      dils
      return
      image=$DOCKER_IMAGE_ID
      if [ -z "$image" ]; then
         echo "No default image, exiting..."
	 return
      fi

      echo "Using default image $image"
   fi

   echo "docker run $DOCKER_IMAGE_NAME $cmd " 
   read -p "command ?   [command|(default)]: " answer
   cmd=$answer
   
   echo "docker run $DOCKER_IMAGE_NAME $cmd " 
   read -p "detach or interactive ? [d/(i)]: " answer
   if [ "$answer" == "d" ]
   then
      mode="-d"
   else
      mode="-it"
   fi

   read -p "expose ports ? HOST:CONTAINER : " answer
   if [ -z "$answer" ] 
   then 
      ports=""
   else
      #TODO Check port numbers are integers
      ports="-p $answer"
   fi

   read -p "docker run $mode $ports $DOCKER_IMAGE_NAME $cmd ? [(y)|n] : " answer
   if [ "$answer" == "n" ]
   then
      echo "Cancelled, exiting..."
      return
   fi
   
   echo "Launching..."
   if [ "$mode" == "-it" ] 
   then
      start docker run -it --rm $ports $DOCKER_IMAGE_NAME $cmd
   else
      container=$(docker run $mode $ports $DOCKER_IMAGE_NAME $cmd)
   fi 
}


#
#
# DOCKER IMAGES COMMANDS
#
#

function my-di() {
   echo "dibuild [name]      : create image from DockerFile"
   echo "dils                : docker images"
   echo "dimg [number]       : activate image from images list, show active image if no args"
   echo "dipull <image>      : docker pull image"
   echo "dirm                : removes currently active image"
}

alias dils='docker images'

function dipull() {
   image=$1
   if [ -z "$image" ]
   then
   	echo "No image name specified, exiting..."
   fi

   echo "Pulling image $image ..."
   docker pull $image
}

function dibuild() {
   image=$1
   if [ -z "$image" ]
   then
   	echo "No image name specified, exiting..."
	return
   fi

   docker build -t $image .
}

function dimg() {
   num="$1"
  
   # If no number is specified, show current image
   if [ -z "$num" ]; then
   
      if [ -z "$DOCKER_IMAGE" ]; then
         echo "No image selected"
         echo "Choose one and run dimg [image-number], exemple dimg 2"
	 dils
         return
      fi

      echo "Current image is $DOCKER_IMAGE"
      return
   fi

   # Resetting currently selected image 
   # From now, no image is selected
   export DOCKER_IMAGE_NAME=
   export DOCKER_IMAGE_ID=
   export DOCKER_IMAGE=

   # Check number is numeric and >0
   regexp='^[0-9]+$'
   if ! [[ $num =~ $re ]] ; then
      echo "Not a number"
      echo "No image selected, exiting..." 
      return
   fi
   if [ $num -le  0 ]; then 
      echo "Image number must be >0"
      echo "No image selected, exiting..." 
      return
   fi

   # Select specified image number
   plusun=$((num+1))
   image=$(docker images 2>/dev/null | head -n $plusun | tail -n 1 | awk -F' ' '{ print $1,$2,$3 }')

   # Check an image has been found
   if [ -z "$image" ]; then
      echo "No image found with number $num"
      return
   fi

   # Retreive data from selected image
   IFS=" "
   set $image
   image_repo="$1"
   image_tag="$2"
   image_id="$3"

   export DOCKER_IMAGE_NAME="$image_repo:$image_tag"
   export DOCKER_IMAGE_ID="$image_id"
   export DOCKER_IMAGE="$DOCKER_IMAGE_NAME-$DOCKER_IMAGE_ID"
   echo "Selected image $DOCKER_IMAGE"
}

function dirm() {
   image=$DOCKER_IMAGE_ID
   if [ -z "$image" ]; then 
      
      echo "No active image, first choose an image via dimg [number]"
      dils
      return
   fi

   read -p "Delete image $image ? [y|(n)] : " answer
   if [ "$answer" != "y" ]; then
      echo "Canceled, exiting..."
      return
   fi

   docker rmi $image

   export DOCKER_IMAGE_NAME=
   export DOCKER_IMAGE_ID=
   export DOCKER_IMAGE=
}


# Containerized ROS Visualization and Development environment 

This repository builds an Ubuntu environment for developing and visualizing Robot Operating System (ROS) worlds. 
## DockerHub
https://hub.docker.com/repository/docker/grendel61/ros-visualization/general

## Grendel61/ros-visualization:latest
* Ubuntu 18.04 with Desktop
* VNC/No-VNC on Ports: 5901/6901
* XFCE Window Manager
* ROS Melodic-Desktop-Full:
  * ROS Melodic: tutorials cmake, ros-built-toools, ros-melodic catkin, etc. 
  * RQT
  * RVIZ
  * Robot Generic Libraries
  * 2D/3D simulaters and perception
* ROS Gazebo 9 - Robot Model Development and Simulation
* ROS MoveIt - Robot Motion Planning and Simulation
* Tensorflow GPU

## Startup & Install ROS-Visualization
- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:latest 

- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:latest bash

- If you want to connect to tensorboard, run command with mapping to local port `6006`:
      
      docker run -it -p 5901:5901 -p 6901:6901 -p 6006:6006 grendel61/ros-visualization:latest 
### Favorite Startup
Simply mount the Desktop `home/ros/Desktop/src` to an existing directory. This will put any new generated directories or files outside the container where they can be edited with an IDE:
```
      docker run -it --rm -p 5901:5901 -p 6901:6901 \
      -e VNC_PW=vncpassword \
      -v /Users/edfullman/Github/citadel-elrond/src:/home/ros/Desktop/src \
      grendel61/ros-visualization:latest 
```

## Advanced Docker Run settings

### Using root (user id `0`)
Add the `--user` flag to your docker run command:
```
    docker run -it --user root -p 5901:5901 grendel61/ros-visualization:latest 
```
### Using user and group id of host system
Add the `--user` flag to your docker run command (Note: uid and gui of host system may not able to map with container, which is 1000:1000. If that is the case, check with 3):
```
    docker run -it -p 5901:5901 --user $(id -u):$(id -g) grendel61/ros-visualization:latest 
```
### Override VNC and Container environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1920x1080`
* `VNC_PW`, default: `vncpassword`
* `USER`, default: `ros`
* `PASSWD`, default: `ros`

### Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=vncpassword grendel61/ros-visualization:latest 
```
### Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 grendel61/ros-visualization:latest 
```
### Mount a local directory to the container
You can settings to the run to connect a local directory which will receive new files created with the container. This will let you edit generated files with your IDE. Map your group/user to the container retrieve R/W permission to the mounted directory of mounting directory in container (Note: after running this command, the user account in container will be same as host account):
```
      docker run -it -p 5901:5901 \
        --user $(id -u):$(id -g) \
        --volume /etc/passwd:/etc/passwd \
        --volume /etc/group:/etc/group \
        --volume /etc/shadow:/etc/shadow \
        --volume /home/ros/Desktop:/home/ros/Desktop:rw \
        grendel61/ros-visualization:latest
```

### Connecting jupyter notebook within container
- Run command with mapping to local port `8888` (jupyter protocol) and `8888` (host web access):
```
      docker run -d -p 8888:8888 grendel61/ros-visualization:latest 
```
- Check your local IP within container using `` $ifconfig``, then you can start up jupyter notebook in container with following command: 
```
      jupyter notebook --ip={YOUR CONTAINER IP} --port=8888 --allow-root
```
- After start up the jupyter kernel, you can access the notebook from host browser through HTTP service.
```
      http://localhost:8888/
```
## Display Connections & Controls
You can connect to the Ubuntu desktop and run applications like RVIZ, Gazebo, etc. in multiple ways:
* Connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* Connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* Connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 
* Connect to __Tensorboard__ if you do the tensorboard mapping above: [`http://localhost:6006`](http://localhost:6006)
* The default username and password in container is ros:ros

## Using Gazebo
Gazebo is a 3D dynamic simulator with the ability to accurately and efficiently simulate populations of robots in complex indoor and outdoor environments. While similar to game engines, Gazebo offers physics simulation at a much higher degree of fidelity, a suite of sensors, and interfaces for both users and programs.
- Start the ros-visualization container with a `docker run` (see above)
- Start a terminal window from within the Container. 
- Enter on the command line `gazebo`
- Follow the [Gazebo tutorials](http://gazebosim.org/tutorials?cat=get_started) 
## Using MoveIt
MoveIt is an easy-to-use robotics manipulation platform for developing applications, evaluating designs, and building integrated products
- Start the ros-visualization container with a `docker run` (see above)
- Start a terminal window from within the Container. 
- Enter on the command line `roslaunch panda_moveit_config demo.launch rviz_tutorial:=true`
- Follow the [MoveIt tutorials](https://ros-planning.github.io/moveit_tutorials/)
## Developing with Ros-Visualization
Ros-Visualization was designed to provide a method for avoiding the install process for Gazebo and MoveIt, and allow you to run these applications directly from the container. The ability to attach a local volume (see above) also makes this solution viable for a development platform. 

Example:
1) Create a GitHub repository on your GitHub account. 
2) Clone to your local machine. 
3) In a terminal window (e.g. see example below on VSCode) run Ros-Visualization with a detached volume (e.g. -v) 

```
      docker run -it --rm -p 5901:5901 -p 6901:6901 \
      -e VNC_PW=vncpassword \
      -v /Users/edfullman/Github/citadel-elrond/src:/home/ros/Desktop/src \
      grendel61/ros-visualization:latest 
```
The end of the run should look like this:

4) Simply attach a shell to the running container, In this way you can build your Catkin directories for ROS as above so that they will survive exiting the container, and can be under source control. 

## Contributors
* [ConSol/docker-headless-vnc-container](https://github.com/ConSol/docker-headless-vnc-container) - developed the ConSol/docker-headless-vnc-container
* [Docker-Ros-VNC](https://github.com/henry2423/docker-ros-vnc) - provided the very complex VNC integration to Ubuntu, and the basic approach for ROS

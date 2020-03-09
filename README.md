# Containerized ROS Visualization and Development environment 

This repository builds an Ubuntu environment for developing and visualizing Robot Operating System (ROS) worlds. 

## Current Build:
`Grendel61/ros-visualization:mdgt`: 

[![](https://images.microbadger.com/badges/version/grendel61/ros-visualization:mdgt.svg)](https://microbadger.com/images/grendel61/ros-visualization:mdgt "Get your own version badge on microbadger.com")

(mgdt: Melodic-Desktop Gazebo Tensorflow)
* __Ubuntu 18.04
* VNC/No-VNC on Ports: 5901/6901
* XFCE Window Manager
* ROS Melodic Desktop Full:
      * ROS Melodic: tutorials cmake, ros-built-toools, ros-melodic catkin, etc. 
      * RQT
      * RVIZ
      * Robot Generic Libraries
      * 2D/3D simulaters and perception
* ROS Gazebo 9
* Tensorflow GPU

[![](https://images.microbadger.com/badges/image/grendel61/ros-visualization:mdgt.svg)](https://microbadger.com/images/grendel61/ros-visualization:mdgt "Get your own image badge on microbadger.com")

## Usage
- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:mdgt

- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 grendel61/ros-visualization:mdgt bash

- If you want to connect to tensorboard, run command with mapping to local port `6006`:
      
      docker run -it -p 5901:5901 -p 6901:6901 -p 6006:6006 grendel61/ros-visualization:mdgt

- Build an image from scratch:

      docker build -t grendel61/ros-visualization:mdgt .

## Connect & Control
If the container runs up, you can connect to the container throught the following 
* connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `vncpassword` 
* connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 
* connect to __Tensorboard__ if you do the tensorboard mapping above: [`http://localhost:6006`](http://localhost:6006)
* The default username and password in container is ros:ros

## Detail Environment setting

#### 1.1) Using root (user id `0`)
Add the `--user` flag to your docker run command:
```
    docker run -it --user root -p 5901:5901 grendel61/ros-visualization:mdgt
```
#### 1.2) Using user and group id of host system
Add the `--user` flag to your docker run command (Note: uid and gui of host system may not able to map with container, which is 1000:1000. If that is the case, check with 3):
```
    docker run -it -p 5901:5901 --user $(id -u):$(id -g) grendel61/ros-visualization:mdgt
```
### 2) Override VNC and Container environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1920x1080`
* `VNC_PW`, default: `vncpassword`
* `USER`, default: `ros`
* `PASSWD`, default: `ros`

#### 2.1) Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=vncpassword grendel61/ros-visualization:mdgt
```
#### 2.2) Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:
```
    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 grendel61/ros-visualization:mdgt
```
### 3) Mounting local directory to container
You should run with following environment variable in order to mapping host user/group with container, and retrieve R/W permission of mounting directory in container (Note: after running this command, the user account in container will be same as host account):
```
      docker run -it -p 5901:5901 \
        --user $(id -u):$(id -g) \
        --volume /etc/passwd:/etc/passwd \
        --volume /etc/group:/etc/group \
        --volume /etc/shadow:/etc/shadow \
        --volume /home/ros/Desktop:/home/ros/Desktop:rw \
        grendel61/ros-visualization:mdgt
```
You can simply mount the Desktop `home/ros/Desktop/src` to an existing. This will put any new generated directories or files outside the container where they can be edited with an IDE:
```
      docker run -it --rm -p 5901:5901 -p 6901:6901 \
      -e VNC_PW=vncpassword \
      -v /Users/edfullman/Github/citadel-elrond/src:/home/ros/Desktop/src \
      grendel61/ros-visualization:mdgt
```
### 4) Connecting jupyter notebook within container
- Run command with mapping to local port `8888` (jupyter protocol) and `8888` (host web access):
```
      docker run -d -p 8888:8888 grendel61/ros-visualization:mdgt
```
- Check your local IP within container using `` $ifconfig``, then you can start up jupyter notebook in container with following command: 
```
      jupyter notebook --ip={YOUR CONTAINER IP} --port=8888 --allow-root
```
- After start up the jupyter kernel, you can access the notebook from host browser through HTTP service.
```
      http://localhost:8888/
```
## Contributors

* [ConSol/docker-headless-vnc-container](https://github.com/ConSol/docker-headless-vnc-container) - developed the ConSol/docker-headless-vnc-container
* [Docker-Ros-VNC](https://github.com/henry2423/docker-ros-vnc)

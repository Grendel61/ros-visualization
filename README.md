# Containerized ROS Visualization and Development environment 

ROS Visualization is a Docker that delivers a variety of capabilities to help developers build ROS applications and simulations. The container is built on a base of Ubuntu with VNC/No-VNC built-in. The other layers install ROS and build up to simulations like Gazebo and MoveIt. 

## DockerHub
https://hub.docker.com/repository/docker/grendel61/ros-visualization/general

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/grendel61/ros-visualization/latest) 
![MicroBadger Layers](https://img.shields.io/microbadger/layers/grendel61/ros-visualization)

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
  * Python 3 64-bit
* ROS Gazebo 9 - Robot Model Development and Simulation
* ROS MoveIt - Robot Motion Planning and Simulation
* Tensorflow GPU

## User Documentation
See the ROS Visualization [Wiki](https://github.com/apexsupplychain/ros-visualization/wiki) for more information. 

## Contributors
* [ConSol/docker-headless-vnc-container](https://github.com/ConSol/docker-headless-vnc-container) - developed the ConSol/docker-headless-vnc-container
* [Docker-Ros-VNC](https://github.com/henry2423/docker-ros-vnc) - provided the very complex VNC integration to Ubuntu, and the basic approach for ROS

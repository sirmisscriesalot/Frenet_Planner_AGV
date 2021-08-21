# Running ROS and Gazebo on an Ubuntu Desktop via Docker

This Dockerfile will install ROS Melodic with Gazebo 9 on Ubuntu 18.04, and give you a VNC interface to work within that environment. The container is tested and working on Windows 10 and Mac OS X. If you need ROS Kinetic with Turtlebot simulations, be sure to check out [the `kinetic` branch](https://github.com/jbnunn/ROSGazeboDesktop/tree/kinetic).

To install:
go inside folder containing Dockerfile
    $ docker build -t ros-gazebo-desktop .
    
## Start and Connect to The Container

Work you do in the container's `~/data` directory will be saved to your local `data` directory. On your host, create a `data` directory:

    mkdir data

Now when launching the container, we'll use the `-v` flag to mount `data` inside the container at `/home/ubuntu/data`.

### Windows

    docker run -it --rm --name=ros_gazebo_desktop -m=4g -p 6080:80 -p 5900:5900 -v %cd%/data:/home/ubuntu/data -e RESOLUTION=1920x1080 -e USER=ubuntu -e PASSWORD=ubuntu ros-gazebo-desktop 

### OS X / Linux:

    docker run -it --rm --name=ros_gazebo_desktop -m=4g -p 6080:80 -p 5900:5900 -v $PWD/data:/home/ubuntu/data -e RESOLUTION=1920x1080 -e USER=ubuntu -e PASSWORD=ubuntu ros-gazebo-desktop   

We also expose port 5900 so you can connect with a VNC client, and/or port 6080 so you can connect via your browser using NoVNC. You can change the `RESOLUTION` to match screen dimensions appropriate for your display, and the `USER` environment variable to change the user that logs into the desktop. In most cases, you'll want to leave this as the `ubuntu` user (password `ubuntu`). 

Once the `docker run` command finishes running, connect to the container using a VNC client or via http://locahost:6080/. From the Ubuntu desktop, open a termina, build the package inside /home/ubuntu/workspaces and then run as usual.


 Don't forget that your work will not be saved unless you are working from the `/home/ubuntu/data` folder (or other folder(s) you mount with the `-v` flag.)

## Troubleshooting

### Gazebo is slow or processes hang

This is likely a memory issue. Launch your container with more RAM, 4GB for example, with the `-m=4g` flag. Your default Docker installation might be set to something lower, see [here to change those settings](https://stackoverflow.com/questions/44533319/how-to-assign-more-memory-to-docker-container).

## Credits

Based on the following work:

* Docker file for ROS + Gazebo setup: [https://github.com/bpinaya/robond-docker](https://github.com/bpinaya/robond-docker)
* LXDE Desktop: [https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)

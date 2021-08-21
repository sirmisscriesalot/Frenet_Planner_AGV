# networked_frenet_automation

Repository for agv Networked frenet Automation project

## Getting Started

The project is based on Ubuntu 20.04, ROS2 Foxy, gazebo 11.0. Links to the instructions for installing ROS2, Gazebo, etc. are provided below

- [Install ROS2](https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html)
- [Install gazebo 11.0](http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=11.0)

## Installation

- Clone the repo inside ~/<frenet_ws>/src/

## Common Instructions to Run

- Source the ROS environment script

  ```
  source /opt/ros/foxy/setup.bash
  ```

- Install Dependencies

  ```
    cd ~/frenet_ws
  rosdep install --from-paths src --ignore-src -y -r
  ```

- Build

  ```
  colcon build
  ```

- Source the setup file
  ```
  . install/setup.bash
  ```
- Open frenet world in gazebo, opens world file set in wareohuse_gazebo/config/world_params.yaml
  ```
  ros2 launch frenet_gazebo frenet.launch.py
  ```

## To open frenet world in gazebo

- opens world file set in wareohuse_gazebo/config/world_params.yaml
	```
	ros2 launch frenet_gazebo frenet.launch.py
	```

- Enabling Entity State
  
  Gazebo model states are not advertised by default in ROS2 + Gazebo. We need to add gazebo_ros_state plugin to the world file. Upon launching you should see additional ROS2 services under namespace /cornet. This services are used for synchronizing when using network simulator.  
  	
  ```
  ros2 service list | grep entity
  ```

## To run Task Allocation

In separate terminals, run the following commands

- Task generator node
  ```
  ros2 launch frenet_task_allocator task_launch.py
  ```
- Task allocator node
  ```
  ros2 launch frenet_task_allocator task_allocator_launch.py
  ```
- Dummy robot nodes
  ```
  ros2 launch frenet_task_allocator robots_launch.py
  ```
- Robot_nodes (different from dummy robot nodes as these also handle the task being allocated to the robot)
  ```
  ros2 launch frenet_task_allocator robot_node_launch.py
  ```
- Dummy order service client
  ```
  ros2 service call /orders frenet_interfaces/srv/OrderService {}
  ```
	
## Instructions to bringup the docker environment(ROS 2 foxy with gazebo-11)

- Tested on docker version 20.10.7
- Requires docker compose v1.28.0 or higher


**Install the following packages if you have a dedicated nvidia graphics card**

-  Add the GPG key:
	
	```
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   	&& curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-	key add - \
   	&& curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   	```
  
- Install the nvidia-docker2 package 
  
  	```
  	sudo apt-get update
  	```
  	
  	```
  	sudo apt-get install -y nvidia-docker2
  	```
   
- Restart the Docker daemon
     
   	```
   	sudo systemctl restart docker
   	``` 
**Instructions to build the image and run the container**

- Place the Dockerfile, the docker-compose.yml file  and the docker-compose_gpu.yml file inside ~/your_workspace/. **NOTE:** Your entire src/ folder will be mounted as a volume in the container.

- To build the image:

	```
	./bringup_foxy_devel.sh build
	```
	
	NOTE:  This step might be time consuming.

- To run the container:
	```
	cd  ~/your_workspace/
	```

	```
	 ./bringup_foxy_devel.sh run
	 ```
	 
	 Wait for the bash script to execute. In another terminal 
	 
	 ```
	 docker-compose exec frenet_sim /bin/bash
	 ```
	 
## Instructions to create simulated network environment.
- Clone the following project in home directory (need not be part of ROS dir)
	git clone https://github.com/rbccps-iisc/CORNET2.0.git

- To install library files, follow the README instructions in the CORNET2.0 repo.


- launch the Gazebo simulation   
- launch the Gazebo simulation   
- The CORNET2.0 project repository has two sections. 
- "network" section 
  - creates virtual network and spawns dockers for each robot entity with initial positions form gazebo environment
	```
 	python network/test/network_config.py test.yaml
	```
  - This will start a session with containernet instance, enabling some basic commands like xterm, ping, iwconfig, distance etc..  
  - Eg: to start terminals for each docker 
	```
    xterm mybot1 mybot2
 	```
  - Inside each robot's container entity for enabling exclusive robot to robot communication we need to source a file
	to disable the multicast and initialize a peer list of robots IPs.
	```
 	source /home/setENV.sh  	
 	```
	 
- "robot" section 
  - syncs mobility across the framework 
	```
 	python network/test/gz_robot_position.py test.yaml
	```
 	**NOTE:** The robot container(provided in Dockerfile.focalfoxyNWH) has to be built before using cornet. build script provided in the docker_container folder will do the job.

## Steps followed for creating a static map using the slam toolbox

- Install the required packages:
	```
	sudo apt install ros-foxy-slam-toolbox
	```
	
	```
	sudo apt install ros-foxy-turtlebot3-teleop
	```

-   Bringup the frenet environment with a single turtlebot. ( For the purpose of creating the static map, the robot wasn't given any namespace)

 - Run the slam toolbox in synchronous mode:
 
	 ```
	ros2 launch slam_toolbox online_sync_launch.py
	```

-  Bringup the teleoperation node 

	```
	ros2 run turtlebot3_teleop teleop_keyboard
	```
	
- View the map using RVIZ. Use the Slam toolbox RVIZ plugin/ exposed service calls to save the built map.

## Adding actors in the gazebo world
- From the root directory (~/<frenet_ws>) run the following:
	```
	sh src/networked_frenet_automation/frenet_object_spawn/frenet_object_spawn/add_actors.sh -n 5
	```
- Launch the world file using ``` ros2 launch frenet_gazebo frenet.launch.py ``` command
- After execution please run the clean up file to restore the gazebo world file to defaults
  ```
  sh src/networked_frenet_automation/frenet_object_spawn/frenet_object_spawn/delete_actors.sh
	```
- NOTE: ALL THE COMMANDS FOR ADDING ACTORS IN THE GAZEBO WORLD MUST BE RUN FROM THE ROOT DIRECTORY

## Instructions to create simulated network environment.
- Open two terminals. Then enter workspace and source the setup file in both the terminals
	```
	cd ~/frenet_ws
	. install/setup.bash
	```
- Open frenet world in gazebo, opens world file set in wareohuse_gazebo/config/world_params.yaml	
	```
	# Run this in Termial 1
	ros2 launch frenet_object_spawn multi_robot_spawn.launch.py
	```
- Launch Nav2
	- Launch NAV2 for all the bots together
	```
	# Run this in Termial 2 after the terminal 1 output is stabalised i.e. gazebo world is fully launched
	ros2 launch frenet_navigation frenet_multiple_nav2.launch.py
	```
	OR
	- Launch NAV2 for Robot 0
	```
	# Run this in Termial 2
	ros2 launch frenet_navigation frenet_nav2.launch.xml \
	use_sim_time:=true \ 
    params_file:=/home/drago/networked_frenet_automation/src/networked_frenet_automation/frenet_navigation/config/robot0_namespace.yaml \ 
	use_namespace:=true \
	namespace:=robot0
	```
	- Launch NAV2 for Robot 1
	```
	# Run this in Termial 3
	ros2 launch frenet_navigation frenet_nav2.launch.xml \
	use_sim_time:=true \ 
    params_file:=/home/drago/networked_frenet_automation/src/networked_frenet_automation/frenet_navigation/config/robot1_namespace.yaml \ 
	use_namespace:=true \
	namespace:=robot1
	```
- To send initial pose through terminals and not RVIZ
	```
	# Run this in a new terminal after all the instances of NAV2 have been completely launched
	ros2 run frenet_navigation initialpose
	```
- To send goals through terminals and not RVIZ
	```
    # Run this in a new terminal. You might have to rerun this command depending on whether the navigation stack received it or not. This will be fixed in future PRs
	ros2 topic pub -1 /robot<robot_id>/goal_pose geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0}, frame_id: 'map'}, pose: {position: {x: 3,y: 9.5, z: 0.0}, orientation: {w: 1.0}}}"
	```

## Acknowledgements

- [AWS Robotics](https://github.com/aws-robotics/aws-robomaker-small-frenet-world)

## DOCUMENTATION

- [Sensor_fusion](https://drive.google.com/file/d/16wvkc_muDiQ8p2saD6U0r3i4AtBjJzsU/view?usp=sharing)

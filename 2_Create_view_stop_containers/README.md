# Exercise 2: Creating, viewing and stopping containers

## Create a container

Up until this point, you have only created a Docker image. You haven't actually run the desired application in its container form. To create a container from the custom built nginx image we made in [workshop 1](../1_Create_view_pull_images), run the following command:

`docker run -d -p 8081:80 --name webserver mynginx`

The `-d` flag tells Docker to run the container in the background and print the container Id. `-p` flag tells Docker that we will be exposing ports. The arguments supplied to `-p` tells Docker that we want to map the host port 8081 to the container port 80. If you wanted to use another port say if 8081 was being used by abother application, you would simply change the host port. (NOTE: We are only able to expose port 80 from within the container because we declared this behaviour in our Dockerfile with the command `EXPOSE 80`). The `--name` flag allows us to assign a name to our container as opposed to the random name and Id docker generates and we finally end with the image name to create the container from `mynginx`.

The running nginx application will now be available at:

`localhost:8081`

## View containers

Although we know what our webserver container should now be running, it's always nice to see what state our containers are in especially when we have multiple containers running over extended periods of time. To see the state of all your containers, run the following command:

`docker ps`

This command shows you all running containers running on your machine. The container Id shows the truncated to 12 character form of the unique Id associated with the container. You can refer to your container either using this Id or the name which you gave it at runtime. It is easier to refer to a name than a random string so its always a good idea to name your containers! This command also shows you the image the container was created from, the command run when creating the container, the time of creation, the ports mappings and finally the status of the container.

## Stop containers

To safely stop our custom nginx container, you can run the following command:

`docker stop mynginx`

If you run the `docker ps` command, you will notice that we no longer see any information about our container. Remember that the default behaviour for this command is to show *running* containers (NOTE: You could also use the unique Id as a reference to the container). To see all containers on your machine run:

`docker ps -a`

You should now see that the container is in the view but is now in the `Exited` state.

## Start containers

To start our nginx container again, you can run the following command:

`docker start mynginx`

As before the application will be available at `localhost:8081`.

Congratulations, you now know how to create a container from a Docker image, start and stop containers and to monitor the state of all your containers! Continue on to the [next exercise](../3_Working_inside_containers) to learn how to start working inside containers.

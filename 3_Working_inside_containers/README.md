# Exercise 3: Working inside containers

Now that you know how to run your own containers, we can start playing aroud with some real world applications and do some meaningful work. Let's say we wanted to run a simple TODO list application which runs on a MySQL backend. Let's start of by pulling the mysql image from DockerHub:

`docker pull mysql/mysql-server`

Depending on the internet speed, it should take no more than a couple of mintues to pull the image (300MB). When you have the image, run it with the following command:

`docker run --name=mysql -e MYSQL_ROOT_PASSWORD=password -d mysql/mysql-server:latest`

As before, `-d` tells Docker to run the container in the background in detached mode and the `--name` flag allows us to label our container with a name we can use to reference it rather than using the random container Id. Finally we set the environment variable `MYSQL_ROOT_PASSWORD` to initialise the database with. (NOTE: You definately shouldn't pass password as env variables but this is just a workshop so we'll turn a blind eye to this).

## View container logs

As we are working with a stateful application, there is a slightly longer start up time for all the various start up processes. We can check the container logs to see if MySQL is ready:

`docker logs mysql`

The docker logs command is generally useful for debugging containers without the need to enter the containers to access their logs. If your container fails to start or becomes unhealthy, this is usually the first command you should run to see what is going on (NOTE: If the last few lines contains the output 'ready for connections' your database will have been succefully initialised!).

## Copy files into a container

So we have successfully created a MySQL database but we now want to get some data inside it. Within this workshop there is a sample schema that will create our todo list application's database. Make sure you have a local copy of the `todo.sql` schema file (If you have cloned the repository, just change into the directory for this lab). Copy the sql file into the container with the following command:

`docker cp ./todo.sql mysql:/tmp`

This will copy the SQL file to the /tmp directory within the container. 

## Make changes in a container

Now we can go back into the container:

`docker exec -it mysql bash`

Now that we are inside the container, we can load the schema into mysql:

`mysql -u root -p < /tmp/todo.sql`

You will be prompted for the password again. Now you will have loaded the schema and sample data into the database. To see the data we can go back into mysql:

`mysql -u root -p`

To see the databases we have available, run the command:

`show databases;`

Now we can specify that we want to use the `todo` database:

`use todo`

List the tables that are available with the following command:

`show tables;`

Let's see what we have in the `list` table:

`select * from list;`

Let's see what list items we have in the `work` list:

`select * from list_items where list_id=2;`

Since you now know how to create a Docker image from a Dockerfile and you know how to run a Docker container, lets update the `complete` status for items 8 and 9 in the list:

`update list_items set complete='Y' where id=8 or id=9;`

If we now look at the state of the list_items in the `work` list we can see that list_items 8 and 9 are now marked as complete. To exit MySQL and the container, type the command `exit` twice (The first time should responde with "Bye" and the second with "exit").

Congratulations! You now know how to start an interactive shell within a running container, copy data inside a container and make changes inside a container. Continue on to the next exercise to learn how to persist data with containers.   

# Exercise 3: Working inside containers

Now that you know how to run your own containers, we can start playing aroud with some real world applications and do some meaningful work. Let's say we wanted to run a simple TODO list application which runs on a MySQL backend. Let's start of by pulling the mysql image from DockerHub:

`docker pull mysql/mysql-server`

Depending on the internet speed, it should take no more than a couple of mintues to pull the image (300MB). When you have the image, run it with the following command:

`docker run --name mysql -d mysql/mysql-server`

As before, `-d` tells Docker to run the container in the background in detached mode and the `--name` flag allows us to label our container with a name we can use to reference it rather than using the random container Id.

## View container logs

When you create a MySQL database, you are usually prompted to create a password. As we are running this within a Docker container, by the time the container is running this has already been configured. To see the password that was randomly assigned to the container, run the command:

`docker logs mysql`

The docker logs command is generally useful for debugging containers without the need to enter the containers to access their logs. If your container fails to start or becomes unhealthy, this is usually the first command you should run to see what is going on (NOTE: the line you are looking for will be of the format: `[Entrypoint] GENERATED ROOT PASSWORD: <TOKEN>`. As the database may take some time to initialise and it spits out quite a bit of information, you can run the following command which will specifically look for this line in the logs: `docker logs mysql 2>&1 | grep GENERATED`).

## Enter a container

Now that you have the token, you will use this to login to your MySQL instance with the following command:

`docker exec -it mysql mysql -u root -p`

You will then be prompted to enter the root password at which you can copy and paste the generated password from the previous command.

The `exec` command allows us to execute commands inside a running container. The `-it` flags allows us to create an interactive session within the container. The second `mysql` in the command tells it to run the executable MySQL. Finally, we specify the user as root with the `-u` flag and tell docker to prompt for the password by specifying the `-p` flag without arguments (Note that these are arguments to the command `mysql` and not to Docker!).

As we have used a one-time only password to use MySQL, we need to change the password. We can do this with the following command (Make sure you run this inside MySQL - if the shell prompt starts with `mysql>` then you are successfully logged into the MySQL instance in the container):

`ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';`

Make sure you replace 'newpassword' with the password you wish to use (It may be a good idea to copy this to a clipboard as you will need this in later steps).

## Work inside a container

So we have successfully created a MySQL database but we now want to get some data inside it. Within this workshop there is a sample schema that will create our todo list application's database. First exit out of the container by running `exit`.

Now get a local copy of the `todo.sql` within this workshop (If you have cloned the repository, just change into the directory for this lab).

### Copy data into a container

We can now copy the sql file into the container with the following command:

### Make changes inside a container

`docker cp ./todo.sql mysql:/tmp`

This will copy the SQL file to the /tmp directory within the container. Now we can go back into the container:

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

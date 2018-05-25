# Exercise 4: Working with persistence and commits

In the last exercise, we learnt how to update our MySQL database. This is great as we didn't have to worry about setting up MySQL however, if our container were to go down, we would lose all the changes we made. The data lost would have been trivial as we made minor changes but with real applications, this would be unacceptable. Let's list the steps we took to setup our MySQL container:

1. Run the container from the image
2. Copy the schema into /tmp directory in the container
3. Login to MySQL within the container
4. Load the schema into MySQL
5. Make our changes

Looking at the steps in the list, as a developer, we're really only interested in making changes to the database. Steps 2-4 are boring configuration steps that could be automated. Wouldn't it be great if our Docker image allowed us to skip these steps? Well good news... it can!

## Commit a new image

To create a snapshot from our container, we need to get it at a good starting point for re-use. As we have already loaded the schema into MySQL and made are changes, we are all set to commit changes from our running MySQL container:

`docker commit mysql your-username/mysql-server`

Make sure you replace `your-username` with a username that identfies you. If we now look through our docker images, we will see we have 2 mysql-server images:

`docker images | grep mysql-server`

Now we have an image that will contain a configured MySQL database with the credentials we setup in [exercise 3](https://github.com/mofsal/containers101/tree/master/3_Working_inside_containers), our schema in the containers /tmp directory and our schema loaded into MySQL with the updates we made to the `work` list items. Although it is unlikely we want to worry about setting up the database password, it would be nice to allow our database to work with different datasets. If we had several teams using this image, it would be great to use the same image and decouple the data from the application... Good news, we can!

## Mount a directory into a container

As developers, we want to have the flexibility to use different datasets - not just `todo.sql`. We would also like for the database files to be decoupled from the container. If the container was to die before we could run a commit, we would still lose changes we made after starting the container. Assuming the username you created was `bob`, start your custom `mysql-server` with two mounts:

`docker run --name=mysql-persist -d -v /tmp/mysql:/var/lib/mysql -v /tmp/schema:/tmp/schema bob/mysql-server`

We have now created a new container from our custom image of MySQL. This container is called `mysql-persist` and mounts `/tmp/mysql` from the host to the data directory for MySQL within the container. We also have an additional mount point at `/tmp/schema` to load in any other schema files to populate the database with.

## Re-apply the database changes

Let's see if we have our database changes in this new image:

`docker exec -it mysql-persist mysql -u root -p`

As we committed the MySQL image after we had initialised the database with the environment variable, the password should still be `password`.

`show databases;`

Uh-oh! The todo database isn't there!

As containers are ephemeral, we will not have the data in the data directory saved from the first container as this is exposed as a volume by default in Docker and is decoupled from the container (See the [Dockerfile](https://github.com/docker-library/mysql/blob/fc3e856313423dc2d6a8d74cfd6b678582090fc7/8.0/Dockerfile#L65)). We will need to run the schema as before:

`exit`
`docker exec -it mysql-persist bash`
`mysql -u root -p < /tmp/todo.sql`

As we committed the MySQL image after we had initialised the database with the environment variable, the password should still be `password`. Now we can log into the MySQL instance:

`mysql -u root -p`

We then tell MySQL to use the todo database as before:

`use todo;`

We can check the state of our work list items which had an id of 2 in the list table:

`select * from list_items where list_id=2;`

Let's update the same items again:

`update list_items set complete='Y' where id=8 or id=9;`

We can now exit out of the MySQL and the container by running the command `exit` twice. It may seem like we haven't done anything however, the changes we made to our database now exist outside our container at `/tmp/mysql`. If we start another container using the same mount point, we will be able to see the data in the database with our latest changes.

## Test the persistence change

Let's stop and remove all containers so we can be confident that we can start from a clean Docker environment and still use persisted data:

`docker stop $(docker ps -aq)`

This command stops all containers on the Docker host. The nested Docker command lists all the container on the host by Id. We can then remove all the containers:

`docker rm -v $(docker ps -aq)`

The `-v` flag ensures that the volumes associated with the containers will be removed also. Now we can run the same command is before to run the containers along with the volumes:

`docker run --name=mysql-persist -d -v /tmp/mysql:/var/lib/mysql -v /tmp/schema:/tmp/schema bob/mysql-server`

NOTE: As before, remember to change the username `bob` for your username. We can then login to MySQL:

`docker exec -it mysql-persist mysql -u root -p`

As before, we supply the password `password`. Let's list the databases to see if our todo database is present:

`show databases;`

With some luck, todo should be there! We didn't have to run our schema. Let's now verify that our changes to the database have persisted:

`use todo;`

`select * from list_items where list_id=2;`

You should see that for ids 8 and 9, we have `Y` in the complete column.

Congratulations! You now know how to mount volumes into a container to persist data and commit changes from a container to create a new image. Continue on to the [next exercise](https://github.com/mofsal/containers101/tree/master/5_Working_with_container_registry) to learn how to use the IBM container service.


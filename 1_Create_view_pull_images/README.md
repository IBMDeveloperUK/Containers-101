# Creating, pulling and running Docker images

## Create a Dockerfile

Create a file called `Dockerfile` with the following contents:

```
FROM ubuntu
LABEL maintainer="Bob Smith (Bob.Smith@gmail.ibm.com)"
RUN apt-get update
RUN apt-get install -y nginx
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
```

Our starting point is from an ubuntu image. From there we add several layers to install and configure the latest version of nginx with `RUN`. `CMD` allows us to specify the default command when the container is started. In this case, this will run the nginx executable. Finally, we specify that we want to `EXPOSE` port 80 so that our nginx application can be accessed outside the container. Remember to change the `LABEL` line to use your own name and Email.

## Build your image

To create an image from your Dockerfile run the following command:

`docker build -t mynginx:latest [PATH_TO_DOCKERFILE]`

The `-t` flag allows us to specify the image name followed by the image tag. By default, the image tag is always 'latest'

## Inspect image history

To see the layers within the image you have just created run the following command:

`docker history mynginx`

Notice that the layers which are from the ubuntu image will have a time stamp longer than the layers explicitly defined in your Dockerfile.

## View your local images

To see the images you have installed on your machine run the following command:

`docker images`

## Pulling images

You now know how to create a Docker image using a Dockerfile, but with exception of custom built software, you usually want to run images that you don't maintain. To pull ubuntu from the public docker regisrty on DockerHub, run the following command:

`docker pull ubuntu`

As our custom built image for nginx was running on ubuntu, the docker engine will not actually pull any layers from DockerHub but will use the same layer it pulled when running the `mynginx` image. If you want to be double sure, you can run `docker history ubuntu` and you should see all the same commands and layer sizes as the base layers for `mynginx`.

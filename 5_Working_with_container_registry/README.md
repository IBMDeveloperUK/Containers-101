# Working with IBM Cloud Container Registy

So we have created our amazing database, we now want to push it to our private registry. In real agile development, a push to a private registry would trigger a build to run a test suite in a CI/CD pipeline. For this we will be using IBM Container Registry. If you have not created an IBM Cloud account or have not installed the IBM Cloud CLI, [click here](../../../) to follow the steps do so.

First we will need to create a unique namespace for the registry:

`bx cr namespace-add <my_namespace>`

It will be a good idea to use the same `username` you used when created our custom MySQL image. If this username is taken, just use a value that is unique.

Next, we need to log the local Docker daemon into the IBM Cloud Container Registry:

`bx cr login`

Now we are ready to push our image from our local machine up to the IBM Cloud Container Registry. Before we do so, we will need to tag the image appropriately:

`docker tag <username>/mysql-server registry.eu-gb.bluemix.net/<my_namespace>/mysql-server`

* The `<username>` field is the same one we used when creating our custom MySQL image.
* The `<my_namespace>` field is the unique identifier we created in the `bx cr namespace-add` command.
* As we have not specified a tag for the image, it will tag as `latest` by default.

Now we can push our newly tagged custom MySQL image to Cloud Registry:

`docker push registry.eu-gb.bluemix.net/<my_namespace>/mysql-server`

If you can see the layers of the image being pushed up then you are successfully pushing to IBM Container Registry. Let's go see what you just deployed:

1. Login to [IBM Cloud](https://console.bluemix.net)
2. Open the side menu at the top left of the screen
3. Navigate to `Containers`
4. Click on `Private Repositories` in the menu
5. Click on the MySQL image we just pushed in the main screen

One of the nice things about Container Registry is that it will scan the image for vulnerabilites everytime an image is pushed to the registry or is updated. Let's click on the link under the `Policy Status` column for a summary of the security report. In addition to vulnerability scans, Container Registry shows us configuration issues that we should fix to better secure the container.

Congratulations, you have completed the Containers 101 workshop!

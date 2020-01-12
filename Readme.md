### Docker first web app

This assumes you have already setup Docker using the initial steps mentioned here: [Setup](https://github.com/gsacode/docker-getting-started-console#docker-setup)


Please navigate to the folder in file explorer where you cloned this project. Open the docker-getting-started-web folder and open the `DockerHelloWorldWeb.sln`.

Open a command prompt or git bash inside the directory where you cloned the project. Type the following command:

```bash
cd docker-getting-started-web
docker build -t dockerhelloworldweb .
```
The second line `docker build -t dockerhelloworldweb .` that you ran should create a new image with name:tag `dockerhelloworldweb:latest`

To understand how a docker image was created let's try to understand the contents of the docker file.

```bash
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base

WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["DockerHelloWorldWeb/DockerHelloWorldWeb.csproj", "DockerHelloWorldWeb/"]
COPY ["DockerHelloWorldWeb/NuGet.Config", "DockerHelloWorldWeb/"]
RUN dotnet restore "DockerHelloWorldWeb/DockerHelloWorldWeb.csproj"
COPY . .
WORKDIR "/src/DockerHelloWorldWeb"
RUN dotnet build "DockerHelloWorldWeb.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerHelloWorldWeb.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerHelloWorldWeb.dll"]
```
The first line downloads the docker image mcr.microsoft.com/dotnet/core/runtime:2.1 from docker registry. This is an image maintained by Microsoft and has the most upto date runtime for running apps in .Net Core 2.1. We give the image an alias base.

Lines 7-9 expose port 80 & 443 outside of the container.

On lines 11-18 we pull a new docker image specifically for building code. This is based on microsoft/dotnet:2.1-sdk which contains the dotnet cli for building dotnet core version 2.1 code. To keep the base image size lower we don't pull dotnet sdk in the base image which only contains the runtime.

On lines 20-21 we create a new image publish on the previous image build where we copy the artificats of building our code.

On lines 23-26 we create an image called final from the base image where we copy the contents from the publish image.

The reason to create so many images is to utilize the caching feature of docker. Any images that have not changed will be used from cache when you run the docker build command next time.

Run the following command to run the image we created in a docker container
```bash
docker run -it --rm -d -p 8080:80 -p 8081:443 --name dhw1 dockerhelloworldweb
```
The `docker run` command starts a container using the image `dockerhelloworldweb` that we created earlier. The -p command maps port from your laptop to the docker container's port. The `--name` flag assings the name `dhw1` to the container. The `-d` flag prints the name of the container. `--rm` will delete the container once its stopped. `-it` starts a interactive terminal with the container.

Open the following URL: http://localhost:8080/api/values to test if it works.

To check whats being printed on the console run the following command.
```bash
docker logs --follow dhwc1
```

To start one more container with the same image use the following command:
```bash
docker run -it --rm -d -p 8090:80 -p 8091:443 --name dhw2 dockerhelloworldweb
```
To stop a container run the following command:
```bash
docker stop dhw1
docker stop dhw2
```
This will stop the container as well as delete it since we ran the container with the rm flag.
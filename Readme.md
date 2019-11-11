# github-actions

Github Actions Build & Deployment Pipelines Sample Repo

## [Github Actions -> Workflows Testing Repo](./github-actions/.github/workflows/)

Github Actions uses YAML file to configure pipelines. I created new .net core 2.2 -> MVC project and try to build with new Github Actions.

## How to create new .Net Core MVC project by command line which project uses .Net Core 2.2.

Open powershell,bash or cmd shell console then change path to your repo folder, in example ( C:\repos)

<pre> cd C:\repos </pre>

then type dotnet new command...

<pre> dotnet new mvc --name 'YourProjectName' -f netcoreapp2.2 </pre>

this will create a new mvc project under the your repo folder. 

## Restore, Build and Run the new project 

You can restore dependency packages the following command.
<pre> dotnet restore </pre>
You can build the project the following command.
<pre> dotnet build </pre>
You can run the project the following command.
<pre> dotnet run </pre>

## Github Actions Configuration

* Create a folder named <code>.github</code> on the root path
* Create a folder named workflows inside of the <code>.github</code> folder
* Create a file named <code>dotnetcore.yml</code>

Type following commands on the your <code>dotnetcore.yml</code> file.

<pre>
# Name of the Workflow 
name: .NET Core

# This will be trigger on when the new incoming "Push"
on: [push]

jobs:
  build:

# Build this project on ubuntu machine
    runs-on: ubuntu-latest

# Steps of the build
    steps:

# Use actions/checkout@v1 plugin/ module    
    - uses: actions/checkout@v1

# Create a new folder as named artifacts on server root folder
    - run: mkdir -p artifacts/

# Create new operation as named  'Setup .NET CORE' and Install the .Net Core 2.2.108 on the ubuntu server
    - name: Setup .NET Core
      uses: actions/setup-dotnet@v1
      with:
        dotnet-version: 2.2.108

# Create new operation to build
    - name: Build with dotnet
      run: dotnet build --configuration Release

# Create new operation to publish app
    - name: Publish with dotnet
      run: dotnet publish --self-contained -c Release -o artifacts/output -r "linux-x64"

# Create new operation to publish the artifact 
    - uses: actions/upload-artifact@master
      with:
        name: my-artifact
        path: artifacts/
</pre>

## Dockerizing the local project

Create two new files one of named as <code>Dockerfile</code> and other file is named to <code>.dockerignore</code> ( File names are case sensitive )

Docker uses YAML file to configuration. Type the following commands on the new Dockerfile.

<pre>
# Take .net core 2.2 sdk as the base image
FROM microsoft/dotnet:2.2-sdk as build
WORKDIR /app

# Copy all .csproj files to container then restore NuGet packages.
COPY *.csproj ./
RUN dotnet restore

# Copy all files to container then take publish, compatible for 64 bit linux OS
COPY . ./
RUN dotnet publish -c Release -o output -r "linux-x64"

# Take .net core 2.2 aspnet runtime as the base image
FROM microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /app

# Copy all files from build from app folder to app root folder.
COPY --from=build /app/output .

# Place the Entrypoint of app dotnet github-actions.dll. This command will be triggered on we run the container.
ENTRYPOINT [ "dotnet", "github-actions.dll" ]
</pre>

Build the docker image with the following command.
<pre>docker build -t github-actions.dll . </pre>

## Github Actions Continous Deployment on Docker

We have build and published the package artifact.Next step is artifact download and deploy on the docker.

##### To be continued...
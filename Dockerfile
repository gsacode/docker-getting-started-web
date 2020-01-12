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
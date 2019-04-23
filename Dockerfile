FROM microsoft/dotnet:latest as base
WORKDIR /app
EXPOSE 80-443


FROM microsoft/dotnet:latest AS build
COPY ./aspnet.zip /src/
WORKDIR /src
RUN apt-get update
RUN apt-get install unzip -y
RUN unzip ./aspnet.zip 
WORKDIR /src/aspnet
RUN dotnet restore aspnet.csproj
RUN dotnet build aspnet.csproj -c Release -o /app


FROM build as publish
RUN dotnet publish aspnet.csproj -c Release -o /app


FROM  base as final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet","aspnet.dll"]


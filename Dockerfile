# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY src/Review.sln ./
WORKDIR /source/Review.Web

COPY src/Review.Web/Review.Web.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY src/Review.Web/ ./
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Review.Web.dll"]

EXPOSE 80
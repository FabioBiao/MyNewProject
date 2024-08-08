# Use the official .NET image as the base build environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the csproj file and restore dependencies
COPY ["src/MyNewProject.csproj", "./"]
RUN dotnet restore "./MyNewProject.csproj"

# Copy the entire source code and build the project
COPY ./src .
WORKDIR "/src"
RUN dotnet build "MyNewProject.csproj" -c Release -o /app/build

# Publish the app
RUN dotnet publish "MyNewProject.csproj" -c Release -o /app/publish

# Final stage: Set up the runtime environment
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyNewProject.dll"]

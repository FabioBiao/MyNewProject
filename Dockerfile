# Use the official .NET image as the build environment
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the csproj and restore as distinct layers
COPY ["MyNewProject.generated.csproj", "./"]
RUN dotnet restore "./MyNewProject.generated.csproj"

# Copy the remaining source code and build the project
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyNewProject.generated.csproj" -c Release -o /app/build

# Publish the app
RUN dotnet publish "MyNewProject.generated.csproj" -c Release -o /app/publish

# Final stage: Set up the runtime environment
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyNewProject.generated.dll"]
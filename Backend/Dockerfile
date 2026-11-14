# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy project files
COPY ["TaskManagementAPI/TaskManagementAPI.csproj", "TaskManagementAPI/"]
COPY ["DataAccessLayer/DataAccessLayer.csproj", "DataAccessLayer/"]

# Restore NuGet dependencies
RUN dotnet restore "TaskManagementAPI/TaskManagementAPI.csproj"

# Copy the remaining source code
COPY . .

# Publish the API
WORKDIR /src/TaskManagementAPI
RUN dotnet publish "TaskManagementAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "TaskManagementAPI.dll"]

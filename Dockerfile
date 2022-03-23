#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443
#
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /src
#COPY ["TestingTerraform.csproj", "TestingTerraform/"]
#RUN dotnet restore "TestingTerraform/TestingTerraform.csproj"
#COPY . .
#WORKDIR "/src/TestingTerraform"
#RUN dotnet build "TestingTerraform.csproj" -c Release -o /app/build
#
#FROM build AS publish
#RUN dotnet publish "TestingTerraform.csproj" -c Release -o /app/publish
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "TestingTerraform.dll"]



# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
EXPOSE 80
#EXPOSE 3000
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "TestingTerraform.dll"]
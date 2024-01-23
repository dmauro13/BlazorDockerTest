#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["BlazorDockerTest.csproj", "."]
RUN dotnet restore "./././BlazorDockerTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./BlazorDockerTest.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./BlazorDockerTest.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazorDockerTest.dll"]

# Aggiungi alla fine del Dockerfile
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Configura il token di accesso per GitHub Container Registry
ARG OKEN
RUN echo "registry=https://docker.pkg.github.com/" > ~/.docker/config.json
RUN echo "{\"auths\":{\"docker.pkg.github.com\":{\"dmauro13\":\"dmauro13\",\"X!X8SKE2a\":\"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\",\"email\":\"your-email@example.com\",\"auth\":\"\"}}}" > ~/.docker/config.json

# Tag e push dell'immagine a GitHub Container Registry
ARG USERNAME
ARG REPO_NAME
ARG TAG
RUN docker tag BlazorDockerTest docker.pkg.github.com/dmauro13/BlazorDockerTest/BlazorDockerTest:BlazorDockerTest
RUN docker push docker.pkg.github.com/dmauro13/BlazorDockerTest/BlazorDockerTest:BlazorDockerTest

ENTRYPOINT ["dotnet", "BlazorDockerTest.dll"]



# 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


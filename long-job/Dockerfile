FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["long-job/long-job.csproj", "long-job/"]
RUN dotnet restore "long-job/long-job.csproj"
COPY . .
WORKDIR "/src/long-job"
RUN dotnet build "long-job.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "long-job.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "long-job.dll"]

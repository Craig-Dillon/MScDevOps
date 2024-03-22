# Stage 1: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:5600
EXPOSE 5600
WORKDIR app
COPY ./bp/publish/myapp/ .
ENTRYPOINT ["dotnet", "BPCalculator.dll"]

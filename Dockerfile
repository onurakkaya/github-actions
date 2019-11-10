FROM microsoft/dotnet:2.2-sdk as build
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o output -r "linux-x64"

FROM microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /app

COPY --from=build /app/output .

ENTRYPOINT [ "dotnet", "github-actions.dll" ]
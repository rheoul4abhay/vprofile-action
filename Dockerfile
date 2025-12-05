FROM eclipse-temurin:11-jdk AS build-image
WORKDIR /src
RUN apt-get update && apt-get install -y --no-install-recommends maven && rm -rf /var/lib/apt/lists/*
COPY ./ /src
RUN mvn -B -DskipTests clean package

FROM tomcat:9.0-jre11-temurin
LABEL org.opencontainers.image.title="Vprofile"
LABEL org.opencontainers.image.authors="Imran"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build-image /src/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
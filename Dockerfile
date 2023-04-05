FROM ubuntu as extractor
WORKDIR /extractor
RUN apt-get update && apt-get install -y unzip git wget
ENV CLOUDNET_VERSION=4.0.0-RC8
RUN wget https://github.com/CloudNetService/CloudNet-v3/releases/download/$CLOUDNET_VERSION/CloudNet.zip -O /tmp/CloudNet.zip
RUN unzip /tmp/CloudNet.zip
FROM azul/zulu-openjdk:20-latest
ENV CLOUDNET_LAUNCHER_JAR=/var/lib/cloudnet/launcher.jar
WORKDIR /cloudnet
COPY --from=extractor /extractor/launcher.jar "$CLOUDNET_LAUNCHER_JAR"

CMD java -Xms256m -Xmx256m -XX:+UseZGC -XX:+PerfDisableSharedMem -XX:+DisableExplicitGC -jar $CLOUDNET_LAUNCHER_JAR

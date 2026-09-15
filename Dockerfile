# 第一阶段：构建后端可执行文件
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build
COPY app-backend/pom.xml ./pom.xml
COPY app-backend/src ./src
RUN mvn --batch-mode --no-transfer-progress clean package -DskipTests

# 第二阶段：运行后端服务
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=70.0 -XX:+UseSerialGC -Duser.timezone=Asia/Shanghai"
COPY --from=builder /build/target/app-backend-0.0.1-SNAPSHOT.jar app.jar
RUN mkdir -p /app/uploads
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

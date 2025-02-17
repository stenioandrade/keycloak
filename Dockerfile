FROM stenioandrade/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build
ARG http-enabled=false
ARG https-port=8444

FROM stenioandrade/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://sanctuary.cluster-cuger1cqzal8.us-east-1.rds.amazonaws.com:5432/Thane
ENV KC_DB_SCHEMA=keycloak
ENV KC_DB_USERNAME=dev
ENV KC_DB_PASSWORD=naPistaDev
ENV KEYCLOAK_ADMIN=naPista
ENV KEYCLOAK_ADMIN_PASSWORD=naPista2023
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
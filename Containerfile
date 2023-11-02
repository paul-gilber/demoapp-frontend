ARG BUILD_IMAGE="registry.access.redhat.com/ubi8/nodejs-18"
ARG RUNTIME_IMAGE="registry.access.redhat.com/ubi8/nodejs-18"

# Build
FROM ${BUILD_IMAGE} as build
WORKDIR /build

COPY package.json ./package.json
COPY public ./public
COPY src ./src

RUN npm install \
    && npm run build


# APP
FROM ${RUNTIME_IMAGE}
WORKDIR /app

# Set default demoapp-backend url
ENV DEMOAPP_BACKEND_URL "http://demoapp-backend:8080"

COPY --from=build --chown=default:default /build/build ./build

RUN npm install -g serve
CMD serve -n -s /app/build -l tcp://0.0.0.0:8080

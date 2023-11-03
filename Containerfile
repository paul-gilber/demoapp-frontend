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

COPY --from=build --chown=default:default /build/build /app/build
# .env file is copied during runtime and will be appended to env-config.js
COPY --chown=1001:0 --chmod=644 .env /app/.env
# env.sh is used for generating env-config.js, env.sh will override .env entries when they are defined in the environment variables
COPY --chown=1001:0 --chmod=755 env.sh /app/env.sh

RUN npm install -g serve
CMD /app/env.sh build && serve -n -s /app/build -l tcp://0.0.0.0:8080

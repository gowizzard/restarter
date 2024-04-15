# Dockerfile for the Shopware 6 Idealo Feed Backend application.
# This file details the process for constructing a lightweight and efficient Docker image using a multi-stage build process.
# The chosen base is Alpine Linux for its minimalistic size, while still providing necessary functionalities.

########################################################################################################################

# This phase uses the Alpine-based Go image to compile the source code of the application.
# By parameterizing the Go version, it becomes straightforward to maintain and modify in the future.
ARG GO_VERSION=1.22
FROM golang:${GO_VERSION}-alpine AS build
RUN apk add --no-cache git make
WORKDIR /tmp/src
COPY . .
RUN make build

########################################################################################################################

# The final preparation phase for the production-ready image. Essential system packages are added,
# a dedicated user for the application is created (enhancing security by avoiding root privileges),
# and the correct timezone is set.
FROM alpine:latest AS production
ENV TZ=Europe/Berlin
WORKDIR /app
COPY --from=build /tmp/src/restarter .
EXPOSE 3000
CMD ["/app/restarter"]
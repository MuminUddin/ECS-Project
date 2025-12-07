# Stage 1: Build stage

FROM golang:1.25-alpine AS build

WORKDIR /app/gatus

COPY . .

RUN go build -o gatus .


# Stage 2: Production stage

FROM golang:1.25-alpine

WORKDIR /app/gatus

COPY --from=build /app/gatus/gatus /app/gatus

RUN mkdir -p /app/gatus/config

COPY --from=build /app/gatus/config.yaml /app/gatus/config/config.yaml

RUN addgroup -S gatus && adduser -S -G nobody gatus

RUN chown -R nobody:gatus /app/gatus

USER nobody

EXPOSE 8080

CMD [ "./gatus" ]
## build stage  ##
FROM golang:1.22.5 as build

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o go-app .


## run stage  ##
FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=build /app/go-app .

COPY --from=build /app/static ./static

EXPOSE 8000

CMD [ "./go-app" ]
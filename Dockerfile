FROM golang:1.17.1 as build
ADD . /src
WORKDIR /src
RUN CGO_ENABLED=0 go build -o webapp
RUN chmod +x webapp

FROM scratch
EXPOSE 8080
CMD ["webapp"]
COPY --from=build /src/webapp /usr/local/bin/webapp

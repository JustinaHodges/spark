FROM rust:1.86-bookworm AS builder

RUN apt-get update && apt-get install -y \
    protobuf-compiler libclang-dev cmake git \
    && rm -rf /var/lib/apt/lists/*

RUN rustup target add wasm32-unknown-unknown

WORKDIR /build
COPY . .

RUN cargo build --release -p frontier-template-node

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/release/frontier-template-node /usr/local/bin/spark-node
EXPOSE 9944 9933 30333
ENTRYPOINT ["spark-node"]

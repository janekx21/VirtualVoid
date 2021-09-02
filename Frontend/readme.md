# generate client service and model via protoc
```shell
protoc --proto_path=../Protos ../Protos/model.proto --grpc-web_out=import_style=typescript,mode=grpcwebtext:src/generated


protoc --proto_path=../Protos ../Protos/model.proto --js_out=import_style=commonjs,binary:src/generated --grpc-web_out=import_style=typescript,mode=grpcweb:src/generated

protoc --proto_path=../Protos ../Protos/model.proto --plugin=protoc-gen-ts=./node_modules/.bin/protoc-gen-ts --js_out=import_style=commonjs,binary:src/generated --ts_out=service=grpc-web:=src/generated
```

root_dir := $(abspath ./)
src_dir := $(abspath ./SquareNumber/)

docker:
	docker build -t swift-lambda-builder .

SquareNumber/Package.swift:
	mkdir -p SquareNumber
	cd SquareNumber
	docker run --rm --volume "$(src_dir):/src" --workdir "/src/" swift-lambda-builder swift package init --type executable

dev_docker:
	docker run \
      --rm \
      --volume "$(src_dir):/src" \
      --workdir "/src/" \
      -e LOCAL_LAMBDA_SERVER_ENABLED=true \
      -p 7000:7000 \
      swift-lambda-builder \
      swift run

dev:
	rm -rf "$(src_dir)/.build"
	export LOCAL_LAMBDA_SERVER_ENABLED=true
	cd SquareNumber && /Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift run

dev_test_1:
	curl --header "Content-Type: application/json" \
      --request POST \
      --data '{"number": 3}' \
      http://localhost:7000/invoke

build:
	docker run \
      --rm \
      --volume "$(src_dir):/src" \
      --workdir "/src/" \
      swift-lambda-builder \
      swift build --product SquareNumber -c release

zip:
	docker run \
      --rm \
      --volume "$(src_dir)/:/src" \
      --workdir "/src/" \
      swift-lambda-builder \
      ./scripts/package.sh SquareNumber
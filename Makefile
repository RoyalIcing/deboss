root_dir := $(abspath ./)
src_dir := $(abspath ./SquareNumber/)

docker:
	docker build -t swift-lambda-builder .

SquareNumber/Package.swift:
	mkdir -p SquareNumber
	cd SquareNumber
	docker run --rm --volume "$(src_dir):/src" --workdir "/src/" swift-lambda-builder swift package init --type executable

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
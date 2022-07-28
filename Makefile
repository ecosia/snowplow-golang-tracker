.PHONY: all format lint tidy test goveralls clean

# -----------------------------------------------------------------------------
#  CONSTANTS
# -----------------------------------------------------------------------------

src_dir       = tracker
build_dir     = build

coverage_dir  = $(build_dir)/coverage
coverage_out  = $(coverage_dir)/coverage.out
coverage_html = $(coverage_dir)/coverage.html

# -----------------------------------------------------------------------------
#  BUILDING
# -----------------------------------------------------------------------------

all:
	CGO_ENABLED=0 GO111MODULE=on go build ./$(src_dir)

# -----------------------------------------------------------------------------
#  FORMATTING
# -----------------------------------------------------------------------------

format:
	CGO_ENABLED=0 GO111MODULE=on go fmt ./$(src_dir)
	CGO_ENABLED=0 GO111MODULE=on gofmt -s -w ./$(src_dir)

lint:
	CGO_ENABLED=0 GO111MODULE=on go get -u golang.org/x/lint/golint
	CGO_ENABLED=0 GO111MODULE=on golint ./$(src_dir)

tidy:
	CGO_ENABLED=0 GO111MODULE=on go mod tidy

# -----------------------------------------------------------------------------
#  TESTING
# -----------------------------------------------------------------------------

test:
	mkdir -p $(coverage_dir)
	CGO_ENABLED=0 GO111MODULE=on go test ./$(src_dir) -tags test -v -covermode=count -coverprofile=$(coverage_out)
	CGO_ENABLED=0 GO111MODULE=on go tool cover -html=$(coverage_out) -o $(coverage_html)

goveralls: test
	CGO_ENABLED=0 GO111MODULE=on go get -u github.com/mattn/goveralls
	CGO_ENABLED=0 GO111MODULE=on goveralls -coverprofile=$(coverage_out) -service=github

# -----------------------------------------------------------------------------
#  CLEANUP
# -----------------------------------------------------------------------------

clean:
	rm -rf $(build_dir)

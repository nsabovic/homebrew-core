class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.0.0.tar.gz"
  sha256 "5e0258437538bdfa26ca0e023649d97baa138d91881b949b2b344ef84cc2082a"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e739583a67354478a9f950375763d41080698e74aeee0d0195773ac7ca383096"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0be8359b1b6052cc554f3a9b672162eed4ab6e7e20928c424c0916d110e286f"
    sha256 cellar: :any_skip_relocation, catalina:      "5a13e8a2f8e6111ceb163fd1aac8810a278f32317ebffb3563d5860a9a510db2"
    sha256 cellar: :any_skip_relocation, mojave:        "0311e7d2eb0f1c5569fd51732dd7e9e917423bcad57e651d4d8a5c468168a55a"
  end

  depends_on xcode: ["12.0", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
  end

  test do
    (testpath/"echo.proto").write <<~EOS
      syntax = "proto3";
      service Echo {
        rpc Get(EchoRequest) returns (EchoResponse) {}
        rpc Expand(EchoRequest) returns (stream EchoResponse) {}
        rpc Collect(stream EchoRequest) returns (EchoResponse) {}
        rpc Update(stream EchoRequest) returns (stream EchoResponse) {}
      }
      message EchoRequest {
        string text = 1;
      }
      message EchoResponse {
        string text = 1;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift_out=."
    assert_predicate testpath/"echo.grpc.swift", :exist?
  end
end

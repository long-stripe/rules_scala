load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

bzl_library(
    name = "scala-rules-private",
    srcs = [
        "rule_impls.bzl",
        "coverage_replacements_provider.bzl",
        "common.bzl",
        # "@bazel_tools//tools/build_defs/repo/http.bzl",
    ],
    deps = [
        "@bazel_tools//tools/jdk:toolchain_utils.bzl",
    ],
    visibility = ["//visibility:public"],
)
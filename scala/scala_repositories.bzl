load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    _default_scala_version = "default_scala_version",
    _default_scala_version_jar_shas = "default_scala_version_jar_shas",
    _extract_major_version = "extract_major_version",
    _new_scala_default_repository = "new_scala_default_repository",
)
load(
    "@io_bazel_rules_scala//scala:scala_maven_import_external.bzl",
    _scala_maven_import_external = "scala_maven_import_external",
)
def _default_scala_extra_jars():
    return {
        "2.11": {
            "scalatest": {
                "version": "3.0.5",
                "sha256": "2aafeb41257912cbba95f9d747df9ecdc7ff43f039d35014b4c2a8eb7ed9ba2f",
            },
            "scalactic": {
                "version": "3.0.5",
                "sha256": "84723064f5716f38990fe6e65468aa39700c725484efceef015771d267341cf2",
            },
            "scala_xml": {
                "version": "1.0.5",
                "sha256": "767e11f33eddcd506980f0ff213f9d553a6a21802e3be1330345f62f7ee3d50f",
            },
            "scala_parser_combinators": {
                "version": "1.0.4",
                "sha256": "0dfaafce29a9a245b0a9180ec2c1073d2bd8f0330f03a9f1f6a74d1bc83f62d6",
            },
        },
        "2.12": {
            "scalatest": {
                "version": "3.0.5",
                "sha256": "b416b5bcef6720da469a8d8a5726e457fc2d1cd5d316e1bc283aa75a2ae005e5",
            },
            "scalactic": {
                "version": "3.0.5",
                "sha256": "57e25b4fd969b1758fe042595112c874dfea99dca5cc48eebe07ac38772a0c41",
            },
            "scala_xml": {
                "version": "1.0.5",
                "sha256": "035015366f54f403d076d95f4529ce9eeaf544064dbc17c2d10e4f5908ef4256",
            },
            "scala_parser_combinators": {
                "version": "1.0.4",
                "sha256": "282c78d064d3e8f09b3663190d9494b85e0bb7d96b0da05994fe994384d96111",
            },
        },
    }

def scala_repositories(
        scala_version_shas = (
            _default_scala_version(),
            _default_scala_version_jar_shas(),
        ),
        maven_servers = ["http://central.maven.org/maven2"],
        scala_extra_jars = _default_scala_extra_jars()):
    (scala_version, scala_version_jar_shas) = scala_version_shas
    major_version = _extract_major_version(scala_version)

    _new_scala_default_repository(
        maven_servers = maven_servers,
        scala_version = scala_version,
        scala_version_jar_shas = scala_version_jar_shas,
    )

    scala_version_extra_jars = scala_extra_jars[major_version]

    _scala_maven_import_external(
        name = "io_bazel_rules_scala_scalatest",
        artifact = "org.scalatest:scalatest_{major_version}:{extra_jar_version}".format(
            major_version = major_version,
            extra_jar_version = scala_version_extra_jars["scalatest"]["version"],
        ),
        jar_sha256 = scala_version_extra_jars["scalatest"]["sha256"],
        licenses = ["notice"],
        server_urls = maven_servers,
    )
    _scala_maven_import_external(
        name = "io_bazel_rules_scala_scalactic",
        artifact = "org.scalactic:scalactic_{major_version}:{extra_jar_version}".format(
            major_version = major_version,
            extra_jar_version = scala_version_extra_jars["scalactic"]["version"],
        ),
        jar_sha256 = scala_version_extra_jars["scalactic"]["sha256"],
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    _scala_maven_import_external(
        name = "io_bazel_rules_scala_scala_xml",
        artifact = "org.scala-lang.modules:scala-xml_{major_version}:{extra_jar_version}".format(
            major_version = major_version,
            extra_jar_version = scala_version_extra_jars["scala_xml"]["version"],
        ),
        jar_sha256 = scala_version_extra_jars["scala_xml"]["sha256"],
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    _scala_maven_import_external(
        name = "io_bazel_rules_scala_scala_parser_combinators",
        artifact =
            "org.scala-lang.modules:scala-parser-combinators_{major_version}:{extra_jar_version}".format(
                major_version = major_version,
                extra_jar_version = scala_version_extra_jars["scala_parser_combinators"]["version"],
            ),
        jar_sha256 = scala_version_extra_jars["scala_parser_combinators"]["sha256"],
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    # used by ScalacProcessor
    _scala_maven_import_external(
        name = "scalac_rules_commons_io",
        artifact = "commons-io:commons-io:2.6",
        jar_sha256 = "f877d304660ac2a142f3865badfc971dec7ed73c747c7f8d5d2f5139ca736513",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    _scala_maven_import_external(
        name = "io_bazel_rules_scala_org_jacoco_org_jacoco_core",
        artifact = "org.jacoco:org.jacoco.core:0.7.5.201505241946",
        jar_sha256 = "ecf1ad8192926438d0748bfcc3f09bebc7387d2a4184bb3a171a26084677e808",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    _scala_maven_import_external(
        name = "io_bazel_rules_scala_org_ow2_asm_asm_debug_all",
        artifact = "org.ow2.asm:asm-debug-all:5.0.1",
        jar_sha256 = "4734de5b515a454b0096db6971fb068e5f70e6f10bbee2b3bd2fdfe5d978ed57",
        licenses = ["notice"],
        server_urls = maven_servers,
    )

    # Using this and not the bazel regular one due to issue when classpath is too long
    # until https://github.com/bazelbuild/bazel/issues/6955 is resolved
    if native.existing_rule("java_stub_template") == None:
      http_archive(
                name = "java_stub_template",
                sha256 = "1859a37dccaee8c56b98869bf1f22f6f5b909606aff74ddcfd59e9757a038dd5",
                urls = ["https://github.com/bazelbuild/rules_scala/archive/8b8271e3ee5709e1340b19790d0b396a0ff3dd0f.tar.gz"],
                strip_prefix = "rules_scala-8b8271e3ee5709e1340b19790d0b396a0ff3dd0f/java_stub_template",
      )

    native.bind(
        name = "io_bazel_rules_scala/dependency/com_google_protobuf/protobuf_java",
        actual = "@com_google_protobuf//:protobuf_java",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/commons_io/commons_io",
        actual = "@scalac_rules_commons_io//jar",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scalatest/scalatest",
        actual = "@io_bazel_rules_scala//scala/scalatest:scalatest",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scala/scala_compiler",
        actual = "@io_bazel_rules_scala_scala_compiler",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scala/scala_library",
        actual = "@io_bazel_rules_scala_scala_library",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scala/scala_reflect",
        actual = "@io_bazel_rules_scala_scala_reflect",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scala/scala_xml",
        actual = "@io_bazel_rules_scala_scala_xml",
    )

    native.bind(
        name = "io_bazel_rules_scala/dependency/scala/parser_combinators",
        actual = "@io_bazel_rules_scala_scala_parser_combinators",
    )

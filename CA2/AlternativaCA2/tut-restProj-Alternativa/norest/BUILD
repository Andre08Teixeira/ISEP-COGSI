load("@rules_jvm_external//:defs.bzl", "artifact")
load("@rules_java//java:defs.bzl", "java_binary")


package(default_visibility = ["//visibility:public"])

java_library(
    name = "norest",
    srcs = glob(["src/main/java/com/payroll/*.java"]),
    deps = [
        artifact("org.slf4j:slf4j-api"),
        

        artifact("org.springframework.boot:spring-boot"),
        artifact("org.springframework.boot:spring-boot-autoconfigure"),

        artifact("org.springframework:spring-context"),
        artifact("org.springframework:spring-web"),
        artifact("org.springframework.data:spring-data-jpa"),
        artifact("jakarta.persistence:jakarta.persistence-api:3.0.0"),
        artifact("org.springframework.boot:spring-boot-starter-data-jpa"),
        artifact("ch.qos.logback:logback-classic"),
        artifact("ch.qos.logback:logback-core"),
        artifact("com.h2database:h2:2.1.214"), 
        artifact("org.springframework.boot:spring-boot-starter-web"),
        artifact("org.springframework.boot:spring-boot-test"),
        artifact("org.springframework.boot:spring-boot-test-autoconfigure"),
        artifact("org.springframework.boot:spring-boot-starter-test"),
        




    ],
    javacopts = [
        "-source", "17",
        "-target", "17",
    ],
)

java_binary(
    name = "payroll_app",
    main_class = "com.payroll.PayrollApplication",
    resources = glob(["src/main/resources/**"]),
    srcs = ["src/main/java/com/payroll/PayrollApplication.java"],
    deps = [
        "@maven//:org_springframework_boot_spring_boot",
        "@maven//:org_springframework_boot_spring_boot_autoconfigure",
        ":norest",
    ],
    javacopts = [
    "-source", "17",
    "-target", "17",
],
)

java_test(
    name = "norest_tests",
    srcs = glob(["src/test/java/**/*.java"]),
    deps = [
        ":norest",
        "@maven//:org_springframework_boot_spring_boot_starter_test",
        "@maven//:junit_junit", 
        "@maven//:org_hamcrest_hamcrest",
        "@maven//:org_springframework_boot_spring_boot",
        "@maven//:org_springframework_spring_context",
        "@maven//:io_rest_assured_rest_assured",


    ],
    test_class = "com.payroll.EmployeeTest",  
    use_testrunner = True,
)

#--------------------------------- SECÇÃO TESTES INTEGRAÇÃO  -----------------------------------------

java_test(
    name = "integration_test",
    srcs = glob(["src/integrationTest/java/**/*.java"]),
    deps = [
        ":norest",
        "@maven//:junit_junit", 
        "@maven//:io_rest_assured_rest_assured",
        "@maven//:org_springframework_spring_context",
        "@maven//:org_hamcrest_hamcrest",
        "@maven//:org_springframework_boot_spring_boot",
            ],
    test_class = "com.payroll.PayrollApplicationTest",
    use_testrunner = True,
)

#--------------------------------- SECÇÃO TAREFA CRIAÇÃO BACKUP -----------------------------------------


load("@rules_pkg//:pkg.bzl", "pkg_zip")

pkg_zip(
    name = "zip_src",
    srcs = glob(["src/**/*"]), 
    out = "backup/src_backup.zip",  
    visibility = ["//visibility:public"],  

)

#--------------------------------- SECÇÃO INSTALLDIST -----------------------------------------

sh_binary(
    name = "run_payroll_app_script",
    srcs = ["run_payroll_app.sh"],
)
#--------------------------------- SECÇÃO JAVADOC -----------------------------------------

load("@google_bazel_common//tools/javadoc:javadoc.bzl", "javadoc_library")


javadoc_library(
    name = "generate_javadoc",
    srcs = glob(["src/**/**/**/**/**/*.java"]),
    deps = [
        ":norest",
        "@maven//:junit_junit", 
        "@maven//:io_rest_assured_rest_assured",
        "@maven//:org_springframework_spring_context",
        "@maven//:org_hamcrest_hamcrest",
        "@maven//:org_springframework_boot_spring_boot",
        "@maven//:org_springframework_boot_spring_boot_starter_test",
    ],
    visibility = ["//visibility:public"],
)

pkg_zip(
    name = "zip_javadoc",
    srcs = [":generate_javadoc"],  
    out = "javadoc_zip.zip",
    visibility = ["//visibility:public"],
)
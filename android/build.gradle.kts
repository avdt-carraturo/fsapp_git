import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

plugins {
    // Versione UNICA del plugin Firebase / Google Services
    id("com.google.gms.google-services") version "4.3.15" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centralizza le cartelle build sotto /build
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Necessario per Flutter
    project.evaluationDependsOn(":app")
}

// Task clean globale
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

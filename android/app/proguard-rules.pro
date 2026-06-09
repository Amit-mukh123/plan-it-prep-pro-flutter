# Project-specific R8/ProGuard rules for release hardening.
# Goal: shrink + obfuscate app code while preserving required runtime behavior.

# Keep source and line mapping in obfuscated stack traces for crash analytics.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Flutter embedding entry points and generated plugin registrant are invoked by name.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep Flutter activity entry points (loaded by Android framework via manifest).
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }

# Keep custom Application subclasses if present and referenced from manifest.
-keep class * extends android.app.Application { *; }

# Keep classes and members accessed reflectively by Android/Java serialization.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep enum helper methods used reflectively.
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Kotlin metadata annotations used by some reflection-based libs.
-keep class kotlin.Metadata { *; }
-keepattributes *Annotation*,InnerClasses,EnclosingMethod,Signature

# Keep Parcelable creators required by Android framework.
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# Optional hardening: remove verbose Android logs from release builds.
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}

# Flutter embedding may reference Play Core deferred component classes even when
# the app does not ship dynamic feature modules.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

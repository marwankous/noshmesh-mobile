# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your domain models and data models if they are used with reflection (JSON serialization)
-keep class com.dorvel.clypify.features.**.data.models.** { *; }

# Marshaling/JSON optimization rules
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Ignore missing Play Store classes (used for deferred components)
-dontwarn com.google.android.play.core.**


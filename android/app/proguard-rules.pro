# Keep Joda Time classes
-keep class org.joda.time.** { *; }
-keep class org.joda.convert.** { *; }

# Keep ErrorProne annotations
-keep class javax.lang.model.element.Modifier { *; }
-keep class com.google.errorprone.annotations.** { *; }

# Keep javax annotations
-keep class javax.annotation.** { *; }

# Keep Google Crypto Tink classes
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.crypto.tink.proto.** { *; }

# Keep other missing classes
-keep class com.google.crypto.tink.aead.** { *; }
-keep class com.google.crypto.tink.KeysetManager { *; }

# Add this to prevent missing classes
-keep class org.joda.** { *; }

# Suppress warnings for missing classes
-dontwarn javax.lang.model.element.Modifier
-dontwarn org.joda.convert.FromString
-dontwarn org.joda.convert.ToString


-keep class com.google.android.** { *; }
-dontwarn com.google.android.**

# Razorpay SDK ProGuard Rules
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Recommended Rules
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn javax.annotation.**
-dontnote javax.annotation.**

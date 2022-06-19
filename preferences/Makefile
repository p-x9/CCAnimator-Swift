TARGET := iphone:clang:latest:12.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Preferences

Preferences_FILES = $(shell find Sources/Preferences -name '*.swift') $(shell find Sources/PreferencesC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Preferences_INSTALL_PATH = /Library/PreferenceBundles
Preferences_SWIFTFLAGS = -ISources/PreferencesC/include
Preferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

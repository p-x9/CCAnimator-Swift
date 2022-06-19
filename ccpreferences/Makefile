DEBUG = 1
GO_EASY_ON_ME := 1

ARCHS = arm64 arm64e
TARGET := iphone:clang:14.4:13.0
THEOS_DEVICE_IP = 192.168.0.15 -p 22

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CCPreferences

$(BUNDLE_NAME)_FILES = $(shell find Sources/CCPreferences -name '*.swift') $(shell find Sources/CCPreferencesC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')

$(BUNDLE_NAME)_FRAMEWORKS = UIKit CoreGraphics
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_SWIFTFLAGS = -ISources/CCPreferencesC/include
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

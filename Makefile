DEBUG = 1
GO_EASY_ON_ME := 1

ARCHS = arm64 arm64e
TARGET := iphone:clang:14.5:13.0
THEOS_DEVICE_IP = 192.168.0.15 -p 22

INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCAnimator

CCAnimator_FILES = $(shell find Sources/CCAnimator -name '*.swift') $(shell find Sources/CCAnimatorC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
CCAnimator_SWIFTFLAGS = -ISources/CCAnimatorC/include -I.sparkcolorheaders
CCAnimator_CFLAGS = -fobjc-arc -ISources/CCAnimatorC/include
$(TWEAK_NAME)_FRAMEWORKS = UIKit QuartzCore
$(TWEAK_NAME)_LIBRARIES = sparkcolourpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += ccapreferences
include $(THEOS_MAKE_PATH)/aggregate.mk

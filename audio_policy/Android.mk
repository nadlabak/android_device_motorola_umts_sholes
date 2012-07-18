
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),sholes)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= AudioPolicyManager.cpp
LOCAL_SHARED_LIBRARIES:= libc libcutils libutils
LOCAL_STATIC_LIBRARIES := libmedia_helper
LOCAL_WHOLE_STATIC_LIBRARIES:= libaudiopolicy_legacy
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE:= audio_policy.$(TARGET_BOOTLOADER_BOARD_NAME)
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

ifeq ($(BOARD_USES_AUDIO_LEGACY),true)

$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libaudio_intermediates/)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libaudio_intermediates/export_includes)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := audio.primary.$(TARGET_BOOTLOADER_BOARD_NAME)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := \
    libcutils \
    libutils \
    libmedia \
    libhardware
LOCAL_SHARED_LIBRARIES += libdl
LOCAL_SHARED_LIBRARIES += libaudio
LOCAL_STATIC_LIBRARIES := \
    libmedia_helper
LOCAL_WHOLE_STATIC_LIBRARIES := \
    libaudiohw_legacy
include $(BUILD_SHARED_LIBRARY)

endif # BOARD_USES_AUDIO_LEGACY
endif # build for sholes


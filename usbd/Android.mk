# Copyright 2005 The Android Open Source Project
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
        usbd.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := usbd

LOCAL_SHARED_LIBRARIES := libcutils libc

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
        usbd.c

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := usbd_static

LOCAL_STATIC_LIBRARIES := libcutils libc

include $(BUILD_EXECUTABLE) 

/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>

#include <linux/lis331dlh.h>

#include <cutils/log.h>

#include "Lis331.h"


/*****************************************************************************/

LisSensor::LisSensor()
: SensorBase(LIS_DEVICE_NAME, "accelerometer"),
      mEnabled(0),
      mInputReader(32)
{
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_A;
    mPendingEvent.type = SENSOR_TYPE_ACCELEROMETER;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));
    mPendingEvent.acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;

    struct input_absinfo absinfo;
    unsigned long flags = 0;

    open_device();

    if (!ioctl(dev_fd, LIS331DLH_IOCTL_GET_ENABLE, &flags)) {
        if(flags) {
            mEnabled = 1;
            if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_X), &absinfo)) {
                mPendingEvent.acceleration.x = absinfo.value * CONVERT_A_X;
            }
            if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_Y), &absinfo)) {
                mPendingEvent.acceleration.y = absinfo.value * CONVERT_A_Y;
            }
            if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_Z), &absinfo)) {
                mPendingEvent.acceleration.z = absinfo.value * CONVERT_A_Z;
            }
        }
    }

    if(!mEnabled) {
        close_device();
    }
}

LisSensor::~LisSensor() {
}

int LisSensor::enable(int32_t handle, int en)
{
    int err = 0;

    if (!mEnabled) {
        open_device();
    }

    int newState = en ? 1 : 0;
    unsigned long flags = newState;
    err = ioctl(dev_fd, LIS331DLH_IOCTL_SET_ENABLE, &flags);
    err = err < 0 ? -errno : 0;

    ALOGE_IF(err, "LIS331DLH_IOCTL_SET_ENABLE failed (%s)", strerror(-err));

    if (!err) {
        mEnabled = newState;
        setDelay(0, 100000000); // 100ms by default for faster re-orienting
    }
    if (!mEnabled) {
        close_device();
    }
    return err;
}

int LisSensor::setDelay(int32_t handle, int64_t ns)
{
    if (mEnabled) {
        if (ns < 0)
            return -EINVAL;

        unsigned long delay = ns / 1000000;
        if (ioctl(dev_fd, LIS331DLH_IOCTL_SET_DELAY, &delay)) {
            return -errno;
        }
    }
    return 0;
}

int LisSensor::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0)
        return n;

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        int type = event->type;
        if (type == EV_ABS) {
            processEvent(event->code, event->value);
        } else if (type == EV_SYN) {
            mPendingEvent.timestamp = timevalToNano(event->time);
            *data++ = mPendingEvent;
            count--;
            numEventReceived++;
        } else {
            ALOGE("Lis331: unknown event (type=%d, code=%d)",
                    type, event->code);
        }
        mInputReader.next();
    }

    return numEventReceived;
}

void LisSensor::processEvent(int code, int value)
{
    switch (code) {
        case EVENT_TYPE_ACCEL_X:
            mPendingEvent.acceleration.x = value * CONVERT_A_X;
            break;
        case EVENT_TYPE_ACCEL_Y:
            mPendingEvent.acceleration.y = value * CONVERT_A_Y;
            break;
        case EVENT_TYPE_ACCEL_Z:
            mPendingEvent.acceleration.z = value * CONVERT_A_Z;
            break;
    }
}

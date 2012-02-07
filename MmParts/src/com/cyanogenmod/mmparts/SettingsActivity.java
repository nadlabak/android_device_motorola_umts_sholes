package com.cyanogenmod.mmparts;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.SystemProperties;
import android.preference.CheckBoxPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.provider.Settings;

public class SettingsActivity extends PreferenceActivity implements
        OnPreferenceChangeListener {

    private static final String DOCK_OBSERVER_OFF_PREF = "pref_dock_observer_off";

    private static final String DOCK_OBSERVER_OFF_PERSIST_PROP = "persist.sys.dock_observer_off";

    private static final String DOCK_OBSERVER_OFF_DEFAULT = "0";

    private static final String BASEBAND_PREF = "pref_baseband";

    private static final String BASEBAND_PERSIST_PROP = "persist.sys.bp_nvm";

    private static final String BASEBAND_DEFAULT = "b1b8";

    private static final String KEYPAD_TYPE_PREF = "pref_keypad_type";

    private static final String KEYPAD_PREFIX_PROP = "ro.sys.keypad_prefix";

    private static final String KEYPAD_TYPE_PERSIST_PROP = "persist.sys.keypad_type";

    private static final String KEYPAD_TYPE_HW_PROP = "hw.keyboards.0.devname";

    private static final String KEYPAD_TYPE_DEFAULT = "euro_qwerty";

    private static final String KEYPAD_TYPE_SEC_PREF = "pref_keypad_type_sec";

    private static final String KEYPAD_TYPE_SEC_PERSIST_PROP = "persist.sys.keypad_type_sec";

    private static final String KEYPAD_TYPE_SEC_DEFAULT = "none";

    private static final String KEYPAD_KEYLAYOUT_PREF = "pref_keypad_keylayout";

    private static final String KEYPAD_KEYLAYOUT_PERSIST_PROP = "persist.sys.keylayout_alt";

    private static final String KEYPAD_KEYLAYOUT_DEFAULT = "";

    private static final String KEYPAD_MULTIPRESS_PREF = "pref_keypad_multipress";

    private static final String KEYPAD_MULTIPRESS_PERSIST_PROP = "persist.sys.keypad_multipress_t";

    private static final String KEYPAD_MULTIPRESS_DEFAULT = "500";

    private static final String KEYPAD_MPLANG_PREF = "pref_keypad_mplang";

    private static final String KEYPAD_MPLANG_PERSIST_PROP = "persist.sys.keypad_multipress_l";

    private static final String KEYPAD_MPLANG_DEFAULT = "auto";

    private static final String QTOUCH_NUM_PREF = "pref_qtouch_num";

    private static final String QTOUCH_NUM_PERSIST_PROP = "persist.sys.qtouch_num";

    private static final String QTOUCH_NUM_DEFAULT = "2";

    private static final String LOGGER_PREF = "pref_logger";

    private static final String LOGGER_PERSIST_PROP = "persist.service.aplogd.enable";

    private static final String LOGGER_DEFAULT = "0";

    private static final String PREF_STATUS_BAR_ONEPERC_BATTERY = "pref_status_bar_oneperc_battery";

    private static final String ONEPERC_BATT_PERSIST_PROP = "persist.sys.one_percent_batt";

    private static final String ONEPERC_BATT_DEFAULT = "0";

    private CheckBoxPreference mDockObserverOffPref;

    private String mBasebandSum;

    private String mKeypadPrefix;

    private String mKeypadTypeSum;

    private String mKeypadTypeSecSum;

    private String mKeypadMultipressSum;

    private String mKeypadMplangSum;

    private ListPreference mBasebandPref;

    private ListPreference mKeypadTypePref;

    private ListPreference mKeypadTypeSecPref;

    private CheckBoxPreference mKeypadKeylayoutPref;

    private ListPreference mKeypadMultipressPref;

    private ListPreference mKeypadMplangPref;

    private ListPreference mQtouchNumPref;

    private CheckBoxPreference mLoggerPref;

    private CheckBoxPreference mStatusBarOnepercBattery;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.settings);

        PreferenceScreen prefSet = getPreferenceScreen();

        mBasebandSum = getString(R.string.pref_baseband_summary);

        mKeypadTypeSum = getString(R.string.pref_keypad_type_summary);
        mKeypadTypeSecSum = getString(R.string.pref_keypad_type_sec_summary);
        mKeypadMultipressSum = getString(R.string.pref_keypad_multipress_summary);
        mKeypadMplangSum = getString(R.string.pref_keypad_mplang_summary);

        mDockObserverOffPref = (CheckBoxPreference) prefSet.findPreference(DOCK_OBSERVER_OFF_PREF);
        String dockObserverOff = SystemProperties.get(DOCK_OBSERVER_OFF_PERSIST_PROP, DOCK_OBSERVER_OFF_DEFAULT);
        mDockObserverOffPref.setChecked("1".equals(dockObserverOff));

        mBasebandPref = (ListPreference) prefSet.findPreference(BASEBAND_PREF);
        String baseband = SystemProperties.get(BASEBAND_PERSIST_PROP, BASEBAND_DEFAULT);
        mBasebandPref.setValue(baseband);
        mBasebandPref.setSummary(String.format(mBasebandSum, mBasebandPref.getEntry()));
        mBasebandPref.setOnPreferenceChangeListener(this);

        mKeypadPrefix = SystemProperties.get(KEYPAD_PREFIX_PROP, "0");
        mKeypadTypePref = (ListPreference) prefSet.findPreference(KEYPAD_TYPE_PREF);
        String keypadType = SystemProperties.get(KEYPAD_TYPE_PERSIST_PROP, KEYPAD_TYPE_DEFAULT);
        mKeypadTypePref.setValue(keypadType);
        mKeypadTypePref.setSummary(String.format(mKeypadTypeSum, mKeypadTypePref.getEntry()));
        mKeypadTypePref.setOnPreferenceChangeListener(this);

        mKeypadTypeSecPref = (ListPreference) prefSet.findPreference(KEYPAD_TYPE_SEC_PREF);
        keypadType = SystemProperties.get(KEYPAD_TYPE_SEC_PERSIST_PROP, KEYPAD_TYPE_SEC_DEFAULT);
        mKeypadTypeSecPref.setValue(keypadType);
        mKeypadTypeSecPref.setSummary(String.format(mKeypadTypeSecSum, mKeypadTypeSecPref.getEntry()));
        mKeypadTypeSecPref.setOnPreferenceChangeListener(this);

        mKeypadKeylayoutPref = (CheckBoxPreference) prefSet.findPreference(KEYPAD_KEYLAYOUT_PREF);
        String keypadKeylayout = SystemProperties.get(KEYPAD_KEYLAYOUT_PERSIST_PROP, KEYPAD_KEYLAYOUT_DEFAULT);
        mKeypadKeylayoutPref.setChecked("-russian".equals(keypadKeylayout));

        mKeypadMultipressPref = (ListPreference) prefSet.findPreference(KEYPAD_MULTIPRESS_PREF);
        String keypadMultipress = SystemProperties.get(KEYPAD_MULTIPRESS_PERSIST_PROP, KEYPAD_MULTIPRESS_DEFAULT);
        mKeypadMultipressPref.setValue(keypadMultipress);
        mKeypadMultipressPref.setSummary(String.format(mKeypadMultipressSum, mKeypadMultipressPref.getEntry()));
        mKeypadMultipressPref.setOnPreferenceChangeListener(this);

        mKeypadMplangPref = (ListPreference) prefSet.findPreference(KEYPAD_MPLANG_PREF);
        String keypadMplang = SystemProperties.get(KEYPAD_MPLANG_PERSIST_PROP, KEYPAD_MPLANG_DEFAULT);
        mKeypadMplangPref.setValue(keypadMplang);
        mKeypadMplangPref.setSummary(String.format(mKeypadMplangSum, mKeypadMplangPref.getEntry()));
        mKeypadMplangPref.setOnPreferenceChangeListener(this);

        mQtouchNumPref = (ListPreference) prefSet.findPreference(QTOUCH_NUM_PREF);
        String qtouchNum = SystemProperties.get(QTOUCH_NUM_PERSIST_PROP, QTOUCH_NUM_DEFAULT);
        mQtouchNumPref.setValue(qtouchNum);
        mQtouchNumPref.setOnPreferenceChangeListener(this);

        mLoggerPref = (CheckBoxPreference) prefSet.findPreference(LOGGER_PREF);
        String logger = SystemProperties.get(LOGGER_PERSIST_PROP, LOGGER_DEFAULT);
        mLoggerPref.setChecked("1".equals(logger));

        mStatusBarOnepercBattery = (CheckBoxPreference) prefSet
                .findPreference(PREF_STATUS_BAR_ONEPERC_BATTERY);
        String onepercBattery = SystemProperties.get(ONEPERC_BATT_PERSIST_PROP, ONEPERC_BATT_DEFAULT);
        mStatusBarOnepercBattery.setChecked("1".equals(onepercBattery));
    }

    @Override
    public void onResume() {
        super.onResume();
        mBasebandPref.setSummary(String.format(mBasebandSum, mBasebandPref.getEntry()));
        mKeypadTypePref.setSummary(String.format(mKeypadTypeSum, mKeypadTypePref.getEntry()));
        mKeypadTypeSecPref.setSummary(String.format(mKeypadTypeSecSum, mKeypadTypeSecPref.getEntry()));
        mKeypadMultipressPref.setSummary(String.format(mKeypadMultipressSum, mKeypadMultipressPref.getEntry()));
        mKeypadMplangPref.setSummary(String.format(mKeypadMplangSum, mKeypadMplangPref.getEntry()));
    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
        boolean value;
        if (preference == mDockObserverOffPref) {
            SystemProperties.set(DOCK_OBSERVER_OFF_PERSIST_PROP,
                    mDockObserverOffPref.isChecked() ? "1" : "0");
            return true;
        } else if (preference == mKeypadKeylayoutPref) {
            SystemProperties.set(KEYPAD_KEYLAYOUT_PERSIST_PROP,
                    mKeypadKeylayoutPref.isChecked() ? "-russian" : "");
            return true;
        } else if (preference == mLoggerPref) {
            SystemProperties.set(LOGGER_PERSIST_PROP,
                    mLoggerPref.isChecked() ? "1" : "0");
            return true;
        } else if (preference == mStatusBarOnepercBattery) {
            SystemProperties.set(ONEPERC_BATT_PERSIST_PROP,
                    mStatusBarOnepercBattery.isChecked() ? "1" : "0");
            return true;
        }
        return false;
    }

    private void keypadChanged() {

        class SendBroadcast extends Handler {
            @Override
            public void handleMessage(Message msg) {
                Intent i = new Intent();
                i.setAction("hw.keycharmap.change");
                sendBroadcast(i);
            }
        }

        Handler broadcastHandler = new SendBroadcast();
        Message m = new Message();
        broadcastHandler.sendMessageDelayed(m, 200);

    }

    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == mBasebandPref) {
            String baseband = (String) newValue;
            SystemProperties.set(BASEBAND_PERSIST_PROP, baseband);
            mBasebandPref.setSummary(String.format(mBasebandSum,
                    mBasebandPref.getEntries()[mBasebandPref.findIndexOfValue(baseband)]));
            return true;
        } else if (preference == mKeypadTypePref) {
            String keypadType = (String) newValue;
            SystemProperties.set(KEYPAD_TYPE_PERSIST_PROP, keypadType);
            if (!mKeypadPrefix.equals("0")) {
                SystemProperties.set(KEYPAD_TYPE_HW_PROP, mKeypadPrefix + keypadType);
            }
            mKeypadTypePref.setSummary(String.format(mKeypadTypeSum,
                    mKeypadTypePref.getEntries()[mKeypadTypePref.findIndexOfValue(keypadType)]));
            keypadChanged();
            return true;
        } else if (preference == mKeypadTypeSecPref) {
            String keypadType = (String) newValue;
            SystemProperties.set(KEYPAD_TYPE_SEC_PERSIST_PROP, keypadType);
            if (!mKeypadPrefix.equals("0")) {
                SystemProperties.set(KEYPAD_TYPE_HW_PROP, mKeypadPrefix +
                    mKeypadTypePref.getValue());
            }
            mKeypadTypeSecPref.setSummary(String.format(mKeypadTypeSecSum,
                    mKeypadTypeSecPref.getEntries()[mKeypadTypeSecPref.findIndexOfValue(keypadType)]));
            keypadChanged();
            return true;
        } else if (preference == mKeypadMultipressPref) {
            String keypadMultipress = (String) newValue;
            SystemProperties.set(KEYPAD_MULTIPRESS_PERSIST_PROP, keypadMultipress);
            mKeypadMultipressPref.setSummary(String.format(mKeypadMultipressSum,
                    mKeypadMultipressPref.getEntries()[mKeypadMultipressPref.findIndexOfValue(keypadMultipress)]));
            return true;
        } else if (preference == mKeypadMplangPref) {
            String keypadMplang = (String) newValue;
            SystemProperties.set(KEYPAD_MPLANG_PERSIST_PROP, keypadMplang);
            mKeypadMplangPref.setSummary(String.format(mKeypadMplangSum,
                    mKeypadMplangPref.getEntries()[mKeypadMplangPref.findIndexOfValue(keypadMplang)]));
            return true;
        } else if (preference == mQtouchNumPref) {
            String qtouchNum = (String) newValue;
            SystemProperties.set(QTOUCH_NUM_PERSIST_PROP, qtouchNum);
            return true;
        }
        return false;
    }

}

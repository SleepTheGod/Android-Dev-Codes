#!/bin/bash



# Function to execute ADB commands
execute_adb_command() {
    adb shell am broadcast -a android.provider.Telephony.SECRET_CODE -d "android_secret_code://$1"
}

# Generic Codes
generic_codes=(
    "*#06#|Show phone's IMEI"
    "*#07#|Display SAR value"
    "*#*#225#*#*|Display calendar storage info"
    "*#*#426#*#*|Google Play Services or Firebase Cloud Messaging info"
    "*#*#759#*#*|Access Rlz Debug UI"
    "*#0*#|Info menu"
    "*#*#4636#*#*|Info menu"
    "*#*#34971539#*#*|Camera info"
    "*#*#1111#*#*|FTA software version"
    "*#*#1234#*#*|PDA software version"
    "*#12580*369#|Software and hardware info"
    "*#7465625#|Device lock status"
    "*#*#232338#*#*|MAC address"
    "*#*#2663#*#*|Touchscreen version"
    "*#*#3264#*#*|RAM version"
    "*#*#232337#*#*|Bluetooth address"
    "*#*#2222#*#*|Hardware version"
    "*#*#44336#*#*|Software version and update info"
    "*#*#273282*255*663282*#*#*|Backup all media"
)

# Testing Codes
testing_codes=(
    "*#*#197328640#*#*|Test mode"
    "*#*#232339#*#*|Wi-Fi test"
    "*#*#0842#*#*|Brightness and vibration test"
    "*#*#2664#*#*|Touchscreen test"
    "*#*#232331#*#*|Bluetooth test"
    "*#*#7262626#*#*|Field test"
    "*#*#1472365#*#*|GPS quick test"
    "*#*#1575#*#*|Full GPS test"
    "*#*#0283#*#*|Packet loopback test"
    "*#*#0*#*#*|LCD display test"
    "*#*#0289#*#*|Audio test"
    "*#*#0588#*#*|Proximity sensor test"
)

# Configuration Codes
configuration_codes=(
    "*#9090#|Diagnostics settings"
    "*#301279#|HSDPA/HSUPA settings"
    "*#872564#|USB logging settings"
)

# Developer Codes
developer_codes=(
    "*#9900#|System dump mode"
    "##778|EPST menu"
)

# Manufacturer-specific codes
manufacturer_codes=(
    # Samsung codes
    "*#0*#|Access diagnostics"
    "*#011#|Network details and serving cell information"
    "*#0228#|Battery status"
    "*#0283#|Loopback Test menu"
    "*#0808#|USB Settings"
    "*#1234#|Software version/Model details"
    "*#2663#|Firmware details (Advanced)"
    "*#7353#|Quick test menu"
    "*#9090#|Advanced debugging tools"
    "*#9900#|SysDump"
    "*#2683662#|Service mode (Advanced)"
    "*#34971539#|Camera firmware details"
    # Xiaomi Codes
    "*#*#64663#*#*|Access test menu"
    # Realme codes
    "*#800#|Feedback menu"
    "*#888#|Engineer mode - displays PCB number"
    "*#6776#|Software version"
    # OnePlus codes
    "*#66#|Encrypted IMEI"
    "*#888#|Engineer mode - displays PCB number"
    "*#1234#|Software version"
    "1+=|NEVER SETTLE (In stock calculator app)"
    "*#*#2947322243#*#*|Wipes internal memory"
    # Asus codes
    "*#07#|Regulatory labels"
    ".12345+=|Open engineering mode (In calculator)"
    # Motorola codes
    "*#*#2486#*#*|Opens engineering mode"
    "*#07#|Shows regulatory information"
    "##7764726|Hidden Motorola Droid menu"
    # HTC codes
    "*#*#3424#*#*|HTC test program"
    "##786#|Phone reset menu"
    "##3282#|EPST menu"
    "##3424#|Diagnostic mode"
    "##33284#|Field test"
    "##8626337#|Launch Vocoder"
    "*#*#4636#*#*|HTC info menu"
    # Sony codes
    "*#*#73788423#*#*|Access service menu"
    "*#07#|Certification details"
    # Nokia codes
    "*#*#372733#*#*|Open service menu (FQC Menu)"
)

# Other codes
other_codes=(
    "*#7780#|Factory reset"
    "*2767*3855#|Full factory reset"
    "*#*#7594#*#*|Power off the phone"
    "*#*#8351#*#*|Activate dialer log mode"
    "#*#8350#*#*|Deactivate dialer log mode"
)

# Function to display menu and execute commands
display_menu() {
    local choice
    while true; do
        choice=$(dialog --clear --backtitle "Droid Command Interface" \
                        --title "Main Menu" \
                        --menu "Choose an option:" 15 50 7 \
                        "Generic Codes" "Generic diagnostic codes" \
                        "Testing Codes" "Testing and diagnostic codes" \
                        "Configuration Codes" "Configuration settings codes" \
                        "Developer Codes" "Developer diagnostic codes" \
                        "Manufacturer-specific Codes" "Manufacturer-specific codes" \
                        "Other Codes" "Other diagnostic codes" \
                        "Exit" "Exit the program" \
                        3>&1 1>&2 2>&3)
        case $choice in
            "Generic Codes")
                display_section "Generic Codes" "${generic_codes[@]}"
                ;;
            "Testing Codes")
                display_section "Testing Codes" "${testing_codes[@]}"
                ;;
            "Configuration Codes")
                display_section "Configuration Codes" "${configuration_codes[@]}"
                ;;
            "Developer Codes")
                display_section "Developer Codes" "${developer_codes[@]}"
                ;;
            "Manufacturer-specific Codes")
                display_section "Manufacturer-specific Codes" "${manufacturer_codes[@]}"
                ;;
            "Other Codes")
                display_section "Other Codes" "${other_codes[@]}"
                ;;
            "Exit")
                clear
                echo "Exiting..."
                exit 0
                ;;
            *)
                clear
                echo "
Invalid option. Please select again."
                ;;
        esac
    done
}

# Function to display section and execute selected code
display_section() {
    local section_name=$1
    shift
    local codes=("$@")
    local code_desc
    code_desc=$(dialog --clear --backtitle "Droid Command Interface" \
                        --title "$section_name" \
                        --menu "Choose a code:" 20 50 10 \
                        "${codes[@]}" \
                        3>&1 1>&2 2>&3)
    if [ -n "$code_desc" ]; then
        local code description
        IFS='|' read -r code description <<< "$code_desc"
        execute_adb_command "$code"
    else
        clear
        echo "Invalid option. Please select again."
    fi
}

# Main function
main() {
    # Check if ADB is installed
    if ! command -v adb &> /dev/null; then
        echo "ADB is not installed. Please install Android Debug Bridge (ADB) and try again."
        exit 1
    fi
    
    # Display menu
    display_menu
}

# Start the script
main

*** Settings ***
Documentation    This suite contains setup and teardown keywords for managing browser sessions and test execution.
Library  SeleniumLibrary

*** Variables ***
${BROWSER}  chrome
${userAgent}    Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36

*** Keywords ***
Begin Web Test
    ${deviceMetrics}=    Create Dictionary    width=${1920}    height=${1080}    pixelRatio=${1.0}    touch=${False}
    ${mobile_emulation}=    Create Dictionary    deviceMetrics=${deviceMetrics}    userAgent=${userAgent}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --touch-events\=disabled
    Call Method    ${options}    add_argument    --disable-blink-features\=TouchEvents,PointerEvents
    Call Method    ${options}    add_argument    --blink-settings\=primaryPointerType\=mouse
    Call Method    ${options}    add_argument    --blink-settings\=availablePointerTypes\=mouse
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    
    Open Browser    about:blank    ${BROWSER}    options=${options}
    
    #Browser özelliklerini alıp loglama
    ${window_size}=    Execute JavaScript    return [window.screen.width, window.screen.height]
    Log    Browser Screen Size: Width=${window_size[0]} Height=${window_size[1]}
    
    ${driver_info}=    Evaluate    sys.modules['selenium.webdriver'].Chrome().capabilities    sys, selenium.webdriver
    Log    ${driver_info}
    Log    Browser Name: ${driver_info['browserName']}
    Log    Browser Version: ${driver_info['browserVersion']}
    Log    Platform: ${driver_info['platformName']}

    #JavaScript ile primaryPointerType değerini loglama
    ${primary_pointer_type}=    Execute JavaScript    return navigator.pointerEnabled ? navigator.maxTouchPoints > 0 ? 'touch' : 'mouse' : 'unknown'
    Log    Primary Pointer Type: ${primary_pointer_type}
    ${pointer_enabled}=    Execute JavaScript    return navigator.pointerEnabled
    Log    Pointer Enabled: ${pointer_enabled}

    ${max_touch_points}=    Execute JavaScript    return navigator.maxTouchPoints
    Log    Max Touch Points: ${max_touch_points}

# Begin Web Test    #UI Enabled Automation
#     Open Browser    about:blank    ${BROWSER}
#     Maximize Browser Window  
    
End Web Test
    Close Browser

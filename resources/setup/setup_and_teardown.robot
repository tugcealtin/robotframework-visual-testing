*** Settings ***
Documentation    This suite contains setup and teardown keywords for managing browser sessions and test execution. 
...    It includes both headless mode initialization and WebDriver timeout configurations.
Library  SeleniumLibrary

*** Variables ***
${BROWSER}  chrome
${userAgent}    Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36

*** Keywords ***
Begin Web Test   #Headless Mode
    ${deviceMetrics}=    Create Dictionary    width=${1920}    height=${1080}    pixelRatio=${1.0}    touch=${False}
    ${mobile_emulation}=    Create Dictionary    deviceMetrics=${deviceMetrics}    userAgent=${userAgent}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --headless\=old
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --touch-events\=disabled
    Call Method    ${options}    add_argument    --disable-blink-features\=TouchEvents,PointerEvents
    Call Method    ${options}    add_argument    --blink-settings\=primaryPointerType\=mouse
    Call Method    ${options}    add_argument    --blink-settings\=availablePointerTypes\=mouse
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    
    Open Browser    about:blank    ${BROWSER}    options=${options}
    

# Begin Web Test    #UI Enabled Automation
#     Open Browser    about:blank    ${BROWSER}
#     Maximize Browser Window  
    
End Web Test
    Close Browser

Configure WebDriver Timeout
    [Documentation]    Sets the maximum wait time when the browser is started.
    Set Selenium Timeout    30 seconds         # Komut çalıştırılma timeout süresi
    Set Selenium Implicit Wait    10 seconds   # Element bulunamazsa bekleme süresi
    Set Selenium Speed    0.5 seconds          # Adımlar arası bekleme süresi

Close All Browser Sessions
    [Documentation]    Closes all browser sessions.
    Close All Browsers

*** Settings ***
Resource  ../setup/setup_and_teardown.robot
Resource  ../po/utils.robot


Test Setup  Begin Web Test
Test Teardown  End Web Test



*** Test Cases ***
Verify About Us 
    Go to Page    ${TECHCAREER_URL}/about-us
    Capture Page Screenshot  n.png
    Take Full Page Screenshot    ${about_us_new}  
    Compare Page Image With Reference    about_us_page    ${about_us_new}    ${about_us_diff} 


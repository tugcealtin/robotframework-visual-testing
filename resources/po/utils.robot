*** Settings ***
Library    SeleniumLibrary
Library    ../../custom_libraries/visual_helpers.py

*** Variables ***
${TECHCAREER_URL}  https://www.techcareer.net/
${POPUP_CLOSE_BUTTON}  css=[data-testid="CloseRoundedIcon"]

${reference_img}    reference_image.png
${about_us_new}          about_us_new.png
${about_us_diff}         about_us_diff.png

*** Keywords ***
Go to Page
    [Arguments]   ${page_url} 
    Go To  ${page_url}
    Wait Until Location Is  ${page_url}  timeout=60s
    Close Popups And Continue Cases
    Efilli Cookie Accept

Close Popups And Continue Cases
    ${status_epbta_popup}=  Run Keyword And Return Status  Wait Until Keyword Succeeds    4s    2s   Page Should Contain Element  ${POPUP_CLOSE_BUTTON}
    ${counter}  Set Variable  0
    WHILE    ${status_epbta_popup}
        Click Element  ${POPUP_CLOSE_BUTTON}
        ${status_epbta_popup}=  Run Keyword And Return Status  Page Should Contain Element  ${POPUP_CLOSE_BUTTON}
        ${counter}=  Evaluate     ${counter} + 1
        IF    ${counter} == 3
            ${status_epbta_popup} == False
        END
    END
Efilli Cookie Accept
    TRY
        Execute Javascript  document.querySelector('.efilli-layout-starbucks').shadowRoot.querySelector("div > .banner__accept-button").click();
    EXCEPT
        Log To Console   There is no Efilli Cookie 
        ${location}=  Get Location
        Log To Console  ${location}
    END

Take Full Page Screenshot 
    [Arguments]   ${page_name}
    Capture Full Page Screenshot Part    ${page_name}

Compare Page Image With Reference
    [Arguments]   ${page_name}    ${new_img}    ${diff_img}
    Compare Images   ${page_name}   ${new_img}    ${diff_img}

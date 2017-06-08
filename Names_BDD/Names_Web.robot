*** Settings ***
Suite Setup       Reset Names Database
Suite Teardown    Export Browser Info
Library           Selenium2Library
Library           Collections
Library           RequestsLibrary

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${app_url}        https://b2u-web.herokuapp.com/    # http://localhost:8100/
${selenium_grid_url}    http://Manakel166:217e2175-30a5-4fa9-8146-d2350af3a14d@ondemand.saucelabs.com:80/wd/hub
${target_browser}    Safari
${target_browser_version}    8
${target_platform}    MAC
${ui_burger_menu}    //button[contains (@class,'bar-buttons')]
${ui_menu_add_name}    //button[contains(.,'Add Name')]
${ui_add_name_input}    //input[@formcontrolname='name']
${ui_add_name_button}    //button[contains(@class,'button-default')][contains(.,'Add Name')]
${ui_menu_list}    //button[contains(.,'List')]
${ui_menu_modify_name}    //button[contains(.,'Modify Name')]
${ui_input_old_name}    //*[@formcontrolname='oldName']
${ui_input_new_name}    //input[@formcontrolname='newName']
${ui_button_modify_name}    //button[contains(@class,'button-default')][contains(.,'Modify Name')]
${ui_menu_delete_name}    //button[contains(.,'Delete Name')]
${ui_input_name_to_delete}    //*[@formcontrolname='name']
${ui_button_delete_name}    //button[contains(@class,'button-default')][contains(.,'Delete Name')]
${api_end_point}    https://b2u-rest.herokuapp.com

*** Test Cases ***
I can add a Name
    [Tags]    _WEB    C0
    Open Names Application
    In Names, Add :    ${original_name}
    In Names, List should display:    ${original_name}
    [Teardown]    Close Browser

I can modfy a Name
    [Tags]    _WEB
    Open Names Application
    In Names, List should display:    ${original_name}
    In Names, Modify a Name:    ${original_name}    ${renamed_name}
    In Names, List should display:    ${renamed_name}
    In Names, List should NOT display:    ${original_name}
    [Teardown]    Close Browser

I can delete a Name
    [Tags]    _WEB
    Open Names Application
    In Names, List should display:    ${renamed_name}
    In Names, Delete a Name:    ${renamed_name}
    In Names, List should NOT display:    ${renamed_name}
    [Teardown]    Close Browser

*** Keywords ***
Open Names Application
    ${caps}=    Create Dictionary    version=${target_browser_version}    platform=${target_platform}
    ${ff default caps}    Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    Set To Dictionary    ${ff default caps}    marionette=${False}
    Open Browser    ${app_url}    browser=${target_browser}    remote_url=${selenium_grid_url}    desired_capabilities=${caps}
    Page Should Contain Element    //h1[contains(.,'Names list')]
    Comment    Set Tags    Browser:${target_browser}    Version:${target_browser}.${target_browser_version}    Platform:${target_platform}

In Names, Add :
    [Arguments]    ${arg1}
    I'm on HomePage
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    ${ui_menu_add_name}
    I'm on AddPage
    Input Text    ${ui_add_name_input}    ${original_name}
    Click Element    ${ui_add_name_button}
    Capture Page Screenshot

In Names, List should display:
    [Arguments]    ${arg1}
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    ${ui_menu_list}
    I'm on ListPage
    Page Should Contain    ${arg1}
    Capture Page Screenshot

In Names, Modify a Name:
    [Arguments]    ${arg1}    ${arg2}
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    ${ui_menu_modify_name}
    I'm on ModifyPage
    Click Element    ${ui_input_old_name}
    Click Element    //button[contains(.,'${arg1}')]
    Click Element    //button[contains(.,'OK')]
    Capture Page Screenshot
    Input Text    ${ui_input_new_name}    ${arg2}
    Click Element    ${ui_button_modify_name}
    Capture Page Screenshot

In Names, List should NOT display:
    [Arguments]    ${arg1}
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'List')]
    I'm on ListPage
    Capture Page Screenshot
    Page Should Not Contain    ${arg1}
    Capture Page Screenshot

In Names, Delete a Name:
    [Arguments]    ${arg1}
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    ${ui_menu_delete_name}
    I'm on DeletePage
    Click Element    ${ui_input_name_to_delete}
    Click Element    //button[contains(.,'${arg1}')]
    Click Element    //button[contains(.,'OK')]
    Capture Page Screenshot
    Click Element    ${ui_button_delete_name}
    Capture Page Screenshot

Open in browser
    Open Browser    ${app_url}    Safari    driver1    ${selenium_grid_url}

I'm on HomePage
    Page Should Contain Element    //h1[contains(.,'Names list')]

I'm on MainMenu
    Page Should Contain Element    //div[contains(.,'Menu')]

I'm on AddPage
    Page Should Contain Element    //div[contains(.,'Add Name')][contains(@class,'toolbar-title')]

I'm on ListPage
    Page Should Contain Element    //div[contains(.,'List')][contains(@class,'toolbar-title')]

I'm on ModifyPage
    Page Should Contain Element    //div[contains(.,'Modify Name')][contains(@class,'toolbar-title')]

I'm on DeletePage
    Page Should Contain Element    //div[contains(.,'Delete Name')][contains(@class,'toolbar-title')]

Reset Names Database
    Create Session    TempForReset    ${api_end_point}
    ${resp}=    Get Request    TempForReset    /INIT
    Should Be Equal As Strings    ${resp.status_code}    200
    Delete All Sessions

Export Browser Info
    Log    Test was run on ${target_browser} in version ${target_browser_version} on platform ${target_platform}

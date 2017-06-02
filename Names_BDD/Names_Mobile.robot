*** Settings ***
Library           AppiumLibrary
Library           Collections
Library           RequestsLibrary

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${app}            C:/WGROCHUL/STAGIAIRES_SOGETI_2017/LOIC/android-debug.apk
${selenium_grid_url}    http://Manakel166:217e2175-30a5-4fa9-8146-d2350af3a14d@ondemand.saucelabs.com:80/wd/hub

*** Test Cases ***
I can add a Name
    [Tags]    WEB    NAMES    P0
    Open Names Application
    In Names, Add :    ${original_name}
    In Names, List should display:    ${original_name}
    Close Application

I can modfy a Name
    [Tags]    WEB    NAMES    P0
    Open Names Application
    In Names, List should display:    ${original_name}
    In Names, Modify a Name:    ${original_name}    ${renamed_name}
    In Names, List should display:    ${renamed_name}
    In Names, List should NOT display:    ${original_name}
    Close Browser

I can delete a Name
    [Tags]    WEB    NAMES    P3
    Open Names Application
    In Names, List should display:    ${renamed_name}
    In Names, Delete a Name:    ${renamed_name}
    In Names, List should NOT display:    ${renamed_name}
    Close Browser

*** Keywords ***
Open Names Application
    Open Application    ${app_url}    browser=${target_browser}    remote_url=${selenium_grid_url}    desired_capabilities=${caps}
    Page Should Contain Element    //h1[contains(.,'Names list')]

In Names, Add :
    [Arguments]    ${arg1}
    I'm on HomePage
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'Add Name')]
    I'm on AddPage
    Input Text    //input[@formcontrolname='name']    ${original_name}
    Click Element    //button[contains(@class,'button-default')][contains(.,'Add Name')]

In Names, List should display:
    [Arguments]    ${arg1}
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'List')]
    I'm on ListPage
    Page Should Contain    ${arg1}

In Names, Modify a Name:
    [Arguments]    ${arg1}    ${arg2}
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'Modify Name')]
    I'm on ModifyPage
    Click Element    //*[@formcontrolname='oldName']
    Click Element    //button[contains(.,'${arg1}')]
    Click Element    //button[contains(.,'OK')]
    Click Element    //button[contains(@class,'button-default')][contains(.,'Delete Name')]

In Names, List should NOT display:
    [Arguments]    ${arg1}
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'List')]
    I'm on ListPage
    Page Should Not Contain    ${arg1}

In Names, Delete a Name:
    [Arguments]    ${arg1}
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'Delete Name')]
    I'm on DeletePage
    ${source}=    Get Source
    Log    ${source}
    Click Element    //*[@formcontrolname='name']
    Click Element    //button[contains(.,'${arg1}')]
    Click Element    //button[contains(.,'OK')]
    Click Element    //button[contains(@class,'button-default')][contains(.,'Delete Name')]

Open in browser
    Open Browser    ${app_url}    Safari    driver1    ${selenium_grid_url}

Add a Name
    [Arguments]    ${name}
    Click Link    Add name
    Input Text    name    ${name}
    Click Button    LoginButton
    Click Link    Back

Modify a Name
    [Arguments]    ${oldName}    ${newName}
    Click Link    Modify name
    Input Text    oldName    ${oldName}
    Input Text    newName    ${newName}
    Click Element    LoginButton
    Click Link    Back

Delete a Name
    [Arguments]    ${name}
    Click Link    Delete name
    Input Text    name    ${name}
    Click Button    LoginButton
    Click Link    Back

Database should have
    [Arguments]    ${name}
    Click Link    List names
    Wait Until Page Contains    ${name}    2s
    Click Link    Back

Database should not have
    [Arguments]    ${name}
    Click Link    List names
    Wait Until Page Does Not Contain    ${name}    2s
    Click Link    Back

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

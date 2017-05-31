*** Settings ***
Library           Selenium2Library
Library           Collections

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${app_url}        https://b2u-web.herokuapp.com/
${selenium_grid_url}    http://127.0.0.1:4441/wd/hub    # http://Manakel166:217e2175-30a5-4fa9-8146-d2350af3a14d@ondemand.saucelabs.com:80/wd/hub
${target_browser}    Chrome
${target_browser_version}    57.0
${target_platform}    Windows 7

*** Test Cases ***
I can add a Name
    Open Names Application
    In Names, Add :    ${original_name}
    In Names, List should display:    ${original_name}
    Close Browser

I can modfy a Name
    Open Names Application
    In Names, List should display:    ${original_name}
    In Names, Modify a Name:    ${original_name}    ${renamed_name}
    In Names, List should display:    ${renamed_name}
    In Names, List should NOT display:    ${original_name}
    Close Browser

I can delete a Name
    Open Names Application
    In Names, List should display:    ${renamed_name}
    In Names, Delete a Name:    ${renamed_name}
    In Names, List should NOT display:    ${renamed_name}
    Close Browser

Names_Web_Old
    Open in browser
    Add a Name    ${original_name}
    Database should have    ${original_name}
    Modify a Name    ${original_name}    ${renamed_name}
    Database should have    ${renamed_name}
    Delete a Name    ${renamed_name}
    Database should not have    ${renamed_name}
    Close Browser

*** Keywords ***
Open Names Application
    Open Browser    ${app_url}    browser=${target_browser}    remote_url=${selenium_grid_url}
    Page Should Contain Element    //h1[contains(.,'Names list')]

In Names, Add :
    [Arguments]    ${arg1}
    I'm on HomePage
    Click Element    //button[contains (@class,'bar-buttons')]
    I'm on MainMenu
    Click Element    //button[contains(.,'Add Name')]
    I'm on AddPages
    Input Text    //input[@formcontrolname='name']    ${original_name}
    Click Element    //button[contains(@class,'button')]

In Names, List should display:
    [Arguments]    ${arg1}
    ${resp}=    Get Request    NamesApp    /names
    List Should Contain Value    ${resp.json()['names']}    ${arg1}

In Names, Modify a Name:
    [Arguments]    ${arg1}    ${arg2}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${resp}=    Put Request    NamesApp    /names/${arg1}    data={"newname":"${arg2}"}    headers=${header}

In Names, List should NOT display:
    [Arguments]    ${arg1}
    ${resp}=    Get Request    NamesApp    /names
    List Should Not Contain Value    ${resp.json()['names']}    ${arg1}

In Names, Delete a Name:
    [Arguments]    ${arg1}
    ${header}=    Create Dictionary    Content-Type=application/json
    Delete Request    NamesApp    /names    data={"name":"${arg1}"}    headers=${header}

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

I'm on AddPages
    Page Should Contain Element    //div[contains(.,'Add Name')][contains(@class,'toolbar-title')]

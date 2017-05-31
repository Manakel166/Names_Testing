*** Settings ***
Library           AppiumLibrary
Library           Collections

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${app_url}        https://b2u-web.herokuapp.com/
${device_farm_url}    http://eu1.appium.testobject.com/wd/hub

*** Test Cases ***
I can add a Name
    Open Names Application
    In Names, Add :    ${original_name}
    In Names, List should display:    ${original_name}

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

*** Keywords ***
Open Names Application
    ${caps}=    Create Dictionary    testobject_device=LG_Nexus_5X_real    testobject_app_id=1    testobject_api_key=13502594F29C49178C774B9A18187E40
    Open Application    remote_url=${device_farm_url}    capabilities=${caps}
    Capture Page ScreenShot
    Close Application

In Names, Add :
    [Arguments]    ${arg1}
    ${header}=    Create Dictionary    Content-Type=application/json
    Post Request    NamesApp    /names    data={"name":"${arg1}"}    headers=${header}

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

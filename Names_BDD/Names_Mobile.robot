*** Settings ***
Suite Setup       Reset Names Database
Library           AppiumLibrary
Library           Collections
Library           RequestsLibrary

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${app}            C:/WGROCHUL/STAGIAIRES_SOGETI_2017/LOIC/android-debug.apk
${api_end_point}    https://b2u-rest.herokuapp.com
${selenium_grid_url}    https://eu1.appium.testobject.com/wd/hub
${target_device}    LG_Nexus_4_E960_real    # \ Motorola_Moto_E_2nd_gen_free
${ui_burger_menu}    //android.widget.Button \    #[@content-desc='menu']
${ui_menu_add_name}    xpath=//android.widget.Button[contains(@content-desc,'Add Name')]
${ui_add_name_input}    //android.widget.EditText[@text='name']
${ui_add_name_button}    //android.widget.Button[contains(@content-desc,'ADD NAME')]

*** Test Cases ***
I can add a Name
    [Tags]    _MOBILE    C0
    Open Names Application
    In Names, Add :    ${original_name}
    In Names, List should display:    ${original_name}
    [Teardown]    Close Application

I can modfy a Name
    [Tags]    _MOBILE
    Open Names Application
    In Names, List should display:    ${original_name}
    In Names, Modify a Name:    ${original_name}    ${renamed_name}
    In Names, List should display:    ${renamed_name}
    In Names, List should NOT display:    ${original_name}
    [Teardown]    Close Application

I can delete a Name
    [Tags]    _MOBILE
    Open Names Application
    In Names, List should display:    ${renamed_name}
    In Names, Delete a Name:    ${renamed_name}
    In Names, List should NOT display:    ${renamed_name}
    [Teardown]    Close Application

*** Keywords ***
Open Names Application
    Open Application    ${selenium_grid_url}    alias=NamesApp    testobject_api_key=13502594F29C49178C774B9A18187E40    testobject_device=${target_device}    testobject_appium_version=1.6.4    testobject_app_id=1
    Wait Until Keyword Succeeds    30s    5s    Page Should Contain Element    xpath=//*[@content-desc='Names list']
    Comment    Set Tags    Platform:Android    device:${target_device}

In Names, Add :
    [Arguments]    ${arg1}
    I'm on HomePage
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    ${ui_menu_add_name}
    I'm on AddPage
    ${source}=    Get Source
    Log    ${source}
    Input Text    ${ui_add_name_input}    ${original_name}
    Click Element    ${ui_add_name_button}

In Names, List should display:
    [Arguments]    ${arg1}
    Click Element    ${ui_burger_menu}
    I'm on MainMenu
    Click Element    //android.widget.Button[@content-desc='List']
    I'm on ListPage
    Page Should Contain Text    ${arg1}

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

I'm on HomePage
    Wait Until Keyword Succeeds    5s    1s    Page Should Contain Element    xpath=//*[@content-desc='Names list']
    Capture Page Screenshot

I'm on MainMenu
    Wait Until Page Contains Element    //android.view.View[@content-desc='Menu']    3s
    Capture Page Screenshot

I'm on AddPage
    Wait Until Page Contains Element    //android.view.View[contains(@content-desc,'Add Name')]    5s
    Capture Page Screenshot

I'm on ListPage
    Wait Until Page Contains Element    xpath=//android.view.View[@content-desc='List']    5s
    Capture Page Screenshot

I'm on ModifyPage
    Page Should Contain Element    //div[contains(.,'Modify Name')][contains(@class,'toolbar-title')]
    Capture Page Screenshot

I'm on DeletePage
    Page Should Contain Element    //div[contains(.,'Delete Name')][contains(@class,'toolbar-title')]
    Capture Page ScreenShot

Reset Names Database
    Create Session    TempForReset    ${api_end_point}
    ${resp}=    Get Request    TempForReset    /INIT
    Should Be Equal As Strings    ${resp.status_code}    200
    Delete All Sessions

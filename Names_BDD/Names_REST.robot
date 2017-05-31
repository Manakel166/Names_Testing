*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${original_name}    Thor
${renamed_name}    Loki
${api_end_point}    https://api-rest-b2u.herokuapp.com

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

I can delete a Name
    Open Names Application
    In Names, List should display:    ${renamed_name}
    In Names, Delete a Name:    ${renamed_name}
    In Names, List should NOT display:    ${renamed_name}

*** Keywords ***
Open Names Application
    Create Session    NamesApp    ${api_end_point}

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

*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     http://localhost:8080


*** Keywords ***
Solicitar post
    [Arguments]    ${endpoint}    ${payload}=${None}    ${headers}=${None}    ${expected_status}=200
    IF    ${headers}==${None}
        ${headers}=    Create Dictionary    Content-Type=application/json
    ELSE
        ${headers}=    Run Keyword    ${headers}
    END
    Log To Console    Endpoint enviado: ${endpoint}
    Log To Console    Payload enviado: ${payload}
    Log To Console    Headers enviado: ${headers}
    Create Session    API_Testing    ${BASE_URL}
    ${response}=    POST On Session
    ...    API_Testing
    ...    ${endpoint}
    ...    headers=${headers}
    ...    json=${payload}
    ...    expected_status=${expected_status}
    Log To Console    Response Status: ${response.status_code}
    Log To Console    Response Body: ${response.content.decode('utf-8')}
    RETURN    ${response}

Solicitar put
    [Arguments]    ${endpoint}    ${payload}=${None}    ${headers}=${None}    ${expected_status}=200
    IF    ${headers}==${None}
        ${headers}=    Create Dictionary    Content-Type=application/json
    ELSE
        ${headers}=    Run Keyword    ${headers}
    END
    Log To Console    Endpoint enviado: ${endpoint}
    Log To Console    Payload enviado: ${payload}
    Log To Console    Headers enviado: ${headers}
    ${response}=    PUT
    ...    ${BASE_URL}/${endpoint}
    ...    headers=${headers}
    ...    json=${payload}
    ...    expected_status=${expected_status}
    Log To Console    Response Status: ${response.status_code}
    Log To Console    Response Body: ${response.content.decode('utf-8')}
    RETURN    ${response}

Solicitar patch
    [Arguments]    ${endpoint}    ${payload}=${None}    ${headers}=${None}    ${expected_status}=200
    IF    ${headers}==${None}
        ${headers}=    Create Dictionary    Content-Type=application/json
    ELSE
        ${headers}=    Run Keyword    ${headers}
    END
    Log To Console    Endpoint enviado: ${endpoint}
    Log To Console    Payload enviado: ${payload}
    Log To Console    Headers enviado: ${headers}
    ${response}=    PATCH
    ...    ${BASE_URL}/${endpoint}
    ...    headers=${headers}
    ...    json=${payload}
    ...    expected_status=${expected_status}
    Log To Console    Response Status: ${response.status_code}
    Log To Console    Response Body: ${response.content.decode('utf-8')}
    RETURN    ${response}

Solicitar get
    [Arguments]    ${endpoint}    ${headers}=${None}    ${expected_status}=200
    Log To Console    Endpoint enviado: ${endpoint}
    Log To Console    Headers enviado: ${headers}
    ${response}=    GET    ${BASE_URL}/${endpoint}    headers=${headers}    expected_status=${expected_status}
    Log To Console    Response Status: ${response.status_code}
    Log To Console    Response Body: ${response.content.decode('utf-8')}
    RETURN    ${response}

Solicitar delete
    [Arguments]    ${endpoint}    ${headers}=${None}    ${expected_status}=200
    Log To Console    Endpoint enviado: ${endpoint}
    Log To Console    Headers enviado: ${headers}
    ${response}=    DELETE    ${BASE_URL}/${endpoint}    headers=${headers}    expected_status=${expected_status}
    Log To Console    Response Status: ${response.status_code}
    Log To Console    Response Body: ${response.content.decode('utf-8')}
    RETURN    ${response}

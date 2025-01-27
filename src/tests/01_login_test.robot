*** Settings ***
Library     Collections
Resource    ../resources/base_request.resource


*** Variables ***
${ENDPOINT_AUTH_LOGIN}      auth/login
${ENDPOINT_USER}            user
${TOKEN}                    ${None}


*** Test Cases ***
Login com sucesso
    [Tags]    sucesso
    ${payload}=    Create Dictionary    email=email@email.com    password=123456
    ${response}=    Solicitar post    ${ENDPOINT_AUTH_LOGIN}    ${payload}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    name
    Dictionary Should Contain Key    ${response.json()}    token
    ${token}=    Get From Dictionary    ${response.json()}    token
    Set Global Variable    ${TOKEN}    ${token}

Buscar usuário logado com sucesso
    [Tags]    sucesso
    ${headers}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${response}=    Solicitar get    ${ENDPOINT_USER}    ${headers}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    email
    Dictionary Should Contain Key    ${response.json()}    name

Login inválido
    [Tags]    exceção
    ${payload}=    Create Dictionary    email=email@email.com    password=1234567
    ${response}=    Solicitar post    ${ENDPOINT_AUTH_LOGIN}    ${payload}    expected_status=400
    Status Should Be    400    ${response}
    ${response_json}=    Convert To Dictionary    ${response.json()}
    Dictionary Should Contain Value    ${response_json}    Invalid credentials    message
    Should Be Equal As Strings    ${response.json()['status']}    BAD_REQUEST

Login com dados nulo
    [Tags]    exceção
    ${payload}=    Create Dictionary    email=${None}    password=${None}
    ${response}=    Solicitar post    ${ENDPOINT_AUTH_LOGIN}    ${payload}    expected_status=400
    Status Should Be    400    ${response}
    ${response_json}=    Convert To List    ${response.json()}
    ${isNotEmpty}=    Run Keyword And Return Status    Should Not Be Empty    ${response_json}
    Log To Console    ${isNotEmpty}
    Log To Console    ${response_json}
    FOR    ${item}    IN    @{response_json}
        Dictionary Should Contain Key    ${item}    field
        Dictionary Should Contain Key    ${item}    message
    END
    ${lista}=    Create List
    ${campo1}=    Create Dictionary    field=password    message=A senha é obrigatória.
    ${campo2}=    Create Dictionary    field=email    message=O e-mail é obrigatório.
    ${campo3}=    Create Dictionary    field=password    message=A senha não deve ser nula.
    ${campo4}=    Create Dictionary    field=email    message=O e-mail não deve ser nulo.
    Append To List    ${lista}    ${campo1}
    Append To List    ${lista}    ${campo2}
    Append To List    ${lista}    ${campo3}
    Append To List    ${lista}    ${campo4}
    Log To Console    ${lista}
    FOR    ${expected_item}    IN    @{lista}
        ${field}=    Get From Dictionary    ${expected_item}    field
        ${message}=    Get From Dictionary    ${expected_item}    message
        ${matched_item}=    Evaluate
        ...    any(item["field"] == "${field}" and item["message"] == "${message}" for item in ${response_json})
        Should Be True    ${matched_item}
    END

Login sem body
    [Tags]    exceção
    ${response}=    Solicitar post    ${ENDPOINT_AUTH_LOGIN}    expected_status=400
    Status Should Be    400    ${response}
    ${response_json}=    Convert To Dictionary    ${response.json()}
    ${message}=    Get From Dictionary    ${response_json}    message
    Should Contain    ${message}    Required request body is missing
    Should Be Equal As Strings    ${response.json()['status']}    BAD_REQUEST

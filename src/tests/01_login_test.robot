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

*** Settings ***
Suite Setup     Read Environment Variable


*** Variables ***
${URL}      ${None}


*** Keywords ***
Read Environment Variable
    Log To Console    É iniciado primeiro aqui
    ${test_env}=    Set Variable    %{MY_ENV=${None}}
    ${base_url_env}=    Set Variable    %{BASE_URL=${None}}
    Log To Console    ${test_env}
    Log To Console    ${base_url_env}
    Set Global Variable    ${URL}    ${base_url_env}

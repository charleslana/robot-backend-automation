*** Settings ***
Library     FakerLibrary


*** Keywords ***
Gerar Email Aleatório
    ${email}    Email
    RETURN    ${email}

Gerar Nome Aleatório
    ${name}    First Name
    RETURN    ${name}

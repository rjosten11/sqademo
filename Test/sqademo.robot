*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary    WITH NAME    faker
Test Setup    Open Browser    ${demoUrl}    ${browser}
Test Teardown    Close Browser



*** Variables ***
${demoUrl}    https://opensource-demo.orangehrmlive.com/
${browser}    chrome




*** Test Cases ***
Login user without password
    Given the user is in the login page
    And User enters "admin" as username
    When User clicks the login button
    Then login page will show password cannot be empty
    
Login user without username
    Given the user is in the login page
    And User enters "admin123" as password
    When User clicks the login button
    then login page will show username cannot be empty

Login user without username and password
    Given the user is in the login page
    When User clicks the login button
    Then login page will show username cannot be empty

Login User with wrong Password
    Given the user is in the login page
    And User enters "admin" as username
    And User enters "admin123!" as password
    When User clicks the login button
    Then Login page will show invalid credentials
    
Login User with wrong username
    Given the user is in the login page
    And User enters "adminG" as username
    And User enters "admin123" as password
    When User clicks the login button
    Then Login page will show invalid credentials


Login User
    Given the user is in the login page
    When User enters "admin" as username
    When User enters "admin123" as password
    When User clicks the login button
    Then user is in the dashboard
    

    
Go to employees page
    Given User is logged in
    When user clicks pim link
    Then User is in view employees page
    
Go to add employee page
    Given user is logged in
    And user is in the employees page
    When user clicks the add button
    Then user is in the add employee page

Create employee
    Given user is logged in
    And user is in the employees page
    And user clicks the add button
    And user enters first name
    And user enters middle name
    And user enters last name
    and user sets employee id
    When user clicks save button
    Then user is in the personal details page

Create employee with login details
    Given user is logged in
    And user is in the employees page
    And user clicks the add button
    And user enters first name
    And user enters middle name
    And user enters last name
    and user sets employee id
    And user clicks create login details checkbox
    And user creates username
    And user creates password
    And user sets the status
    When user clicks save button
    Then user is in the personal details page 
    
Create employee details
    Given user is logged in
    And new employee has been created
    And user clicks "//input[@id="btnSave"][@value="Edit"]" button
    And user enters other id
    And user enters drivers license
    And user enters ssn number and sin number
    and user selects gender
    and user selects marital status
    and user selects nationality
    and user enters date of birth
    when user clicks "//*[@id="btnSave"]" button
    then save button should change into edit
    

Delete employees except hr
    Given user is logged in
    When user is in the employees page
    Then Loop Select and Delete all employees except hr

*** Keywords ***
Loop Select and Delete all employees except hr
    FOR    ${i}    IN RANGE    9999
        ${numofRows}    Get Element Count    //*[@id="resultTable"]/tbody/tr
        Exit For Loop If    ${numofRows}<3
        Select all employees except admin
        user clicks delete
        user confirms modal
        Wait Until Element Is Visible    //*[@id="resultTable"]/tbody/tr[1]/td[1]
    END
login page will show password cannot be empty
    ${spanMessage}    Get text    xpath://*[@id="spanMessage"]
    Should Be Equal As Strings    '${spanMessage}'    'Password cannot be empty'
Login page will show username cannot be empty
    ${spanMessage}    Get text    xpath://*[@id="spanMessage"]
    Should Be Equal As Strings    '${spanMessage}'    'Username cannot be empty'
Login page will show invalid credentials
    ${spanMessage}    Get text    xpath://*[@id="spanMessage"]
    Should Be Equal As Strings    '${spanMessage}'    'Invalid credentials'
Select all employees except admin
    Wait Until Element Is Visible    //*[@id="resultTable"]/tbody/tr
    ${numofRows}    Get Element Count    //*[@id="resultTable"]/tbody/tr
    FOR    ${rowCurrent}    IN RANGE    51
        Exit For Loop If    '${rowCurrent}' > '${numofRows}'
        Continue For Loop If    '${rowCurrent}' == '${0}'
        ${posXpath}    Table Selector "${rowCurrent}" "${5}"
        ${pos}    Get Text    xpath:${posXpath}
        Continue For Loop If    """${pos}""" == """HR Manager"""
        ${tableCheckbox}    Table Selector "${rowCurrent}" "${1}"     
        ${tableCheckbox}    Catenate    SEPARATOR=    ${tableCheckbox}    /input
        ${checkboxExist}    Get element count    ${tableCheckbox}
        Continue For Loop If    '${checkboxExist}' == '0'
        Select checkbox    ${tableCheckbox}
    END
Table Selector "${row}" "${column}"
        ${tableSelect}    Set Variable    //*[@id="resultTable"]/tbody/tr[        
        ${tableSelect}    Catenate    SEPARATOR=    ${tableSelect}    ${row}    ]/td[    ${column}    ]
        [RETURN]    ${tableSelect}

user confirms modal
    Wait Until Element Is Visible    xpath://*[@id="dialogDeleteBtn"]
    click button    xpath://*[@id="dialogDeleteBtn"]
employee table should be empty
    sleep    10s
    Log to console    1
user clicks delete
    click button    xpath://*[@id="btnDelete"]
user clicks the select all checkbox
    Select checkbox    xpath://*[@id="ohrmList_chkSelectAll"]
save button should change into edit
    ${buttonValue}    Get Value    xpath://*[@id="btnSave"]
    Should Contain    ${buttonValue}    Edit
user sets employee id
    ${employeeID}    faker.Random Number    digits=4    fix_len=${True}
    Input Text    xpath://*[@id="employeeId"]    ${employeeID}
user enters date of birth
    ${birthDate}    faker.Date Of Birth    minimum_age=20    maximum_age=65
    Input Text    xpath://*[@id="personal_DOB"]    ${birthDate}
user selects nationality
    ${nationalityListIndex}    Get List Items    xpath://*[@id="personal_cmbNation"]
    ${countNationality}    Get length    ${nationalityListIndex}
    ${maxIndex}    Evaluate    ${countNationality}-${1}
    ${nationality}    faker.Random Int    min=1    max=${maxIndex}
    Select from list by index    xpath://*[@id="personal_cmbNation"]    ${nationality}
user selects marital status
    ${maritalStatus}    Random Element    ['Single', 'Married', 'Other']
    Select from list by value    xpath://*[@id="personal_cmbMarital"]    ${maritalStatus}
user selects gender
    ${gender}    Random Element    ['1', '2']
    Select Radio Button    personal[optGender]    ${gender}
user enters ssn number and sin number
    ${ssn}    faker.Ssn
    Input text    xpath://*[@id="personal_txtNICNo"]    ${ssn}
    ${sin}    faker.Ein
    Input text    xpath://*[@id="personal_txtSINNo"]    ${sin}
user enters drivers license
    ${randLetter}    faker.Random Uppercase Letter
    ${randFirstNum}    faker.Random Number    digits=2    fix_len=${True}
    ${randFirstSet}=    Catenate    SEPARATOR=    ${randLetter}    ${randFirstNum}    
    ${randSecondNum}    faker.Random Number    digits=2    fix_len=${True}
    ${randThirdNum}    faker.Random Number    digits=6    fix_len=${True}
    ${driversLicense}=    Catenate    ${randFirstSet}    ${randSecondNum}    ${randThirdNum}
    Input Text    xpath://*[@id="personal_txtLicenNo"]    ${driversLicense}
    ${driversLicenseExpiry}    faker.Future Date    end_date=+10y
    Input Text    xpath://*[@id="personal_txtLicExpDate"]    ${driversLicenseExpiry}
user enters other id
    ${otherID}    faker.Random Number    digits=4
    Input Text    xpath://*[@id="personal_txtOtherID"]    ${otherID}
user clicks "${buttonXPATH}" button
    Wait Until Location Contains    empNumber
    Click Button    xpath:${buttonXPATH}
New employee has been created
    user is in the employees page
    user clicks the add button
    user enters first name
    user enters middle name
    user enters last name
    user clicks create login details checkbox
    user creates username
    user creates password
    user sets the status
    user clicks save button
    
User is in the employee creation page
    user is in the employees page
    user clicks the add button
User sets the status
    ${userStatus}    Random Element    ['0', '1']
    Select from list by index    xpath://*[@id="status"]    ${userStatus}
user creates password
    ${empPass}    faker.Password    length=8
    Input Text    xpath://*[@id="user_password"]    ${empPass}
    Input Text    xpath://*[@id="re_password"]    ${empPass}

user creates username
    ${empUser}    faker.User Name
    Input Text    xpath://*[@id="user_name"]   ${empUser}      
user clicks create login details checkbox
    Select Checkbox    xpath://*[@id="chkLogin"]  
user is in the personal details page
    Sleep    3s
    ${getUrl}    Get Location
    Log To Console    ${getUrl}
    Should Contain    ${getUrl}    empNumber
User clicks save button
    Click Button    xpath://input[@id="btnSave"][@value="Save"]
User enters employee id
    ${employeeID}    faker.Random Number    digits=4    fix_len=${True}
    Input Text    xpath://*[@id="employeeId"]    ${employeeID}
User enters first name
    ${firstName}    faker.First Name Male
    Input Text    xpath://*[@id="firstName"]    ${firstName}
User enters middle name
    ${middleName}    faker.Last Name
    Input Text    xpath://*[@id="middleName"]    ${middleName}
User enters last name
    ${lastName}    faker.Last Name Male
    Input Text    xpath://*[@id="lastName"]    ${lastName}
user is in the add employee page
    ${getUrl}    Get Location
    Log To Console    ${getUrl}
    Should Contain    ${getUrl}    addEmployee
user clicks the add button
    Click Button    xpath://*[@id="btnAdd"]
User is in the employees page
    User clicks pim link
User is logged in
    User enters "admin" as username
    user enters "admin123" as password
    user clicks the login button
    user is in the dashboard
User is in view employees page
    ${getUrl}    Get Location
    Log To Console    ${getUrl}
    Should Contain    ${getUrl}    viewEmployeeList
User clicks pim link
    Click Link    xpath://*[@id="menu_pim_viewPimModule"]
The user is in the login page
    ${getUrl}    Get Location
    Log To Console    ${getUrl}
    Should Contain    ${getUrl}    https://opensource-demo.orangehrmlive.com/
User enters "${username}" as username
    Input Text    id:txtUsername    ${username}
User enters "${password}" as password
    Input Password    id:txtPassword    ${password}
User clicks the login button
    Click Button    xpath://*[@id="btnLogin"]
User is in the dashboard
    ${getUrl}    Get Location
    Log To Console    ${getUrl}
    Should Contain    ${getUrl}    dashboard
Login
    User Input
    Password Input
    LoginButton
    Verify Login

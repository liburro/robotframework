*** Settings ***
Resource          data_formats/formats_resource.robot

*** Variables ***
${PARSING}            parsing
${NO TESTS}           ${PARSING}${/}notests
${EMPTY TC TABLE}     ${PARSING}${/}empty_testcase_table.robot
${NO TC TABLE MSG}    File has no tests or tasks.

*** Test Cases ***
Invalid Input
    Check Parsing Error    unsupported.log    Unsupported file format 'log'.    ${PARSING}/unsupported.log

Malformed HTML
    Check Parsing Error    malformed.html    .*    ${HTMLDIR}/malformed.html

HTML File Not Containing Tests
    Check Parsing Error    invalid.html    ${NO TC TABLE MSG}    ${HTMLDIR}/invalid.html

Directory Containing No Test Cases
    Run Tests Without Processing Output    ${EMPTY}    ${NO TESTS}
    Check Stderr Contains    [ ERROR ] Suite 'Notests' contains no tests.${USAGE_TIP}

File Containing No Test Cases
    Run Tests Without Processing Output    ${EMPTY}    ${EMPTY TC TABLE}
    Check Stderr Contains    [ ERROR ] Suite 'Empty Testcase Table' contains no tests.${USAGE_TIP}

Multisource Containing No Test Cases
    Run Tests Without Processing Output    ${EMPTY}    ${HTMLDIR}/empty.html ${TSVDIR}/empty.tsv
    ${html} =    Normalize Path    ${DATADIR}/${HTMLDIR}/empty.html
    ${tsv} =    Normalize Path    ${DATADIR}/${TSVDIR}/empty.tsv
    Check Stderr Contains    [ ERROR ] Parsing '${html}' failed: ${NO TC TABLE MSG}

Empty HTML File
    Check Parsing Error    empty.html    ${NO TC TABLE MSG}    ${HTMLDIR}/empty.html

Empty TSV File
    Check Parsing Error    empty.tsv    ${NO TC TABLE MSG}    ${TSVDIR}/empty.tsv

Empty TXT File
    Check Parsing Error    empty.txt    ${NO TC TABLE MSG}    ${TXTDIR}/empty.txt

*** Keywords ***
Check Parsing Error
    [Arguments]    ${file}    ${error}    ${paths}
    Run Tests Without Processing Output    ${EMPTY}    ${paths}
    Check Stderr Matches Regexp    \\[ ERROR \\] Parsing '.*[/\\\\]${file}' failed: ${error}${USAGE_TIP}

*** Settings ***
## Reference: https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html
##  ........  https://docs.robotframework.org/docs/examples/restfulbooker
##  ........  https://www.youtube.com/watch?v=VtcEghZOpZc
Library    Collections
Library    RequestsLibrary
Library    OperatingSystem

Suite Setup    Create Session  jsonplaceholder  https://jsonplaceholder.typicode.com

*** Variables ***
${dev_b_token}    Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI3R
${dev_b_server}    https://test-api-dev-b.apps.robot-b.osd.corp
${params}         kod=BI1K

*** Test cases **

Get Request Test
      Create Session    google  http://www.google.com

      ${resp_google}=   GET On Session  google  /  expected_status=200
      ${resp_json}=     GET On Session  jsonplaceholder  /posts/1

      Should Be Equal As Strings          ${resp_google.reason}  OK
      
Post Request Test
      &{data}=    Create dictionary  title=Robotframework requests  body=This is a test!  userId=1
      ${resp}=    POST On Session    jsonplaceholder  /posts  json=${data}  expected_status=anything

      Status Should Be                 201  ${resp}
      Dictionary Should Contain Key    ${resp.json()}  id

Quick Get Request Test
    ${response}=    GET  https://www.google.com

Quick Get Request With Parameters Test
    ${response}=    GET  https://www.google.com/search  params=query=ciao  expected_status=200

Quick Get A JSON Body Test
    ${response}=    GET  https://jsonplaceholder.typicode.com/posts/1
    Should Be Equal As Strings    1  ${response.json()}[id]

Do a GET Request with Bearer token - see video
    &{headers}    Create Dictionary    Authorization=${dev_b_token}
    Create Session    dev_b_session    ${dev_b_server}
    Log    ${headers}
    ${response}=    GET On session    dev_b_session    /api/v1/test/info    headers=${headers}    params=${params}
    Log    ${response}
    Status Should Be    200    ${response}    #Check Status as 200
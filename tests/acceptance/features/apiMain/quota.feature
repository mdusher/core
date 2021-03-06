@api
Feature: quota

  Background:
    Given using OCS API version "1"

	# Owner

  Scenario: Uploading a file as owner having enough quota
    Given user "user0" has been created with default attributes and skeleton files
    And the quota of user "user0" has been set to "10 MB"
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "201"

  @smokeTest
  Scenario: Uploading a file as owner having insufficient quota
    Given user "user0" has been created with default attributes and skeleton files
    And the quota of user "user0" has been set to "20 B"
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "507"
    Then as "user0" the files uploaded to "/testquota.txt" with all mechanisms should not exist

  Scenario: Overwriting a file as owner having enough quota
    Given user "user0" has been created with default attributes and skeleton files
    And user "user0" has uploaded file with content "test" to "/testquota.txt"
    And the quota of user "user0" has been set to "10 MB"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be between "201" and "204"

  Scenario: Overwriting a file as owner having insufficient quota
    Given user "user0" has been created with default attributes and skeleton files
    And user "user0" has uploaded file with content "test" to "/testquota.txt"
    And the quota of user "user0" has been set to "20 B"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "507"
    And the content of file "/testquota.txt" for user "user0" should be "test"

	# Received shared folder

  Scenario: Uploading a file in received folder having enough quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has created folder "/testquota"
    And user "user1" has shared folder "/testquota" with user "user0" with permissions "all"
    And the quota of user "user0" has been set to "20 B"
    And the quota of user "user1" has been set to "10 MB"
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/testquota/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "201"

  Scenario: Uploading a file in received folder having insufficient quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has created folder "/testquota"
    And user "user1" has shared folder "/testquota" with user "user0" with permissions "all"
    And the quota of user "user0" has been set to "10 MB"
    And the quota of user "user1" has been set to "20 B"
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/testquota/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "507"
    Then as "user0" the files uploaded to "/testquota.txt" with all mechanisms should not exist

  Scenario: Overwriting a file in received folder having enough quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has created folder "/testquota"
    And user "user1" has uploaded file with content "test" to "/testquota/testquota.txt"
    And user "user1" has shared folder "/testquota" with user "user0" with permissions "all"
    And the quota of user "user0" has been set to "20 B"
    And the quota of user "user1" has been set to "10 MB"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be between "201" and "204"

  Scenario: Overwriting a file in received folder having insufficient quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has created folder "/testquota"
    And user "user1" has uploaded file with content "test" to "/testquota/testquota.txt"
    And user "user1" has shared folder "/testquota" with user "user0" with permissions "all"
    And the quota of user "user0" has been set to "10 MB"
    And the quota of user "user1" has been set to "20 B"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "507"
    And the content of file "/testquota/testquota.txt" for user "user0" should be "test"

	# Received shared file

  Scenario: Overwriting a received file having enough quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has uploaded file with content "test" to "/testquota.txt"
    And user "user1" has shared file "/testquota.txt" with user "user0" with permissions "share,update,read"
    And the quota of user "user0" has been set to "20 B"
    And the quota of user "user1" has been set to "10 MB"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be between "201" and "204"

  Scenario: Overwriting a received file having insufficient quota
    Given these users have been created with default attributes and skeleton files:
      | username |
      | user0    |
      | user1    |
    And user "user1" has uploaded file with content "test" to "/testquota.txt"
    And user "user1" has shared file "/testquota.txt" with user "user0" with permissions "share,update,read"
    And the quota of user "user0" has been set to "10 MB"
    And the quota of user "user1" has been set to "20 B"
    When user "user0" overwrites from file "filesForUpload/textfile.txt" to file "/testquota.txt" with all mechanisms using the WebDAV API
    Then the HTTP status code of all upload responses should be "507"
    And the content of file "/testquota.txt" for user "user0" should be "test"

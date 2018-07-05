Feature: get

  Background:
    Given user "participant1" exists
    Given user "participant2" exists
    Given user "participant3" exists
    Given user "participant4" exists



  Scenario: get a share
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" renames room "group room" to "Group room" with 200
    And user "participant1" shares "welcome.txt" with room "group room" with OCS 100
    When user "participant1" gets last share
    Then share is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room |
      | share_with_displayname | Group room |

  Scenario: get a received share
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" renames room "group room" to "Group room" with 200
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant1" shares "welcome.txt" with room "group room" with OCS 100
    When user "participant2" gets last share
    Then share is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | group room |
      | share_with_displayname | Group room |



  Scenario: get a share using a user not invited to the room
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" renames room "group room" to "Group room" with 200
    And user "participant1" shares "welcome.txt" with room "group room" with OCS 100
    When user "participant2" gets last share
    Then the OCS status code should be "404"
    And the HTTP status code should be "200"



  Scenario: get a share after changing the room name
    Given user "participant1" creates room "group room"
      | roomType | 2 |
    And user "participant1" renames room "group room" to "Group room" with 200
    And user "participant1" adds "participant2" to room "group room" with 200
    And user "participant1" shares "welcome.txt" with room "group room" with OCS 100
    And user "participant1" renames room "group room" to "New room name" with 200
    When user "participant1" gets last share
    Then share is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room |
      | share_with_displayname | New room name |
    And user "participant2" gets last share
    And share is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | group room |
      | share_with_displayname | New room name |



  Scenario: get all shares of a user
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates room "one-to-one room not invited to"
      | roomType | 1 |
      | invite   | participant4 |
    And user "participant1" creates folder "/test"
    And user "participant1" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant1" shares "test" with room "group room invited to" with OCS 100
    And user "participant1" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant1" shares "test" with room "own one-to-one room" with OCS 100
    And user "participant2" shares "welcome (2).txt" with user "participant3" with OCS 100
    And user "participant3" shares "welcome (2).txt" with room "one-to-one room not invited to" with OCS 100
    When user "participant1" gets all shares
    Then the list of returned shares has 4 shares
    And share 0 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 1 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | home::participant1 |
      | file_target            | /test |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
      | permissions            | 31 |
    And share 2 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
    And share 3 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | home::participant1 |
      | file_target            | /test |
      | share_with             | own one-to-one room |
      | share_with_displayname | participant3-displayname |
      | permissions            | 31 |

  Scenario: get all shares and reshares of a user
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates room "one-to-one room not invited to"
      | roomType | 1 |
      | invite   | participant4 |
    And user "participant1" creates folder "/test"
    And user "participant1" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant1" shares "test" with room "group room invited to" with OCS 100
    And user "participant1" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant1" shares "test" with room "own one-to-one room" with OCS 100
    And user "participant2" shares "welcome (2).txt" with user "participant3" with OCS 100
    And user "participant3" shares "welcome (2).txt" with room "one-to-one room not invited to" with OCS 100
    When user "participant1" gets all shares and reshares
    Then the list of returned shares has 6 shares
    And share 0 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | uid_file_owner         | participant1 |
      | displayname_file_owner | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome (2).txt |
      | share_with             | participant3 |
      | share_with_displayname | participant3-displayname |
      | share_type             | 0 |
    And share 1 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 2 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | home::participant1 |
      | file_target            | /test |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
      | permissions            | 31 |
    And share 3 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
    And share 4 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | home::participant1 |
      | file_target            | /test |
      | share_with             | own one-to-one room |
      | share_with_displayname | participant3-displayname |
      | permissions            | 31 |
    And share 5 is returned with
      | uid_owner              | participant3 |
      | displayname_owner      | participant3-displayname |
      | uid_file_owner         | participant1 |
      | displayname_file_owner | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome (2).txt |
      | share_with             | one-to-one room not invited to |
      | share_with_displayname | participant3-displayname |

  Scenario: get all shares of a file
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates room "one-to-one room not invited to"
      | roomType | 1 |
      | invite   | participant4 |
    And user "participant1" creates folder "/test"
    And user "participant1" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant1" shares "test" with room "group room invited to" with OCS 100
    And user "participant1" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant1" shares "test" with room "own one-to-one room" with OCS 100
    And user "participant2" shares "welcome (2).txt" with user "participant3" with OCS 100
    And user "participant3" shares "welcome (2).txt" with room "one-to-one room not invited to" with OCS 100
    When user "participant1" gets all shares for "/welcome.txt"
    Then the list of returned shares has 2 shares
    And share 0 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 1 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |

  Scenario: get all shares and reshares of a file
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates room "one-to-one room not invited to"
      | roomType | 1 |
      | invite   | participant4 |
    And user "participant1" creates folder "/test"
    And user "participant1" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant1" shares "test" with room "group room invited to" with OCS 100
    And user "participant1" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant1" shares "test" with room "own one-to-one room" with OCS 100
    And user "participant2" shares "welcome (2).txt" with user "participant3" with OCS 100
    And user "participant3" shares "welcome (2).txt" with room "one-to-one room not invited to" with OCS 100
    When user "participant1" gets all shares and reshares for "/welcome.txt"
    Then the list of returned shares has 4 shares
    And share 0 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | uid_file_owner         | participant1 |
      | displayname_file_owner | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome (2).txt |
      | share_with             | participant3 |
      | share_with_displayname | participant3-displayname |
      | share_type             | 0 |
    And share 1 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 2 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
    And share 3 is returned with
      | uid_owner              | participant3 |
      | displayname_owner      | participant3-displayname |
      | uid_file_owner         | participant1 |
      | displayname_file_owner | participant1-displayname |
      | path                   | /welcome.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome (2).txt |
      | share_with             | one-to-one room not invited to |
      | share_with_displayname | participant3-displayname |

  Scenario: get all shares of a folder
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates room "one-to-one room not invited to"
      | roomType | 1 |
      | invite   | participant4 |
    And user "participant1" creates folder "/test"
    And user "participant1" creates folder "/test/subfolder"
    And user "participant1" creates folder "/test/subfolder/subsubfolder"
    And user "participant1" creates folder "/test2"
    And user "participant1" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant1" shares "test/subfolder" with room "group room invited to" with OCS 100
    And user "participant1" shares "test/subfolder/subsubfolder" with room "group room invited to" with OCS 100
    And user "participant1" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant1" shares "test2" with room "own one-to-one room" with OCS 100
    And user "participant1" moves file "/welcome.txt" to "/test/renamed.txt" with 201
    And user "participant2" shares "subfolder" with user "participant3" with OCS 100
    And user "participant3" shares "subfolder" with room "one-to-one room not invited to" with OCS 100
    # Only direct children are taken into account
    When user "participant1" gets all shares for "/test" and its subfiles
    Then the list of returned shares has 3 shares
    And share 0 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test/renamed.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 1 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test/renamed.txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | home::participant1 |
      | file_target            | /welcome.txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
    And share 2 is returned with
      | uid_owner              | participant1 |
      | displayname_owner      | participant1-displayname |
      | path                   | /test/subfolder |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | home::participant1 |
      | file_target            | /subfolder |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
      | permissions            | 31 |



  Scenario: get all received shares of a user
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant1" adds "participant2" to room "own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant2" adds "participant3" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates folder "/test"
    And user "participant2" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant3" shares "test" with room "group room invited to" with OCS 100
    And user "participant2" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant3" shares "test" with room "own one-to-one room" with OCS 100
    When user "participant1" gets all received shares
    Then the list of returned shares has 4 shares
    And share 0 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 1 is returned with
      | uid_owner              | participant3 |
      | displayname_owner      | participant3-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | shared::/test |
      | file_target            | /test |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
      | permissions            | 31 |
    And share 2 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |
    And share 3 is returned with
      | uid_owner              | participant3 |
      | displayname_owner      | participant3-displayname |
      | path                   | /test |
      | item_type              | folder |
      | mimetype               | httpd/unix-directory |
      | storage_id             | shared::/test |
      | file_target            | /test |
      | share_with             | own one-to-one room |
      | share_with_displayname | participant3-displayname |
      | permissions            | 31 |

  Scenario: get all received shares of a file
    Given user "participant1" creates room "own group room"
      | roomType | 2 |
    And user "participant1" renames room "own group room" to "Own group room" with 200
    And user "participant1" adds "participant2" to room "own group room" with 200
    And user "participant2" creates room "group room invited to"
      | roomType | 2 |
    And user "participant2" renames room "group room invited to" to "Group room invited to" with 200
    And user "participant2" adds "participant1" to room "group room invited to" with 200
    And user "participant2" adds "participant3" to room "group room invited to" with 200
    And user "participant1" creates room "own one-to-one room"
      | roomType | 1 |
      | invite   | participant3 |
    And user "participant3" creates folder "/test"
    And user "participant2" shares "welcome.txt" with room "own group room" with OCS 100
    And user "participant3" shares "test" with room "group room invited to" with OCS 100
    And user "participant2" shares "welcome.txt" with room "group room invited to" with OCS 100
    And user "participant3" shares "test" with room "own one-to-one room" with OCS 100
    When user "participant1" gets all received shares for "/welcome (2).txt"
    Then the list of returned shares has 2 shares
    And share 0 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | own group room |
      | share_with_displayname | Own group room |
    And share 1 is returned with
      | uid_owner              | participant2 |
      | displayname_owner      | participant2-displayname |
      | path                   | /welcome (2).txt |
      | item_type              | file |
      | mimetype               | text/plain |
      | storage_id             | shared::/welcome (2).txt |
      | file_target            | /welcome (2).txt |
      | share_with             | group room invited to |
      | share_with_displayname | Group room invited to |

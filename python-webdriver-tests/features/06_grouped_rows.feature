Feature: Indicators for expanding and collapsing grouped rows
  In order to manage the parent/child relationships of large data sets
  As a user presented with a grid
  I need an intuitive set of controls

  @complete
  Scenario: Grouping column is presented as first column
    Given There are 5 grouped loans
    When Presenting "grouping column"
    Then There are 6 columns
    And The index 1 should be "Id" column
    And The index 2 should be "Activity" column
    And The index 3 should be "status" column
    And The index 0 should be "GroupingColumn" column

  @complete
  Scenario: Grouped rows are presented
    Given I have the following grouped loans in MounteBank:
      | groupName | id | activity | isGroupRow |
      | group1    | f1 | s1       | True       |
      | group2    | f2 | s2       | True       |
      | group3    | f3 | s3       | True       |
      | group4    | f4 | s4       | True       |
      | group5    | f5 | s5       | True       |
    When Presenting "grouping column"
    Then I see grouped rows:
      | indicator | groupName | Id | Activity |
      | +         | group1    | f1 | s1       |
      | +         | group2    | f2 | s2       |
      | +         | group3    | f3 | s3       |
      | +         | group4    | f4 | s4       |
      | +         | group5    | f5 | s5       |

  @complete
  Scenario: The grouping column should not be scrolled
    Given There are 5 grouped loans
    When Presenting "grouping column"
    And The user drags the "status" on column to "right" with 1000 pixel
    And Drag horizontal scroll bar with 1000 pixel
    Then The column header block should has "scroll left" and same as body scroll left
    And The grouping and fixed columns should not be scrolled


  @complete
  Scenario: check grouped rows with collapse indicator
    Given I have the following grouped loans in MounteBank:
      | groupName   | id   | activity | isGroupRow |
      | group1      | f1   | s1       | True       |
      | group1-chd1 | f1-1 | s1-1     | False      |
      | group1-chd2 | f1-2 | s1-2     | False      |
      | group2      | f2   | s2       | True       |
      | group3      | f3   | s3       | True       |
      | group3-chd1 | f3-1 | s3-1     | False      |
      | group3-chd2 | f3-2 | s3-2     | False      |
      | group4      | f4   | s4       | True       |
      | group5      | f5   | s5       | True       |
    When Presenting "grouping column"
    And Click "expand" for row "group1"
    And Click "expand" for row "group3"
    Then I see grouped rows:
      | indicator | groupName   | Id   | Activity |
      | -         | group1      | f1   | s1       |
      | +         | group1-chd1 | f1-1 | s1-1     |
      | +         | group1-chd2 | f1-2 | s1-2     |
      | +         | group2      | f2   | s2       |
      | -         | group3      | f3   | s3       |
      | +         | group3-chd1 | f3-1 | s3-1     |
      | +         | group3-chd2 | f3-2 | s3-2     |
      | +         | group4      | f4   | s4       |
      | +         | group5      | f5   | s5       |
    When Click "collapse" for row "group1"
    Then I see grouped rows:
      | indicator | groupName   | Id   | Activity |
      | +         | group1      | f1   | s1       |
      | +         | group2      | f2   | s2       |
      | -         | group3      | f3   | s3       |
      | +         | group3-chd1 | f3-1 | s3-1     |
      | +         | group3-chd2 | f3-2 | s3-2     |
      | +         | group4      | f4   | s4       |
      | +         | group5      | f5   | s5       |


  @complete
  Scenario: Expand grouped row with partial loaded children loans
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id | beginningDr |
      | accountSection[1]-accountType[1]-accountCode[15] |    | s           |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    And Click "expand" for row "101"
    When Customer drags scroll bar by offset 100 with 1 times and wait loading section
    Then There should be 4 sections loaded

  @complete
  Scenario: Expand and collapse grouped rows with unlimited level
    Given I have the following grouped loans in MounteBank:
      | groupName        | id     | activity | isGroupRow |
      | group1           | f1     | s1       | True       |
      | group1-chd1      | f1-1   | s1-1     | True       |
      | group1-chd1-chd1 | f1-1-1 | s1-1-1   | False      |
      | group1-chd1-chd2 | f1-1-2 | s1-1-2   | False      |
      | group1-chd2      | f1-2   | s1-2     | True       |
      | group1-chd2-chd1 | f1-2-1 | s1-2-1   | False      |
      | group1-chd2-chd2 | f1-2-2 | s1-2-2   | False      |
      | group2           | f2     | s2       | True       |
      | group2-chd1      | f2-1   | s2-1     | True       |
      | group2-chd1-chd1 | f2-1-1 | s2-1-1   | False      |
      | group2-chd1-chd2 | f2-1-2 | s2-1-2   | False      |
      | group2-chd2      | f2-2   | s2-2     | True       |
      | group2-chd2-chd1 | f2-2-1 | s2-2-1   | False      |
      | group2-chd2-chd2 | f2-2-2 | s2-2-2   | False      |
    When Presenting "grouping column"
    Then I see grouped rows:
      | indicator | groupName | Id | Activity |
      | +         | group1    | f1 | s1       |
      | +         | group2    | f2 | s2       |
    And Click "expand" for row "group1"
    And Click "expand" for row "group1-chd1"
    And Click "expand" for row "group1-chd2"
    Then I see grouped rows:
      | indicator | groupName        | Id     | Activity |
      | -         | group1           | f1     | s1       |
      | -         | group1-chd1      | f1-1   | s1-1     |
      |           | group1-chd1-chd1 | f1-1-1 | s1-1-1   |
      |           | group1-chd1-chd2 | f1-1-2 | s1-1-2   |
      | -         | group1-chd2      | f1-2   | s1-2     |
      |           | group1-chd2-chd1 | f1-2-1 | s1-2-1   |
      |           | group1-chd2-chd2 | f1-2-2 | s1-2-2   |
      | +         | group2           | f2     | s2       |
    When Click "collapse" for row "group1"
    Then I see grouped rows:
      | indicator | groupName | Id | Activity |
      | +         | group1    | f1 | s1       |
      | +         | group2    | f2 | s2       |
    When Click "expand" for row "group1"
    Then I see grouped rows:
      | indicator | groupName        | Id     | Activity |
      | -         | group1           | f1     | s1       |
      | -         | group1-chd1      | f1-1   | s1-1     |
      |           | group1-chd1-chd1 | f1-1-1 | s1-1-1   |
      |           | group1-chd1-chd2 | f1-1-2 | s1-1-2   |
      | -         | group1-chd2      | f1-2   | s1-2     |
      |           | group1-chd2-chd1 | f1-2-1 | s1-2-1   |
      |           | group1-chd2-chd2 | f1-2-2 | s1-2-2   |
      | +         | group2           | f2     | s2       |

  @complete
  Scenario: The expand and collapse indicator should be pluggable
    Given I have the following grouped loans in MounteBank:
      | groupName   | id   | activity | isGroupRow |
      | group1      | f1   | s1       | True       |
      | group1-chd1 | f1-1 | s1-1     | False      |
      | group1-chd2 | f1-2 | s1-2     | False      |
      | group2      | f2   | s2       | True       |
      | group3      | f3   | s3       | True       |
      | group3-chd1 | f3-1 | s3-1     | False      |
      | group3-chd2 | f3-2 | s3-2     | False      |
      | group4      | f4   | s4       | True       |
      | group5      | f5   | s5       | True       |
    When Presenting "grouping column with pluggable indicator"
    Then The row "group1" indicator should be "expand" with customized
    When When Click "expand" for row "group1"
    Then The row "group1" indicator should be "collapse" with customized


  @complete
  Scenario: The grouping column should be auto resize
    Given I have the following grouped loans in MounteBank:
      | groupName        | id     | activity | isGroupRow |
      | group1           | f1     | s1       | True       |
      | group1-chd1      | f1-1   | s1-1     | True       |
      | group1-chd1-chd1 | f1-1-1 | s1-1-1   | False      |
      | group1-chd1-chd2 | f1-1-2 | s1-1-2   | False      |
      | group1-chd2      | f1-2   | s1-2     | True       |
      | group1-chd2-chd1 | f1-2-1 | s1-2-1   | False      |
      | group1-chd2-chd2 | f1-2-2 | s1-2-2   | False      |
      | group2           | f2     | s2       | True       |
      | group2-chd1      | f2-1   | s2-1     | True       |
      | group2-chd1-chd1 | f2-1-1 | s2-1-1   | False      |
      | group2-chd1-chd2 | f2-1-2 | s2-1-2   | False      |
      | group2-chd2      | f2-2   | s2-2     | True       |
      | group2-chd2-chd1 | f2-2-1 | s2-2-1   | False      |
      | group2-chd2-chd2 | f2-2-2 | s2-2-2   | False      |
    When Presenting "grouping column"
    Then The "GroupingColumn" column width should be 149 pixel
    When Click "expand" for row "group1"
    Then The "GroupingColumn" column width should be 159 pixel
    When Click "expand" for row "group1-chd1"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "expand" for row "group1-chd2"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "expand" for row "group2"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "collapse" for row "group1"
    Then The "GroupingColumn" column width should be 159 pixel
    When Click "collapse" for row "group2"
    Then The "GroupingColumn" column width should be 149 pixel
    When Click "expand" for row "group1"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "collapse" for row "group1-chd1"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "expand" for row "group2"
    Then The "GroupingColumn" column width should be 169 pixel
    When Click "collapse" for row "group1-chd2"
    Then The "GroupingColumn" column width should be 159 pixel
    When Click "collapse" for row "group1"
    Then The "GroupingColumn" column width should be 159 pixel
    When Click "collapse" for row "group2"
    Then The "GroupingColumn" column width should be 149 pixel

  @complete
  Scenario: Expand grouped row with partial loaded
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    Then There should be 1 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    When Customer drags scroll bar by offset 80 with 3 times and wait loading section
    Then There should be 3 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    When Click "expand" for row "1"
    Then There should be 2 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    When Customer drags scroll bar by offset 40 with 1 times and wait loading section
    Then There should be 3 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[20]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    When Click "expand" for row "101"
    Then There should be 3 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    When Click "collapse" for row "1"
    And Click "expand" for row "1"
    Then There should be 2 sections loaded


  @complete
  Scenario: The default loading indicator should display when partial load grouped loans
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] |    | s                   |
    And Presenting "grouping column present partial loaded children"
    And Stop mountebank
    When Customer drags scroll bar by offset 40 with 1 times
    Then The default loading indicator should display on 1 items

  @complete
  Scenario: The default loading indicator should display when partial load children loans
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id  | Beginning DR (Base) |
      | accountSection[1]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Stop mountebank
    When Customer drags scroll bar by offset 1000 with 1 times and wait loading section
    Then The default loading indicator should display on 1 items

  @complete
  Scenario: The custom loading indicator should display when partial load grouped loans
    Given Presenting "grouping column with pluggable loading indicator"
    When Click "expand" for the 0 row
    And Click "expand" for the 1 row
    Then The custom loading indicator should display on 11 items

  @complete
  Scenario: The default loading indicator should display when partial load children loans
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id  | Beginning DR (Base) |
      | accountSection[1]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Stop mountebank
    When Click "expand" for the 0 row to check indicator
    Then The default loading indicator should display on 1 items
    And The 1 row indicator should be "hidden"

  @complete
  Scenario: The grouping column should not be resizable and draggable
    Given There are 5 grouped loans
    When Presenting "grouping column"
    Then The "GroupingColumn" column width should be 149 pixel
    Then The index 0 should be "GroupingColumn" column
    When The user drags the "GroupingColumn" on column to "right" with 100 pixel
    Then The "GroupingColumn" column width should be 149 pixel
    When Reorder an inner column "GroupingColumn" header to "right" with 300 pixel
    Then The index 0 should be "GroupingColumn" column


  @complete
  Scenario: The grouping column with two fixed column
    Given There are 5 grouped loans
    When Presenting "grouping column with fixed columns"
    And The user drags the "Activity" on column to "right" with 800 pixel
    And Drag horizontal scroll bar with 800 pixel
    Then The column header block should has "scroll left" and same as body scroll left
    And There are 3 grouping and fixed columns
    And The column "GroupingColumn" should be fixed
    And The column "Id" should be fixed
    And The column "Activity" should be fixed
    And The grouping and fixed columns should not be scrolled

  @complete
  Scenario: The fixed columns shouldn't be reordered
    Given There are 5 grouped loans
    And Presenting "grouping column with fixed columns"
    When Reorder an inner column "Id" header to "right" with 300 pixel
    Then The index 0 should be "GroupingColumn" column
    And The index 1 should be "Id" column
    And The index 2 should be "Activity" column

  @complete
  Scenario: The loading indicator in next section if there's only one row lazily load
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[11] | [11] | [11]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 1 row
    When Customer drags scroll bar by offset 1000 with 1 times and wait loading section
    Then I see grouped rows:
      | indicator | groupName | Id    |
      |           | 10107     | 10107 |
      |           | 10108     | 10108 |
      |           | 10109     | 10109 |
      |           | 10110     | 10110 |
      |           | 10111     | 10111 |

  @complete
  Scenario: The label for grouping column
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And I see grouped rows:
      | indicator | groupName | Id |
      | +         | 1         | 1  |
      | +         | 2         | 2  |
      | +         | 3         | 3  |
      | +         | 4         | 4  |
      | +         | 5         | 5  |
      | +         | 6         | 6  |
    When Click "expand" for the 0 row
    Then I see grouped rows:
      | indicator | groupName | Id  |
      | -         | 1         | 1   |
      | +         | 101       | 101 |
      | +         | 102       | 102 |
      | +         | 103       | 103 |
      | +         | 104       | 104 |
      | +         | 105       | 105 |

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    When Click "expand" for row "101"
    Then There should be 3 sections loaded
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10101     | 10101 |
      |           | 10102     | 10102 |
      |           | 10103     | 10103 |
      |           | 10104     | 10104 |


  @complete
  Scenario: The grant total row for grouping column
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                         | id  | Beginning DR (Base) |
      | accountSection[30]-accountType[15]-accountCode[4] | [4] | [4]                 |
    And I have one grand total row in MounteBank
    When Presenting "grand total row"
    Then I see grouped rows:
      | indicator | groupName | Id |
      | +         | Total     | 1  |


  @complete
  Scenario: The children rows should be sorted by single column in completely loaded data
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[10] | [10] | [10]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 1 row
    And I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10101     | 10101 |
      |           | 10102     | 10102 |
      |           | 10103     | 10103 |
      |           | 10104     | 10104 |
    And Click to sort as "ASC" for column "Id"
    When Click to sort as "DESC" for column "Id"
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | +         | 102       | 102   |
      | -         | 101       | 101   |
      |           | 10110     | 10110 |
      |           | 10109     | 10109 |
    And The "Id" column sort indicator should be "desc"
    And There should be 3 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                       | id  | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[2] | [2] | [2]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 2 row
    And Click to sort as "ASC" for column "Id"
    And Click to sort as "DESC" for column "Id"
    When Click "expand" for the 4 row
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 102       | 102   |
      |           | 10202     | 10202 |
      |           | 10201     | 10201 |
      | -         | 101       | 101   |
      |           | 10102     | 10102 |
    And The "Id" column sort indicator should be "desc"

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                       | id  | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[2] | [2] | [2]                 |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 2 row
    And Click to sort as "ASC" for column "Id"
    And Click to sort as "DESC" for column "Id"
    And Click "expand" for the 4 row
    And I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 102       | 102   |
      |           | 10202     | 10202 |
      |           | 10201     | 10201 |
      | -         | 101       | 101   |
      |           | 10102     | 10102 |
    When And Click to sort as "ASC" for column "Id"
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10101     | 10101 |
      |           | 10102     | 10102 |
      | -         | 102       | 102   |
      |           | 10201     | 10201 |

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                       | id  | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[2] | [2] | [2]                 |
    And Presenting "grouping column present partial loaded children"
    And Click to sort as "ASC" for column "Id"
    And Click to sort as "DESC" for column "Id"
    When Click "expand" for the 0 row
    And Click "expand" for the 2 row
    And Click "expand" for the 1 row
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 102       | 102   |
      |           | 10202     | 10202 |
      |           | 10201     | 10201 |
      | -         | 101       | 101   |
      |           | 10102     | 10102 |
    And The "Id" column sort indicator should be "desc"

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[10] | [10] | [10]                |
    And Presenting "grouping column present partial loaded children"
    When Click "expand" for the 0 row
    And Click "expand" for the 2 row
    And Click "expand" for the 1 row
    And Click to sort as "ASC" for column "Id"
    When Click to sort as "DESC" for column "Id"
    And Click "collapse" for the 1 row
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | +         | 102       | 102   |
      | -         | 101       | 101   |
      |           | 10110     | 10110 |
      |           | 10109     | 10109 |
      |           | 10108     | 10108 |
    And The "Id" column sort indicator should be "desc"

  @complete
  Scenario: The children rows should be sorted by single column in lazily loaded data
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[20] | [20] | [20]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for row "1"
    And Click "expand" for row "101"
    When Click to sort as "ASC" for column "Id"
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10101     | 10101 |
      |           | 10102     | 10102 |
      |           | 10103     | 10103 |
      |           | 10104     | 10104 |
    And There should be 4 sections loaded
    And The "Id" column sort indicator should be "asc"

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[20] | [20] | [20]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 1 row
    And Click to sort as "ASC" for column "Id"
    When Click to sort as "DESC" for column "Id"
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10120     | 10120 |
      |           | 10119     | 10119 |
      |           | 10118     | 10118 |
      |           | 10117     | 10117 |
    And There should be 5 sections loaded
    And The "Id" column sort indicator should be "desc"

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[20] | [20] | [20]                |
    And Presenting "grouping column present partial loaded children"
    And Click to sort as "ASC" for column "Id"
    When Click to sort as "DESC" for column "Id"
    Then There should be 1 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[20] |    | s                   |
    And Presenting "grouping column present partial loaded children"
    And Click to sort as "ASC" for column "Id"
    And Click to sort as "DESC" for column "Id"
    And Click "expand" for the 0 row
    When Click "expand" for the 1 row
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10120     | 10120 |
      |           | 10119     | 10119 |
      |           | 10118     | 10118 |
      |           | 10117     | 10117 |
    And There should be 3 sections loaded


    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[20] | [20] | [20]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 1 row
    And Click "collapse" for the 0 row
    And Click to sort as "ASC" for column "Id"
    When Click "expand" for the 0 row
    Then I see grouped rows:
      | indicator | groupName | Id    |
      | -         | 1         | 1     |
      | -         | 101       | 101   |
      |           | 10101     | 10101 |
      |           | 10102     | 10102 |
      |           | 10103     | 10103 |
      |           | 10104     | 10104 |
    Then There should be 4 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id   | Beginning DR (Base) |
      | accountSection[1]-accountType[2]-accountCode[20] | [20] | [20]                |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 2 row
    And Click "expand" for the 1 row
    And Customer drags scroll bar by offset 60 with 2 times and wait loading section
    And Click to sort as "ASC" for column "Id"
    Then I see grouped rows:
      | indicator | groupName | Id    |
      |           | 10118     | 10118 |
      |           | 10119     | 10119 |
      |           | 10120     | 10120 |
      | -         | 102       | 102   |
      |           | 10201     | 10201 |
    Then There should be 6 sections loaded

    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                        | id | Beginning DR (Base) |
      | accountSection[1]-accountType[1]-accountCode[40] |    | s[40]               |
    And Presenting "grouping column present partial loaded children"
    And Click "expand" for the 0 row
    And Click "expand" for the 1 row
    And Customer drags scroll bar by offset 100 with 2 times and wait loading section
    And Click to sort as "ASC" for column "Id"
    When Click to sort as "DESC" for column "Id"
    And The default loading indicator should display on 0 items

#    Given I have the following partial loaded grouped data in MounteBank:
#      | groupName                                        | id   | Beginning DR (Base) |
#      | accountSection[1]-accountType[1]-accountCode[40] | [40] | f[40]               |
#    And Presenting "grouping column present partial loaded children"
#    And Click "expand" for row "1"
#    And Click "expand" for row "101"
#    And Customer drags scroll bar by offset 110 with 2 times and wait loading section
#    And Click to sort as "ASC" for column "Id"
#    When Click to sort as "DESC" for column "Id"
#    Then There should be 7 sections loaded

  @complete
  Scenario: The grouped row named with long characters shouldn't wrap
    Given Prepare the grid with no existing sorting column for "fully load":
      | groupName                                            | id     | activity | status | isGroupRow |
      | group1                                               | f1     | s1       | t1     | True       |
      | group1-chd1                                          | f1-1   | s1-1     | t1-1   | True       |
      | group1-chd1-chddddddddddddddddddddddddddddddddddddd1 | f1-1-1 | s1-1-1   | t1-1-1 | False      |
    When Click "expand" for row "group1"
    And Click "expand" for row "group1-chd1"
    Then The grouped row "group1-chd1-chddddddddddddddddddddddddddddddddddddd1" should not wrap

    Given I have the following grouped loans in MounteBank:
      | groupName   | id   | activity | isGroupRow |
      | group1      | f1   | s1       | True       |
      | group1-chd1 | f1-1 | s1-1     | False      |
      | group1-chd2 | f1-2 | s1-2     | False      |
    When Presenting "grouping column with pluggable indicator"
    Then The grouped row "group1" should not wrap


  @complete
  Scenario: The error handling when load section in grouping column
    Given I have the following partial loaded grouped data in MounteBank:
      | groupName                                       | id |
      | accountSection[1]-accountType[1]-accountCode[1] |    |
    And Presenting "grouping column error handling"
    When Click "expand" for the 0 row
    And Click "expand" for the 1 row
    Then The content "Failed to load data" should display in page
    And The content "groupingName:errorName" should display in page
    And The content "chunkIndex:0" should display in page

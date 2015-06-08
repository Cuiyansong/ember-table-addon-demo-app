Feature: Indicators for expanding and collapsing grouped rows
  In order to manage the parent/child relationships of large data sets
  As a user presented with a grid
  I need an intuitive set of controls

  @wip
  Scenario: Grouping column is presented as first column
    Given I have grouped loans
    When Presenting "grouping column"
    Then There are 3 columns
    And The 2 column is "First"
    And The 3 column is "Second"

  @wip
  Scenario: Grouped rows are presented
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column present grouped loans"
    Then I see grouped rows:
      | indicator | group_name | first | second |
      | +         | group1     | f1    | s1     |
      | +         | group2     | f2    | s2     |
      | +         | group3     | f3    | s3     |
      | +         | group4     | f4    | s4     |
      | +         | group5     | f5    | s5     |

  @wip
  Scenario: Default expansion indicator with fully loaded data
    Given There are 50 grouped loans
    When Presenting "grouping column"
    Then The row "row_parent" indicator should be "expand"
    When Click "expand" for row "row_parent"
    Then The row "row_parent" indicator should be "collapse"


  @wip
  Scenario: check grouped rows with collapse indicator
    Given I have the following grouped loans in MounteBank:
      | group_name  | first | second |
      | group1      | f1    | s1     |
      | group1-chd1 | f1-1  | s1-1   |
      | group1-chd2 | f1-2  | s1-2   |
      | group2      | f2    | s2     |
      | group3      | f3    | s3     |
      | group4      | f4    | s4     |
      | group5      | f5    | s5     |
    When Presenting "grouping column present grouped loans"
    And The row "group1" indicator should be "expand"
    Then I see grouped rows:
      | indicator | group_name  | first | second |
      | -         | group1      | f1    | s1     |
      | +         | group1-chd1 | f1-1  | s1-1   |
      | +         | group1-chd2 | f1-2  | s1-2   |
      | +         | group2      | f2    | s2     |
      | +         | group3      | f3    | s3     |
      | +         | group4      | f4    | s4     |
      | +         | group5      | f5    | s5     |


  @wip
  Scenario: Expand grouped row with partial loaded children loans
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column present partial loaded children"
    And The row "group1" indicator should be "expand"
    Then There should be 2 sections loaded
    When Customer drags scroll bar by offset 60 with 1 times
    Then There should be 3 sections loaded

  @wip
  Scenario: Expand all grouped rows with unlimited level
    Given I have the following grouped loans in MounteBank:
      | group_name       | first  | second |
      | group1           | f1     | s1     |
      | group1-chd1      | f1-1   | s1-1   |
      | group1-chd1-chd1 | f1-1-1 | s1-1-1 |
      | group1-chd1-chd2 | f1-1-2 | s1-1-2 |
      | group1-chd2      | f1-2   | s1-2   |
      | group1-chd2-chd1 | f1-2-1 | s1-2-1 |
      | group1-chd2-chd2 | f1-2-2 | s1-2-2 |
      | group2           | f2     | s2     |
      | group2-chd1      | f2-1   | s2-1   |
      | group2-chd1-chd1 | f2-1-1 | s2-1-1 |
      | group2-chd1-chd2 | f2-1-2 | s2-1-2 |
      | group2-chd2      | f2-2   | s2-2   |
      | group2-chd2-chd1 | f2-2-1 | s2-2-1 |
      | group2-chd2-chd2 | f2-2-2 | s2-2-2 |
      | group3           | f3     | s3     |
      | group3-chd1      | f3-1   | s3-1   |
      | group3-chd1-chd1 | f3-1-1 | s3-1-1 |
      | group3-chd1-chd2 | f3-1-2 | s3-1-2 |
      | group3-chd2      | f3-2   | s3-2   |
      | group3-chd2-chd1 | f3-2-1 | s3-2-1 |
      | group3-chd2-chd2 | f3-2-2 | s3-2-2 |
      | group4           | f4     | s4     |
      | group4-chd1      | f4-1   | s4-1   |
      | group4-chd1-chd1 | f4-1-1 | s4-1-1 |
      | group4-chd1-chd2 | f4-1-2 | s4-1-2 |
      | group4-chd2      | f4-2   | s4-2   |
      | group4-chd2-chd1 | f4-2-1 | s4-2-1 |
      | group4-chd2-chd2 | f4-2-2 | s4-2-2 |
      | group5           | f5     | s5     |
      | group5-chd1      | f5-1   | s5-1   |
      | group5-chd1-chd1 | f5-1-1 | s5-1-1 |
      | group5-chd1-chd2 | f5-1-2 | s5-1-2 |
      | group5-chd2      | f5-2   | s5-2   |
      | group5-chd-chd1  | f5-2-1 | s5-2-1 |
      | group5-chd2-chd2 | f5-2-2 | s5-2-2 |
    When Presenting "grouping column present grouped loans"
    And Expand all contraction rows
    Then I see grouped rows:
      | indicator | group_name       | first  | second |
      | -         | group1           | f1     | s1     |
      | -         | group1-chd1      | f1-1   | s1-1   |
      |           | group1-chd1-chd1 | f1-1-1 | s1-1-1 |
      |           | group1-chd1-chd2 | f1-1-2 | s1-1-2 |
      | -         | group1-chd2      | f1-2   | s1-2   |
      |           | group1-chd2-chd1 | f1-2-1 | s1-2-1 |
      |           | group1-chd2-chd2 | f1-2-2 | s1-2-2 |
      | -         | group2           | f2     | s2     |
      | -         | group2-chd1      | f2-1   | s2-1   |
      |           | group2-chd1-chd1 | f2-1-1 | s2-1-1 |
      |           | group2-chd1-chd2 | f2-1-2 | s2-1-2 |
      | -         | group2-chd2      | f2-2   | s2-2   |
      |           | group2-chd2-chd1 | f2-2-1 | s2-2-1 |
      |           | group2-chd2-chd2 | f2-2-2 | s2-2-2 |
      | -         | group3           | f3     | s3     |
      | -         | group3-chd1      | f3-1   | s3-1   |
      |           | group3-chd1-chd1 | f3-1-1 | s3-1-1 |
      |           | group3-chd1-chd2 | f3-1-2 | s3-1-2 |
      | -         | group3-chd2      | f3-2   | s3-2   |
      |           | group3-chd2-chd1 | f3-2-1 | s3-2-1 |
      |           | group3-chd2-chd2 | f3-2-2 | s3-2-2 |
      | -         | group4           | f4     | s4     |
      | -         | group4-chd1      | f4-1   | s4-1   |
      |           | group4-chd1-chd1 | f4-1-1 | s4-1-1 |
      |           | group4-chd1-chd2 | f4-1-2 | s4-1-2 |
      | -         | group4-chd2      | f4-2   | s4-2   |
      |           | group4-chd2-chd1 | f4-2-1 | s4-2-1 |
      |           | group4-chd2-chd2 | f4-2-2 | s4-2-2 |
      | -         | group5           | f5     | s5     |
      | -         | group5-chd1      | f5-1   | s5-1   |
      |           | group5-chd1-chd1 | f5-1-1 | s5-1-1 |
      |           | group5-chd1-chd2 | f5-1-2 | s5-1-2 |
      | -         | group5-chd2      | f5-2   | s5-2   |
      |           | group5-chd-chd1  | f5-2-1 | s5-2-1 |
      |           | group5-chd2-chd2 | f5-2-2 | s5-2-2 |

  @wip
  Scenario: The expand indicator should be pluggable
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column with pluggable indicator"
    Then I see grouped rows:
      | indicator | group_name | first | second |
      | >         | group1     | f1    | s1     |
      | >         | group2     | f2    | s2     |
      | >         | group3     | f3    | s3     |
      | >         | group4     | f4    | s4     |
      | >         | group5     | f5    | s5     |

  @wip
  Scenario: The collapse indicator should be pluggable
    Given I have the following grouped loans in MounteBank:
      | group_name  | first | second |
      | group1      | f1    | s1     |
      | group1-chd1 | f1-1  | s1-1   |
      | group1-chd2 | f1-2  | s1-2   |
      | group2      | f2    | s2     |
      | group3      | f3    | s3     |
      | group4      | f4    | s4     |
      | group5      | f5    | s5     |
    When Presenting "grouping column with pluggable indicator"
    Then I see grouped rows:
      | indicator | group_name  | first | second |
      | *         | group1      | f1    | s1     |
      | >         | group1-chd1 | f1-1  | s1-1   |
      | >         | group1-chd2 | f1-2  | s1-2   |
      | >         | group2      | f2    | s2     |
      | >         | group3      | f3    | s3     |
      | >         | group4      | f4    | s4     |
      | >         | group5      | f5    | s5     |

  @wip
  Scenario: The grouping column should be auto resize
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column present grouped loans"
    Then The "group_name" column width should be 20 pixel
    When Expand all contraction rows
    Then The "group_name" column width should be 70 pixel
    When Collapse all expanded rows
    Then The "group_name" column width should be 20 pixel


  @wip
  Scenario: Expand grouped row with partial loaded
    Given Given I have 200 grouped loans
    Then There should be 2 sections loaded
    When Customer drags scroll bar by offset 60 with 1 times
    Then There should be 3 sections loaded

  @wip
  Scenario: The default loading indicator should display when partial load grouped loans
    Given I have 200 grouped loans
    When Customer drags scroll bar by offset 60 with 1 times
    Then The default loading indicator should display

  @wip
  Scenario: The default loading indicator should display when partial load children loans
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column present partial loaded children"
    And The row "group1" indicator should be "expand"
    When Customer drags scroll bar by offset 60 with 1 times
    Then The default loading indicator should display

  @wip
  Scenario: The custom loading indicator should display when partial load grouped loans
    Given I have 200 grouped loans
    When Customer drags scroll bar by offset 60 with 1 times
    Then The "custom" loading indicator should display

  @wip
  Scenario: The default loading indicator should display when partial load children loans
    Given I have the following grouped loans in MounteBank:
      | group_name | first | second |
      | group1     | f1    | s1     |
      | group2     | f2    | s2     |
      | group3     | f3    | s3     |
      | group4     | f4    | s4     |
      | group5     | f5    | s5     |
    When Presenting "grouping column present partial loaded children"
    And The row "group1" indicator should be "expand"
    When Customer drags scroll bar by offset 60 with 1 times
    Then The "custom" loading indicator should display

  @wip
  Scenario: The grouping column should be fixed
    Given I have grouped loans
    When Presenting "grouping column"
    Then The "grouping" column width should be 150 pixel
    Then The index 0 should be "grouping" column
    When The user drags the "grouping" on column to "right" with 100 pixel
    Then The "grouping" column width should be 150 pixel
    When Reorder an inner column "grouping" header to "right" with 300 pixel
    Then The index 0 should be "grouping" column
Feature: enforcing naming standards on defined resources

    Scenario Outline: Naming standard on all available resources
        Given I have <resource_name> defined
        When it contains <name_key>
        Then its value must match the "hashitalk-iac-tdd-.*" regex

    Examples:
    | resource_name           | name_key |
    | AWS EC2 instance        | name     |
    | AWS ELB resource        | name     |
    | AWS Auto-Scaling Group  | name     |
    | aws_key_pair            | key_name |
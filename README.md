#  GithubPlayground

## Overview

This is a project for demonstration purpose. Fetching data, parsing model entities and navigation will be included.

## Features

1. `FetchUser` Module
    - A module enables users to search a Github user by name
    - Not found notification and textfield shaking animation 
    - Navigigation to "UserInfo" Module

2. `UserInfo` Module
    - A module to display the profile of a user that being searched
    - **Pull to Refresh 
    
3. `ListUser` Module
    - A module to display a list of the uesr's followers and followings
    - Ability to navigate another user's profile

## Architecture
- `UIKit` ,No storyboard, Layout by pure-code using [SnapKit](https://github.com/SnapKit/SnapKit)
- Each `Module` represents a view, including its UI, network activity, and navigation.
- Each `Service` represents an independent utility that could be injected to module, for here we just have the `NetworkService`. We could have additonal services such as `StorageService`, `AuthenticationService` for this part.
- `Utils` Folder for putting `extensions`, for here we have `UIFont` and `UIColor` extentions
- `VIPER`, `MVVM` Has been considered. Finally I chose `MVC+ Router` because it is **fast** and **easy to implement** 

##  Worth to mention
- Dependency Injection using [Swinject](https://github.com/Swinject/Swinject) for injecting **NetworkService** to controlles
- File-based Network service using `Generics` and `Struct`, rather than `Enum` , for easy configuration and management. 
- Custom Font Using `Poppins`
- `PromiseKit` for async operations

## Keep Track and Log 
---
- 22/Feb, 01:00 to 02:00, 1hr, understand the requirement and draft the design
- 22/Feb, 02:00 to 02:30, 0.5hr, bootstrap the project
22/Feb, 
- 22/Feb, 12:00 to 15:00, 3hr, utilities(network, font, bugfix) and complete `FeatchUser` Module
- 22/Feb, 12:00 to 15:00, 3hr, utilities(network, font, bugfix) and complete `FeatchUser` Module
- 22/Feb, 18:00 to 21:00, 3hr, complete the `UserInfo` Module and bug fixing
- 23/Feb, 04:00 to 07:00, 3hr, complete the `ListUser` Module and bugfixing 
- 23/Feb, 10:00 to 11:00, 1hr, write `README` and do submission


totoal: **14.5hr** actual work hours


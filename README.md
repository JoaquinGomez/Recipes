# Recipes

### Summary: Include screen shots or a video of your app highlighting its features

[![Please watch the video](https://drive.google.com/thumbnail?id=1OPtlABi0fxq9sYQruZvPvcnPXWeOuYTJ)](https://drive.google.com/file/d/1OPtlABi0fxq9sYQruZvPvcnPXWeOuYTJ/view?usp=sharing)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I prioritized having a clean architecture, ensuring proper dependency injection, single responsibility, and composition. This resulted in an easy to read and reasonate about code, that is also easy to test. I also prioritized testing all the objects except the view.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

#### Allocation Based on Commit History (total 13:31 hours):

| Commit Hash | Date | Description | Duration |
|------------|------|-------------|----------|
| 112d75b | Mon Jan 27 | Image cache and fetching | 2:35:37 |
| da4cc79 | Thu Jan 30 | Load image and optimizations for its loading and the cache (also did testing and recorded demo) | 2:07:12 |
| 94a7ad6 | Sun Jan 26 | Rename files to reflect MVVM, create Recipes Service, and introduce concurrency handling | 1:00:51 |
| c8e93d6 | Mon Jan 27 | Add Feature Flag Provider for easier testing and proper UI updates | 0:51:36 |
| ffe718b | Mon Jan 27 | Real implementation of RecipesService, parsing model update, project re-organization | 0:51:30 |
| b520045 | Sat Feb 1 | Test RecipesViewModel | 0:51:20 |
| 7f75eb5 | Sat Feb 1 | Decouple ImageStorage from NSManagedObject called Item and test ImageCache | 0:45:15 |
| c7346c9 | Sat Feb 1 | Test ImageProvider | 0:42:16 |
| bee933c | Sat Feb 1 | Test RecipesService | 0:39:13 |
| 83659ab | Sun Jan 26 | Populate UI with Recipe model | 0:34:38 |
| aa88055 | Sat Feb 1 | Assign timestamp on cache instead of storage and test ImageStorage | 0:34:14 |
| f06cf58 | Sun Jan 26 | Git ignore file | 0:25:17 |
| 01d777a | Sun Jan 26 | Layout for minimal UI requirements, tested with dynamic type, orientation, and color scheme variants | 0:21:00 |
| 8ddea75 | Sun Jan 26 | Handle error and empty states (tested by changing the service's response) | 0:18:13 |
| f2aa196 | Thu Jan 30 | Proper cache expiration value | 0:14:26 |
| f07f9f5 | Thu Jan 30 | Make RecipesService and ImageProvider testable | 0:13:36 |
| b081ff7 | Sun Jan 26 | README update with template | 0:06:52 |
| c3825f0 | Sat Feb 1 | Make ImageStorage testable | 0:05:39 |
| 8968051 | Mon Jan 27 | Remove isFirstLoad and use nil checks instead | 0:05:15 |
| 4a37fb0 | Sat Feb 1 | Move Recipes to new file and move RecipesViewModel instantiation to new factory | 0:04:35 |
| 42b6cee | Sat Feb 1 | Delete UI tests files and target | 0:01:27 |
| 8994a1e | Sun Jan 26 | Create brand new iOS App Xcode project with CoreData, SwiftUI, and Tests included | 0:00:49 |
| 9463aed | Sat Feb 1 | Move Recipes to new file and move RecipesViewModel instantiation to new factory | 0:00:15 |
| 388ff7e | Sat Feb 1 | Empty commit to mark when work was resumed | 0:00:00 |
| 7faac52 | Thu Jan 30 | Empty commit to mark when work was resumed | 0:00:00 |
| 6acdd2e | Mon Jan 27 | Empty commit to mark when work was resumed | 0:00:00 |
| 1163077 | Mon Jan 27 | Empty commit to mark when work was resumed | 0:00:00 |
| a6d10ad | Sun Jan 26 | Initial commit | 0:00:00 |

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

I used CoreData as the storage for cache. It might be overkill, and I am storing the data, not just the url, timestamp etc.
This can affect performance (even considering that I enabled `allowsExternalBinaryDataStorage`), ideally I should save them in the disk and just keep a path to the file, but I was alreasy spending too much time on the project.
At the same time I believe I am consistenly using the same context and I don't access it from different threads, which makes me fell confident that my cache won't have concurrency issues like the readers-writers problem (still this could be avoided by a proper concurrency management when accessing the files).
I abstracted the storage interface to allow for an easy implementation replacement without having to modify anything else in the code.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I didn't focus much on the UI, since I expect that would be more designer-oriented. Also I relied on the refresh control from `List` to avoid doing more UI work, and I showed the empty and error states inside rows of the list. That could have been better.
This wasn't a requirement, but dependency injection could be used in the view to enable UI testing.
I try to avoid singletons, but I used one for the feature flag provider. Since this is not a requirement I decided to not worry too much about it.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

N/A

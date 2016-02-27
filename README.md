- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [x] Infinite scroll
- [x] Reusable TweetsViewController programmatically initialized for HomeTimeline and MentionsTimeline
- [x] Tap on user profile image in "home" or "mentions" view to go to profile page.  They share the same controller class under the hood.
- [x] Used reusable xib for profile view
- [x] Number and date formatting throughout

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://cloud.githubusercontent.com/assets/1156702/13371327/6f1d14c2-dcd8-11e5-869e-0419aa3bf14b.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- I knew incorporating the v1 twitter app into the new hamburger framework would be a challenge.  So I first built out a working, standalone hamburger menu framework and optimized the framework before trying to incorporate.
- Unfortunately didn't have time to get to the optionals.  Will try to circle back. Have a good idea about how to implement all of them.

## License

    Copyright [2016] [zskyfly productions]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# TTL

A WoW addon to estimate the remaining time your target will be alive.

TTL is a light-weight addon designed to do one thing: show you about how long your current target is going to be alive.

The UI consists of a single small window which shows how much time, in minutes and seconds, the mob will stay alive if it continues to take
the same average dps it's currently taking. If you see "...", this means the addon is still calculating what the time to live is, or the mob
is taking no damage so the time is essentially 'infinite'. 

![TTL](/../screenshots/screenshots/ttl.png)

Note that the UI will only appear when you are targetting a hostile entity. Neutral entities such as training dummies and critters do not show the UI, and certain scripted creatures (such as the spawnable demons in the Demon Hunter order hall) are flagged in a special way by Blizzard causing this addon not to detect them.

# Installation

To install the addon from this github page, follow these steps:

1: Click the "Clone or Download" button and select "Download ZIP".

2: Unzip the archive into your WoW installation/Interface/Addons folder.

3: **IMPORTANT**: RENAME the folder to "TTL", removing the branch name (e.g. "-master"). The addon will not appear available in WoW if this step is skipped.

The addon will soon be available via curse.com once it's been thoroughly tested and a few features are added.

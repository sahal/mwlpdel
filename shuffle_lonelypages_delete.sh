#!/bin/sh
# ./shuffle_lonelypages_delete.sh
# desc: helper script (really a oneliner) that creates a list of a "random"
#       subset (25) of spam articles (lonelypages_delete) for testing
# by: Sahal Ansari (github@sahal.info)

shuf lonelypages_delete | head -25 > lonelypages_delete-shuf


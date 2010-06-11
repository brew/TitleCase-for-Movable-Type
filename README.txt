Title Case for Movable Type
http://www.lowest-common-denominator.com/2008/05/title_case_for_movable_type.php

Brook Elgie <brew@lowest-common-denominator.com>
Version 1.1

Title Case for Movable Type is an MT enabled version of John Gruber's Title Case.
http://daringfireball.net/2008/05/title_case

License: http://www.opensource.org/licenses/mit-license.php

====================================

Description:
Smart and appropriate capitalisation of entry titles.

====================================

Installation:
Place TitleCase.pl in the plugins directory of your Movable Type installation.

* (mthome)/plugins/TitleCase.pl

====================================

Usage:
To use TitleCase on your entry titles, add the global filter, titlecase="1". For example:

<mt:EntryTitle titlecase="1" />

This will process the title through TitleCase to provide smart capitalisation.

====================================

Updates:
1.0 Initial release
1.1 Removed deprecated syntax for MT4 (note: will no longer work with previous versions of MT)

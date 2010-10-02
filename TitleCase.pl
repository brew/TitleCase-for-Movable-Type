# ---------------------------------------------------------------------------
# Title Case for Movable Type
# Smart and appropriate capitalisation of entry titles.
#
# Release 1.1
# 23nd May 2008
#
# This MT version: Brook Elgie <hi@lowest-common-denominator.com>
# http://www.lowest-common-denominator.com/2008/05/title_case_for_movable_type.php
#
# Original Perl version: John Gruber
# http://daringfireball.net/2008/05/title_case
# 
# ---------------------------------------------------------------------------
# License: http://www.opensource.org/licenses/mit-license.php
# ---------------------------------------------------------------------------

package MT::Plugin::TitleCase;

use strict;
use warnings;
use utf8;
use base qw( MT::Plugin );
use vars qw($VERSION);
$VERSION = '1.1';

# ---------------------------------------------------------------------------
my @small_words = qw(a an and as at but by en for if in of on or the to v[.]? via vs[.]?);
# ---------------------------------------------------------------------------

my $small_re = join '|', @small_words;

my $plugin = MT::Plugin::TitleCase->new({
	name => 'Title Case',
  description => "<MT_TRANS phrase=\"Provides smart and appropriate capitalisation of entry titles.\">",
  doc_link => 'http://www.lowest-common-denominator.com/2008/05/title_case_for_movable_type.php',
  author_name => 'Brook Elgie',
  author_link => 'http://www.lowest-common-denominator.com/',
  version => $VERSION,
});
MT->add_plugin($plugin);
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        tags => {
            modifier => {
                'titlecase' => \&titlecase,
            },
        },
    });
}

sub titlecase{
	my ($str, $param, $ctx) = @_;
	if ($param eq '1') {
		my $value = $ctx->stash('tag');
		my $line = "";
		my @values = split(/( [:.;?!][ ] | (?:[ ]|^)["“] )/x, $str);
	  foreach my $val (@values) {
      $val =~ s{
      	      \b(
      	          [[:alpha:]]
      	          [[:lower:].'’]*
      	      )\b
       }{
        my $w = $1;
        # Skip words with inline dots, e.g. "del.icio.us" or "example.com"
         ($w =~ m{ [[:alpha:]] [.] [[:alpha:]] }x) ? 
             $w :
            "\u\L$w";
       }exg;
        
      		# Lowercase our list of small words:
  	      $val =~ s{\b($small_re)\b}{\L$1}igo;
 	      	# If the first word in the title is a small word, then capitalize it:
  	      $val =~ s{\A([[:punct:]]*)($small_re)\b}{$1\u$2}igo;
  	      # If the last word in the title is a small word, then capitalize it:
  	      $val =~ s{\b($small_re)([[:punct:]]*)\Z}{\u$1$2}igo;
 
	      	# Append current substring to output
  				$line .= $val;
	  }
	  # Special Cases:
	  $line =~ s{ V(s?)\. }{ v$1. }g;        									# "v." and "vs.":
	 	$line =~ s{(['’(&#8217;)])S\b}{$1s}g;            				# 'S (otherwise you get "the SEC'S decision")
	 	$line =~ s{(['’(&#8217;)])T\b}{$1t}g;            				# 'T (otherwise you get "I love Widon'T")
	  $line =~ s{\b(AT&T|Q&A|AT&amp;|Q&amp;A)\b}{\U$1}ig;     # "AT&T" and "Q&A", which get tripped up by
	                                          								# self-contained small words "at" and "a"
		# If the line contains entities, lowercase them:
		$line =~ s{(&(a|A)mp;|&)(\w+;)}{$1\L$2\L$3}ig;
		
	  return $line;
	} else {
		return $str;
	}
}


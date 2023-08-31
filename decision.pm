# Package with decision of task.
package decision;

use URI;

#
# This function finds fit pattern among pattern list,
# then parses url-path by fit pattern.
# 
# my %res = ParsePath($url, @patterns);
#
# Result example:
# $res = (
#   index => 1,
#   hash => {
#       'storage' => 'order',
#       'pk' => '123',
#       'op' => 'update'
#   }
# )
#
sub ParseUrlPath {
    my ($url, @patterns) = @_;

    my $url_path = URI->new($url)->path();

    my $index = 0;
    for (@patterns) {
        my $regexp = _generateRegExp($_);

        if ( $url_path =~ m/$regexp/ ) {
            my %hash =  %+;
            return (
                index => $index, 
                hash => \%hash,
            );
        }

        $index++;
    }

    return ();
}

#
# This function generates regexp by url-path pattern.
#
# Notice: internal function.
# 
# my regexp = _generateRegExp($pattern);
#
sub _generateRegExp {
    my @parts = split('/', shift);

    # beginning of regexp
    my $regexp = qq|\^|;

    # build regexp
    for (@parts) {
        if ( $_ eq "" ) {
            next;
        }

        $regexp .= qq|\/|;

        if ( $_ =~ m/^\:(.+)/ ) {
            $regexp .= qq|(\?<$1>[a-z0-9_\:-]+)|;
            next;
        }

        $regexp .= qq|$_|;
    }

    # end of regexp
    $regexp .= qq|\$|;

    return qr|$regexp|;
}

1;

use strict;
use warnings;

use Test::More;

use lib ".";
use lib "../";
use decision;

my %test_cases = (
    '1st case' => {
        url      => 'http://localhost:8080/api/v1/order/123/update',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 2,
            hash => {
                'storage' => 'order',
                'pk' => '123',
                'op' => 'update',
            },
        }
    },
    '2nd case' => {
        url      => 'http://localhost:8080/api/v1/order/123/raw',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 1,
            hash => {
                'storage' => 'order',
                'pk' => '123',
            },
        }
    },
    '3rd case' => {
        url      => 'http://localhost:8080/api/v1/order/123',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 3,
            hash => {
                'storage' => 'order',
                'pk' => '123',
            },
        }
    },
    '4th case' => {
        url      => 'http://localhost:8080/api/v1/:order/13',
        patterns => [
            '/api/v1/:storage/:pk/raw',
            '/api/v1/:storage/:pk/:op',
            '/api/v1/:storage/:pk',
        ],
        expected => {
            index => 3,
            hash => {
                'storage' => ':order',
                'pk' => '13',
            },
        }
    }
);

# loop with test cases
for my $case_name (keys %test_cases) {
    my $url = $test_cases{$case_name}{url};
    my $patterns = $test_cases{$case_name}{patterns};
    my $expected = $test_cases{$case_name}{expected};

    my %res = decision::ParseUrlPath($url, @{$patterns || []});

    ok(eq_hash($res{hash}, $expected->{hash}), $case_name);
}

done_testing;

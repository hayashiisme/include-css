#!/usr/bin/perl
#
# include css file to html file
#
#
use strict;
use HTML::TreeBuilder;
use HTML::Element;

my $html = '';
while(defined(my $line = <STDIN>)){
    $html .= $line;
}

my $root = HTML::TreeBuilder->new;
$root->no_space_compacting(1);
$root->no_expand_entities(1);
$root->ignore_unknown(0);
$root->parse($html);

my $link = $root->look_down('_tag'=>'link', 'rel'=>'stylesheet');
if(ref $link eq 'HTML::Element'){
    my $css = $link->attr('href');
    my $styles = '';
    open(FILE, "< $css");
    read(FILE, $styles, (-s "$css"));
    close(FILE);
    if($styles ne ''){
        my $e = $root->look_down('_tag'=>'style');
        if(ref $e ne 'HTML::Element'){
            $e = HTML::Element->new('style');
            $link->replace_with($e);
        }else{
            $link->delete;
        }
        $e->push_content("\n$styles\n");
    }
}

print $root->as_HTML('<>&', ' ', {});
exit;



# $Id$

package RebuildOncetimePerDay::Plugin;

use strict;
use warnings;
use Data::Dumper;

sub plugin {
    return MT->component('RebuildOncetimePerDay');
}

sub _log {
    my ($msg) = @_;
    return unless defined($msg);
    my $prefix = sprintf("%s:%s:%s: %s", caller());
    $msg = $prefix . $msg if $prefix;
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
    return;
}

sub get_config {
    my $plugin = plugin();
    my ($key, $blog_id) = @_;
    die "no blog id." unless $blog_id;
    my $scope = $blog_id ? 'blog:'.$blog_id : 'system';
    my %plugin_param;
    $plugin->load_config(\%plugin_param, $scope);
    my $value = $plugin_param{$key};
    $value;
}

sub blog_rebuild_oncetime_per_day{
    require MT::Blog;
    my $blogs = MT::Blog->load_iter or die "no blogs loading";
    CHECKBLOG: while (my $blog = $blogs->()) {
        my $blog_id = $blog->id;
        # check for enable this plugin on each blog.
        my $check_enable = get_config('rebuild_oncetime_per_day_enable', $blog_id);
        next CHECKBLOG unless $check_enable;

        require MT::Util;
        my $ts = MT::Util::epoch2ts( $blog, time() );
        my ($year, $month, $today, $local_hour, $local_min) = unpack ('A4A2A2A2A2', $ts);
        my $lastdate  = get_config('rebuild_oncetime_per_day_lastdate', $blog_id);
        my $starttime = get_config('rebuild_oncetime_per_day_starttime', $blog_id);

        unless ($starttime){
            rebuild_oncetime_per_day($blog_id);
        } else {
            if ($today != $lastdate) {
                die 'Format was worg: starttime' unless $starttime =~ m/\d\d:\d\d/;
                my ($starttime_hour, $starttime_min) = split(/:/, $starttime);

                my $local_total = $local_min + ($local_hour * 60);
                my $start_total = $starttime_min + ($starttime_hour * 60);

                if ($start_total <= $local_total) {
                    my $plugin = plugin();
                    $plugin->set_config_value('rebuild_oncetime_per_day_lastdate', $today, 'blog:'.$blog_id);
                    rebuild_oncetime_per_day($blog_id);
                }
            }
        }
    }
    1;
}

sub website_rebuild_oncetime_per_day{
    require MT::Website;
    my $websites = MT::Website->load_iter or die "no websites loading";
    CHECKBLOG: while (my $website = $websites->()) {
        my $website_id = $website->id;
        # check for enable this plugin on each blog.
        my $check_enable = get_config('rebuild_oncetime_per_day_enable', $website_id);
        next CHECKBLOG unless $check_enable;

        require MT::Util;
        my $ts = MT::Util::epoch2ts( $website, time() );
        my ($year, $month, $today, $local_hour, $local_min) = unpack ('A4A2A2A2A2', $ts);
        my $lastdate  = get_config('rebuild_oncetime_per_day_lastdate',  $website_id);
        my $starttime = get_config('rebuild_oncetime_per_day_starttime', $website_id);

        unless ($starttime){
            rebuild_oncetime_per_day($website_id);
        } else {
            if ($today != $lastdate) {
                die 'Format was worg: starttime' unless $starttime =~ m/\d\d:\d\d/;
                my ($starttime_hour, $starttime_min) = split(/:/, $starttime);

                my $local_total = $local_min     + ($local_hour * 60);
                my $start_total = $starttime_min + ($starttime_hour * 60);

                if ($start_total <= $local_total) {
                    my $plugin = plugin();
                    $plugin->set_config_value('rebuild_oncetime_per_day_lastdate', $today, 'blog:'.$website_id);
                    rebuild_oncetime_per_day($website_id);
                }
            }
        }
    }
    1;
}

sub rebuild_oncetime_per_day {
    my ($blog_id) = @_;
    my $check_enable = get_config('rebuild_oncetime_per_day_enable', $blog_id);
    return unless ($check_enable);
    my $target_template_ids_string = get_config('rebuild_oncetime_per_day_target_template_ids', $blog_id);
    my @target_template_ids = split(/, */, $target_template_ids_string);

    use MT::Template;
    use MT::FileInfo;
    use MT::WeblogPublisher;
    foreach my $id (@target_template_ids) {
        my $tmpl = MT::Template->load($id);
        next unless ($tmpl);
        my $tmpl_blog_id = $tmpl->blog_id;
        next if ($blog_id != $tmpl_blog_id);
        my @fileinfos = MT::FileInfo->load({template_id=>$id});
        next if (! @fileinfos);
        foreach my $fileinfo (@fileinfos) {
            my $file = $fileinfo->file_path;
            unlink($file);
            my $wp = MT::WeblogPublisher->new;
            $wp->rebuild_from_fileinfo($fileinfo);
        }
    }
    1;
}

#----- Task
sub do_rebuild_oncetime_per_day {
    blog_rebuild_oncetime_per_day();
    website_rebuild_oncetime_per_day();
    1;
}


1;

package App::ZofCMS::Plugin::InstalledModuleChecker;

use warnings;
use strict;

our $VERSION = '0.0103';

sub new { bless {}, shift }
sub process {
    my ( $self, $t, $q, $config ) = @_;

    my $modules = delete $t->{plug_installed_module_checker};

    $modules = delete $config->conf->{plug_installed_module_checker}
        unless defined $modules;

    return
        unless defined $modules;

    my @results;
    for ( @$modules ) {
        eval "use $_";
        if ( $@ ) {
            push @results, { info => "$_ IS NOT INSTALLED: $@" }; 
        }
        else {
            push @results, { info => "$_ IS INSTALLED [version " . $_->VERSION . " ]" };
        }
    }
    $t->{t}{plug_installed_module_checker} = \@results;
}

1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Plugin::InstalledModuleChecker - utility plugin to check for installed modules on the server

=head1 SYNOPSIS

In ZofCMS Template or Main Config File:

    plugins => [
        qw/InstalledModuleChecker/,
    ],

    plug_installed_module_checker => [
        qw/ Image::Resize
            Foo::Bar::Baz
            Carp
        /,
    ],

In HTML::Template template:

    <ul>
        <tmpl_loop name='plug_installed_module_checker'>
        <li>
            <tmpl_var escape='html' name='info'>
        </li>
        </tmpl_loop>
    </ul>

=head1 DESCRIPTION

The module is a utility plugin for L<App::ZofCMS> that provides means to check for whether
or not a particular module is installed on the server and get module's version if it is
installed.

The idea for this plugin came to me when I was constantly writing "little testing scripts"
that would tell me whether or not a particular module was installed on the crappy
server that I have to work with all the time.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

=head1 FIRST-LEVEL ZofCMS TEMPLATE AND MAIN CONFIG FILE KEYS

=head2 C<plugins>

    plugins => [
        qw/InstalledModuleChecker/,
    ],

B<Mandatory>. You need to include the plugin in the list of plugins to execute.

=head2 C<plug_installed_module_checker>

    plug_installed_module_checker => [
        qw/ Image::Resize
            Foo::Bar::Baz
            Carp
        /,
    ],

B<Mandatory>. Takes an arrayref as a value.
Can be specified in either ZofCMS Template or Main Config File; if set in
both, the value in ZofCMS Template takes precedence. Each element of the arrayref
must be a module name that you wish to check for "installedness".

=head1 OUTPUT

    <ul>
        <tmpl_loop name='plug_installed_module_checker'>
        <li>
            <tmpl_var escape='html' name='info'>
        </li>
        </tmpl_loop>
    </ul>

Plugin will set C<< $t->{t}{plug_installed_module_checker} >> (where C<$t> is ZofCMS Template
hashref) to an arrayref of hashrefs; thus, you'd use a C<< <tmpl_loop> >> to view the info.
Each hashref will have only one key - C<info> - with information about whether or
not a particular module is installed.

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://haslayout.net/>, L<http://zoffix.com/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-installedmodulechecker at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-InstalledModuleChecker>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::InstalledModuleChecker

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-InstalledModuleChecker>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-InstalledModuleChecker>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-InstalledModuleChecker>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-InstalledModuleChecker/>

=back



=head1 COPYRIGHT & LICENSE

Copyright 2009 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut


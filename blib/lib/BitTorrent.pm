package BitTorrent;

use 5.008007;
use strict;
use warnings;
use LWP::Simple;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use BitTorrent ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION		= '0.01';
our $TorrentScrape	= "/var/lib/perl/torrent-checker.php";


sub new(){
	
	my $self			= bless {}, shift;
	my $url				= shift;
	$self->{torrent}	= $url;		# later check if torrent file via http head status

	return $self;
		
}; # new()


sub getHealth(){

	my $self			= shift;
	my $torrent			= $self->{torrent};

	# init
	my $Hash = ();
	my %Hash = ();

	# get torrent
	my $random			= int(rand(100000)+1);
	my $TorrentStore	= "/tmp/$random.torrent";
	getstore($torrent, $TorrentStore);
	
	# scrape torrent
	my $returnVal		= `php $TorrentScrape $TorrentStore`;
	
	# extract infos
	my @SeederLeecher	= split('#', $returnVal);
	my $Seeder			= $SeederLeecher[0];
	my $Leecher			= $SeederLeecher[1];
	
	$Seeder				=~ s/^\s+//;
	$Seeder				=~ s/\s+$//;
	$Leecher			=~ s/^\s+//;
	$Leecher			=~ s/\s+$//;

	$Hash->{seeder}		= $Seeder;
	$Hash->{leecher}	= $Leecher;


	return $Hash;

}; # sub sub getHealth(){



# Preloaded methods go here.

1;
__END__


=head1 NAME

BitTorrent - Perl extension for extracting, publishing and maintaining BitTorrent related things 

=head1 SYNOPSIS

  use BitTorrent;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for BitTorrent, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Marc Qantins, E<lt>qantins@gmail.com<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by M. Quantins, Sebastian Enger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut

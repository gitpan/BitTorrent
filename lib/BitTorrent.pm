package BitTorrent;

use 5.008007;
use strict;
use warnings;
use LWP::Simple;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	getHealth
);

our $VERSION		= '0.02';
our $TorrentScrape	= "/var/lib/perl/torrent-checker.php";


sub new(){
	
	my $self			= bless {}, shift;
#	my $url				= shift;
#	$self->{torrent}	= $url;		# later check if torrent file via http head status

	return $self;
		
}; # new()


sub getHealth(){

	my $self			= shift;
	my $torrent			= shift;

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
	my $torrentfile = "http://www.mininova.org/get/620364";
	my $obj		= BitTorrent->new();
	my $HashRef = $obj->getHealth($torrentfile);
	
	print "Seeder: " . $HashRef->{seeder};
	print "Leecher: " . $HashRef->{leecher};

=head1 DESCRIPTION

BitTorrent:
Initial Release: get Seeder and Leecher Infos from given torrent url file.

=head2 EXPORT

getHealth(): get Seeder and Leecher Infos

=head1 SEE ALSO

http://search.cpan.org/author/ORCLEV/Net-BitTorrent-File-1.02-fix/lib/Net/BitTorrent/File.pm
http://search.cpan.org/author/JMCADA/Net-BitTorrent-PeerPacket-1.0/lib/Net/BitTorrent/PeerPacket.pm

http://www.zoozle.net
http://www.zoozle.org

=head1 AUTHOR

Marc Qantins, E<lt>qantins@gmail.com<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by M. Quantins, Sebastian Enger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut

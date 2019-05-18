#!/usr/bin/perl
# Program:	hex
# Purpose:	Provide a hex dump of input
# Author:	B.James (custard@cpan.org) (c)
# Date:		18 February 1998
# @(#)Version:	0.1
# Ye olde-fashionde perle. No apologies.
#

=head1 NAME

=head1 SYNOPSIS

Displays a hex dump of the named file or stdin if no file is specified.
It's simple, not very clever and written in Ye olde-fashionde perle(tm). No apologies.

=head1 DESCRIPTION

Usage:
	hex <filename> [-bXX] [-fXX] [-a] [-t] [-h] [--help]
	
	-bXX	Number of bytes per line
	-fXX	Form factor - number of bytes per column
	-a	Omit address from output
	-t	Omit text from output
	-h	Omit hex dump from output
	-help	Display usage information
	-	Read from stdin (default if no file specified)

=head1 OSNAMES

Unix or Unix-likes.

=head1 SCRIPT CATEGORIES

Unix/System_administration

=head1 README

Displays a hex dump of the named file or stdin if no file is specified.
It's simple, not very clever and written in Ye olde-fashionde perle(tm). No apologies.

=head1 LICENCE

Copyright (c) 1998, Bruce James

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl.

=head1 DISCLAIMER

Use at your own risk. This program is supplied as is, and it is up to you whether you choose to use it or
not. As the program is based on a heuristic, it cannot guarantee to give accurate results.
I cannot be held responsible for any data or email loss that may occur during the use or misconfiguration of this program.

=head1 AUTHOR

Bruce James (custard@cpan.org)

=cut

sub usage { print( << 'eof' );

Usage:
	hex <filename> [-bXX] [-fXX] [-a] [-t] [-h] [--help]
	
	-bXX	Number of bytes per line
	-fXX	Form factor - number of bytes per column
	-a	Omit address from output
	-t	Omit text from output
	-h	Omit hex dump from output
	-help	Display usage information
	-	Read from stdin (default if no file specified)

Bruce James (c) 18 February 1998
custard@cpan.org

eof
	exit;
}

sub parse_cmd {
	while( $_=shift(@ARGV) ) {
		(/^-b([0-9]+)/) && ( $buflen=$1, next );
		(/^-a$/) 	&& ( $address=1, next );
		(/^-t$/) 	&& ( $text=1, next );
		(/^-h$/)	&& ( $hex=1, next );
		(/^-f([0-9]+)/) && ( $ff=$1, next );
		(/^-?(-help|-\?)$/)&& ( usage() );
		(/^-(.+)$/)	&& ( print("\nUnknown option $_\n"),usage() );
		(/^(.*)$/)	&& ( $file=$1, next );
	}
}


sub main {
	parse_cmd;
	$file='-' unless $file;
	$buflen=16 unless $buflen;	
	$ff=4 unless $ff;
	$unpacktmp='H2' x $buflen;
	for( $i=1; $i<=$buflen; $i++ ) {
		$printftmp.='%s';
		$printftmp.=' ' if ($i % $ff==0);
	}
	open( F, "<$file" );
	$ptr=0;
	while( $bytesread=read( F, $buf, $buflen ) ) {
		printf( "%04.X\t", $ptr ) unless $address;
		printf( $printftmp,unpack( $unpacktmp , $buf )) unless $hex;
		print " " x (($buflen-$bytesread)*2) if ($bytesread < $buflen);
		$buf=~tr/\0-\37\177-\377/./;
		print( "  $buf" ) unless $text;
		print( "\n" );
		$ptr+=$bytesread;
	}
}

eval main;

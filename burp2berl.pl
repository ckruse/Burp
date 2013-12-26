#!/usr/bin/env perl

use strict;

use Data::Dumper;
use DBI;

my $old_db = DBI->connect("dbi:Pg:dbname=burp", "ckruse", "");
my $new_db = DBI->connect("dbi:Pg:dbname=burp_dev", "ckruse", "");

my $user_map = {};
my $blog_map = {};
my $blog_uri_map  = {};
my $blog_user_map = {};
my $posts_map = {};

my $sth = $old_db->prepare("SELECT * FROM authors");
$sth->execute;

my $insert = $new_db->prepare("INSERT INTO authors (username, name, email, url) VALUES (?, ?, ?, ?)");

while(my $row = $sth->fetchrow_hashref) {
  $insert->execute($row->{username}, $row->{name}, $row->{email} || "", $row->{url});
  $user_map->{$row->{id}} = $new_db->selectrow_arrayref("SELECT MAX(id) FROM authors")->[0];
}

my $sth = $old_db->prepare("SELECT * FROM blog_authors ORDER BY author_id DESC");
$sth->execute();

while(my $row = $sth->fetchrow_hashref) {
  $blog_user_map->{$row->{blog_id}} = $row->{author_id} unless defined $blog_user_map->{$row->{blog_id}};
}

my $sth = $old_db->prepare("SELECT * FROM blogs");
$sth->execute();

my $insert = $new_db->prepare("INSERT INTO blogs (name, description, keywords, url, image_url, lang, host, author_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

while(my $row = $sth->fetchrow_hashref) {
  my $host = $row->{url};
  $host =~ s/http:\/\/|\/$//g;

  $insert->execute($row->{title}, $row->{description}, '', $row->{url}, "", "de", $host, $user_map->{$blog_user_map->{$row->{id}}});

  $blog_map->{$row->{id}} = $new_db->selectrow_arrayref("SELECT MAX(id) FROM blogs")->[0];
  $blog_uri_map->{$row->{id}} = $row->{url};
}


my $sth = $old_db->prepare("SELECT * FROM posts");
$sth->execute();

my $insert = $new_db->prepare("INSERT INTO posts (slug, guid, visible, author_id, blog_id, subject, excerpt, content, format, created_at, updated_at, published_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'html', ?, ?, ?)");

while(my $row = $sth->fetchrow_hashref) {
  my ($year, $mon) = year_mon($row->{created});
  $insert->execute($year . "/" . $mon . "/" . $row->{uri_tag}, $blog_uri_map->{$row->{blog_id}} . $year . "/" . $mon . "/" . $row->{uri_tag}, $row->{visible}, $user_map->{$row->{author_id}}, $blog_map->{$row->{blog_id}}, $row->{subject}, $row->{excerpt}, $row->{content}, $row->{created}, $row->{updated}, $row->{published});
  $posts_map->{$row->{id}} = $new_db->selectrow_arrayref("SELECT MAX(id) FROM posts")->[0];
}

my $sth = $old_db->prepare("SELECT * FROM comments");
$sth->execute();

my $insert = $new_db->prepare("INSERT INTO comments (post_id, visible, author, email, url, content, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

while(my $row = $sth->fetchrow_hashref) {
  $insert->execute($posts_map->{$row->{post_id}}, $row->{visible}, $row->{author}, $row->{email}, $row->{url}, $row->{content}, $row->{created}, $row->{created});
}


$sth = $old_db->prepare("SELECT * FROM tags");
$sth->execute();

my $insert = $new_db->prepare("INSERT INTO tags (post_id, tag_name) VALUES (?, ?)");

while(my $row = $sth->fetchrow_hashref) {
  $insert->execute($posts_map->{$row->{post_id}}, $row->{tag});
}


$new_db->prepare("UPDATE tags SET tag_name = LOWER(tag_name)")->execute;

sub year_mon($) {
  my $d = shift;
  my ($year, $mon) = split /-/, $d;

  my $mon = (undef, 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec')[$mon];

  return ($year, $mon);
}

# eof

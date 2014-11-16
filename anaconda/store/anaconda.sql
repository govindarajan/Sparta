#create database anaconda;

create table `users` (
  id varchar(64) character set latin1 not null,
  name varchar(128) not null,
  phone_number varchar(32) character set latin1 not null,
  token varchar(64) character set latin1 not null,
  primary key (`id`),
  unique key `uhx_phone` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create table `groups` (
  id bigint not null auto_increment, 
  name varchar(64) not null,
  type varchar(32) not null,
  user_id varchar(64) character set latin1 not null,
  primary key (`id`),
  key `g_uid` (`user_id`),
  constraint `fk_user_id` foreign key (`user_id`) references `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create table `group_members` (
  id bigint not null auto_increment, 
  group_id bigint not null,
  phone varchar(32) not null,
  active int(11) not null default 1,
  primary key (`id`),
  unique key `grp_phone` (`group_id`, `phone`),
  key `gm_gid` (`group_id`),
  constraint `fk_group_id` foreign key (`group_id`) references `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create table `user_data` (
  id bigint not null auto_increment, 
  user_id varchar(64) character set latin1 not null,
  date_created datetime not null,
  data text null,
  primary key (`id`),
  key `user_data_uid` (`user_id`, `date_created`),
  constraint `fk_us_user_id` foreign key (`user_id`) references `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create table `trans_data` (
  id bigint not null auto_increment,
  user_id varchar(64) character set latin1 not null,
  date_created datetime not null,
  data text null,
  primary key (`id`),
  key `user_data_uid12` (`user_id`, `date_created`),
  constraint `fk_us_user_id12` foreign key (`user_id`) references `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create table `mapping` (
  sid varchar(64) character set latin1 not null,
`from` varchar(64) character set latin1 not null,
`to` varchar(64) character set latin1 not null,
  primary key (`sid`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

# Remote Shell Launcher

## Homework	Graded

### This	homework	is	due	Monday	February	27,	 2017.

#### Part 1	- Remote	Shell – 25 Pts

So	far	we	have	exploited	applications	with	shellcode	that	spawns	a	shell	locally	or	prints hello	world. For	this	assignment	you	will	be	required	to	create	a	shellcode	that	can	be	used over	a	network	to	execute	shell	commands	(Remote	Shell).	You	will	 ** build	your	remote	shell	from	scratch	in	C	or	Assembly,	then	convert	the	hexdump	to	shellcode**.	Remember	the	smaller	the	shellcode	the	better.		Also	ensure	you	remove	ant	null	bytes	from	your	shellcode.	Test	your	shellcode	to	ensure	it	works	before	moving	on	to	Par1	2	of	this	assignment. To	test	your	shellcode	you	will	have	to	run	the	shell	code	in	one	terminal.	Then	from	a	different	terminal,	use	netcat	to	connect	on	the	listening	port.		

Test	output:

Run	the	portbind	application	it	waits	for	a	connection	in	one	terminal

```
$ ./portbind
```

From	a	new	terminal	I	use	netstat	to	locate	the	connection	using	the	command	

```
$ sudo netstat -lp | grep 31337
tcp 0 0 *:31337 *:* LISTEN 3067/portbind
```

From	the	output	above	we	can	see	that	the	connection	is	active.	Finally,	in	the	same	terminal	(second	terminal)	run	the	command	: nc -vv 127.0.0.1 31337 which	uses netcat to	connect	to	your	waiting	application	and	gives	you	a	remote	shell.

```
Connection to 127.0.0.1 31337 port [tcp/*] succeeded!
whoami
secstudent
id
uid=1000(secstudent) gid=1000(secstudent)
groups=1000(secstudent),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),
109(lpadmin),124(sambashare)
```

#### Part	2	– Exploitation
Now	that	you	know	the	shellcode	works,	you	will	use	it	in	exploiting	the	**file_echo** application	located	in	**bof_hw_files** directory.	The	application	accepts	a	filename	and	username	as	command	line	arguments	then	echos/prints	out	the	contents	of	the	file	specified. eg.	**./file_echo	myfile.txt James**.	The	application	would	print	out	the	contents	of	the	myfile.txt	file. If	the	file	does	not	exist,	the	application	gives	an	appropriate	error	message. You	can	run	the	application	and	test	how	it	works	with	and	without	a	valid	file name.

Unfortunately	the	application	is	vulnerable	to	buffer	overflow	attacks,	it’s now	your	job	to	find	and	exploit	the	vulnerability. 

You	are	required	to:

* Launch	a	buffer	overflow	attack	placing	your	shellcode	written	in	part	1	on	the	stack,	then	have	the	vulnerable	application	execute	it.			(35 Pts)

* Launch	a	buffer	overflow	attack	using	the	return	to	libc	attack passing	the	path	to	your	port	binding	application	to	system().		Remember	you	were	required	to	create	the	port-binding	application	in	C	or	Assembly	before	generating	the	shellcode.	Therefore	you	will	need	to	pass	the	path	to	you	executable	to	have	system()	execute	the	program.	The	result	should	be	the	same	as	if	the	shellcode	was	executed. (40 Pts)

#### Extra	Credit

Extra	credit will	be	given	if	you	can	modify	your	shellcode	to	connect	back	to	the	attacker	instead	of	having	the	attacker	connect	to	the	victim.	This	type	of	shellcode	will	be	more	effective	in	evading	firewalls,	as	in	most	cases	a firewall	is	configured	to	block	incoming	connections	except	for	ports	with	known	services. In	such	cases your	current	shellcode	would	be	useless.	However,	a	shellcode	which connects	back	to	the	attacker	is	more	effective,	as	firewalls	are	not	usually	configured	to	block	outgoing	connections,	as this	would	limit	usability

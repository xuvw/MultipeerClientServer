struct ListItem {
	1: required string text;
}

struct List {
	1: required i32 revision;
	2: required list<ListItem> listItems;
}

service ListAppAPI {
	i32 addListItem(1:ListItem listItem);
	i32 getListRevision();
	List getList();
}

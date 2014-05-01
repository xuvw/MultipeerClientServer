struct ListItem {
	1: required string text;
}

service ListApp {
	bool addListItem(1:ListItem listItem)
}

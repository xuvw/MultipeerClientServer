struct ListItem {
	1: required string text;
}

service ListAppAPI {
	bool addListItem(1:ListItem listItem)
}

struct Message {
	1: required string text;
}

struct Chat {
	1: required i32 revision;
	2: required list<Message> messages;
}

service ChatAppAPI {
	i32 addMessage(1:Message message);
	i32 getChatRevision();
	Chat getChat();
}

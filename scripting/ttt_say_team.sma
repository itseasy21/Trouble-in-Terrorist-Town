#include <amxmodx>
#include <ttt>

public plugin_init()
{
	register_plugin("[TTT] Say team", TTT_VERSION, TTT_AUTHOR);
	register_clcmd("say_team", "hook_sayteam");
}

public hook_sayteam(id)
{
	static message[192], none[2][4];

	read_args(message, charsmax(message));
	remove_quotes(message);

	formatex(none[0], charsmax(none[]), "");
	formatex(none[1], charsmax(none[]), " ");

	if(message[0] == '@' || equal(message, ""))
		return PLUGIN_HANDLED;

	if(!equal(message, none[0]) && !equal(message, none[1]))
	{
		new spec = ttt_get_special_state(id);
		if(spec == TRAITOR || spec == DETECTIVE)
		{
			static chat[192], name[32];
			get_user_name(id, name, charsmax(name));
			formatex(chat, charsmax(chat), "[%L]  %s :  %s", id, special_names[spec], name, message);

			new num, i;
			static players[32];
			get_players(players, num);
			for(--num; num >= 0; num--)
			{
				i = players[num];
				if(ttt_get_special_state(i) != spec) continue;

				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, i);
				write_byte(id);
				write_string(chat);
				message_end();
			}
		}
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}
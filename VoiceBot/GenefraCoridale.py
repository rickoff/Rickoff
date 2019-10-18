import discord
import asyncio
import json

client = discord.Client()
list_all_user_voice = []
list_all_player = []
userdiscord = 'C:\\server\\data\\userdiscord.json'

@client.event
async def on_ready():
	print('Connecté')
	print(client.user.name)
	print(client.user.id)
	print('------')
	list_discord = { 
		'players': []
	}	
	with open(userdiscord, 'w') as outfile:	
		d = (json.dumps(list_discord, indent=2, sort_keys=True))
		outfile.write(d)

@client.event	
async def on_voice_state_update(member, before, after):	
	
	with open(userdiscord) as json_data:
		d = json.load(json_data)
	list_all_player = d['players']
			
	if member.display_name not in list_all_player and member.voice is not None:			
		list_all_user_voice.append(member.display_name)
		print('The player has been added to the file')

	if member.display_name in list_all_player and member.voice is None:				
		list_all_user_voice.remove(member.display_name)							
		print('The player was deleted from the file')


	list_discord = { 
		'players': list_all_user_voice
	}	
	with open(userdiscord, 'w') as outfile:	
		d = (json.dumps(list_discord, indent=2, sort_keys=True))
		outfile.write(d)
		
@client.event
async def on_message(message):
	if message.content.startswith('!', 0):
		await message.delete()
		
client.run('token bot')

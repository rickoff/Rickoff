import discord
import asyncio
import os
import json
import time

client = discord.Client()
list_cellAndPlayer = []
list_all_user = []
list_all_channel = []
list_channelID_admin = ["replace to id channel","replace to id channel"]#replace to different id channel discord for safe channel 
playerlocationjson = 'C:\\tes3mp.Win64.release.0.7.0\\mp-stuff\\data\\playerlocations.json'#replace to you location playerlocations.json
userdiscord = 'C:\\tes3mp.Win64.release.0.7.0\\mp-stuff\\data\\userdiscord.json'#replace to you location userdiscord.json
	
@client.event
async def on_ready():
	print('Connecté')
	print(client.user.name)
	print(client.user.id)
	print('------')
	await on_createchannel()
	
async def on_createchannel():	
	await client.wait_until_ready()
	while not client.is_closed():
		try:

			server = client.get_guild(#your id server discord)	
			role = server.get_role(#your id role vocal)

			with open(playerlocationjson) as json_data:
				d = json.load(json_data)
			list_all_player = d['players']

			if list_all_player != []:
				
				list_cellAndPlayer = []
				for elt in list_all_player:
					new_list = {
						'name': elt['name'],
						'cell': elt['cell']
					}
					list_cellAndPlayer.append(new_list)
					
				list_all_user = []
				for member in server.members:
					dico_info = {
						'display_name': member.display_name,
						'id_user': member.id,
						'nick_name': member.name,
						'author_role': member.roles
					}
					list_all_user.append(dico_info)	
					
				list_all_channel = []			
				for channel in server.channels:			
					dico_info = {
						'name_channel_discord': channel.name,
						'id_channel_discord': channel.id,
						'type_channel': channel.type
					}
					list_all_channel.append(dico_info)
				
				if list_cellAndPlayer != [] and list_all_user != [] and list_all_channel != []:	
					
					for nameCell in list_cellAndPlayer:					
						name_ingame = nameCell['name']
						cell_ingame = nameCell['cell']	
						
						for elt in list_all_user:
							name_discord = elt['display_name']
							member_name = elt['nick_name']
							id_user_discord = elt['id_user']
							role_user_discord = elt['author_role']
							
							for info in list_all_channel:
								name_channel_discord = info['name_channel_discord']
								id_channel_discord = info['id_channel_discord']	
								channel = client.get_channel(id_channel_discord)
								userjson = server.get_member(id_user_discord)
								channelmemberjson = userjson.voice.channel	
								
								if name_discord not in list_all_user_voice and channel.type == discord.ChannelType.voice and channelmemberjson != None:	
									list_all_user_voice.append(name_discord)
									list_discord = { 
										'players': list_all_user_voice
									}	
									with open(userdiscord, 'w') as outfile:	
										d = (json.dumps(list_discord, indent=2, sort_keys=True))
										outfile.write(d)
									
								if name_discord in list_all_user_voice and channel.type == discord.ChannelType.voice and channelmemberjson == None:	
									list_all_user_voice.remove(name_discord)
									list_discord = { 
										'players': list_all_user_voice
									}	
									with open(userdiscord, 'w') as outfile:	
										d = (json.dumps(list_discord, indent=2, sort_keys=True))
										outfile.write(d) 

								if name_discord == name_ingame and role in role_user_discord:
									user = server.get_member(id_user_discord)
									channelmember = user.voice.channel											
									find_channel = discord.utils.find(lambda m: m.name == nameCell['cell'], server.channels)
									if find_channel == None and channelmember != None:
										overwrites = {
											server.default_role: discord.PermissionOverwrite(read_messages=False),
										}
										await server.create_voice_channel(nameCell['cell'], overwrites=overwrites)
										print('Le channel %s a était crée.'%(nameCell['cell']))	
										
								if name_discord == name_ingame and channel != None and channel.type == discord.ChannelType.voice and cell_ingame == name_channel_discord and role in role_user_discord:
									user = server.get_member(id_user_discord)
									channelmember = user.voice.channel							
									find_channel = discord.utils.find(lambda m: m.name == nameCell['cell'], server.channels)								
									if find_channel != None and channelmember != None and channel != channelmember:				
										await user.move_to(channel)
										print('User %s déplacé avec succès !'%(name_discord))

								
								if name_discord == name_ingame and cell_ingame != name_channel_discord and role in role_user_discord:
									find_channel = discord.utils.find(lambda m: m.name == nameCell['cell'], server.channels)								
									if find_channel != None and channel != None and not channel.id in list_channelID_admin and channel.type == discord.ChannelType.voice and not channel.members:
										await channel.delete()
										print('Le channel %s a était supprimé.'%(channel.name))	
		except:
			await asyncio.sleep(0.1)
			
	client.loop.create_task(on_createchannel())	
			
client.run('replace to token bot')#replace to token bot

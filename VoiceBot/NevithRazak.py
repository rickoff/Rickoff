import discord
import asyncio
import os
import json
import time

client = discord.Client()
list_cellAndPlayer = []
list_all_user = []
list_all_channel = []
list_all_user_voice = []
list_all_player = []
list_checkList = []

list_channelID_admin = ["replace to id channel","replace to id channel"]#replace to different id channel discord for safe channel 
playerlocationjson = 'C:\\tes3mp.Win64.release.0.7.0\\server\\data\\playerlocations.json'#replace to you location playerlocations.json
userdiscord = 'C:\\tes3mp.Win64.release.0.7.0\\server\\data\\userdiscord.json'#replace to you location userdiscord.json

@client.event
async def on_ready():
	print('Connecté')
	print(client.user.name)
	print(client.user.id)
	print('------')
	await client.wait_until_ready()
	await on_createchannel()
	
async def on_createchannel():	
	while not client.is_closed():
		try:

			server = client.get_guild(#your id server discord)	
			role = server.get_role(#your id role vocal)

			with open(playerlocationjson) as json_data:
				d = json.load(json_data)
			list_all_player = d['players']

			if list_all_player != []:

				list_cellAndPlayer = []
				list_checkList = []
				for elt in list_all_player:
					new_list = {
						'name': elt['name'],
						'cell': elt['cell']
					}
					list_cellAndPlayer.append(new_list)
					check_list = elt['cell']
					list_checkList.append(check_list)
					
				list_all_user = []
				for member in server.members:
					members_list = {
						'display_name': member.display_name,
						'id_user': member.id,
						'nick_name': member.name,
						'author_role': member.roles
					}
					list_all_user.append(members_list)	
					
				list_all_channel = []			
				for channel in server.channels:			
					channel_list = {
						'name_channel_discord': channel.name,
						'id_channel_discord': channel.id,
						'type_channel': channel.type
					}
					list_all_channel.append(channel_list)
				
				if list_cellAndPlayer != [] and list_all_user != [] and list_all_channel != []:	
	
					for nameCell in list_cellAndPlayer:		
						name_ingame = nameCell['name']
						cell_ingame = nameCell['cell']	
						
						for elt in list_all_user:
							name_discord = elt['display_name']
							id_user_discord = elt['id_user']
							role_user_discord = elt['author_role']
							
							for info in list_all_channel:
								name_channel_discord = info['name_channel_discord']
								id_channel_discord = info['id_channel_discord']	
								channel = client.get_channel(id_channel_discord)

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
										break
									else:
										pass
										
									if find_channel != None and channelmember != None:
										if channel != None and channel.type == discord.ChannelType.voice:
											if cell_ingame == name_channel_discord:													
												if channel != channelmember:				
													await user.move_to(channel)
													print('User %s déplacé avec succès !'%(name_discord))
												else:
													pass
											else:
												pass
										else:
											pass
									else:
										pass
								else:
									pass
									
								if channel != None and channel.type == discord.ChannelType.voice and not channel.id in list_channelID_admin and not channel.members and not channel.name in list_checkList:										
									await channel.delete()
									print('Le channel %s a était supprimé.'%(channel.name))	
								else:
									pass
									
					await asyncio.sleep(0.3)	
				else:
					await asyncio.sleep(1)
			else:
				await asyncio.sleep(1)
		except:
			await asyncio.sleep(1)
			
	client.loop.create_task(on_createchannel())	
	
client.run('replace to token bot')#replace to token bot

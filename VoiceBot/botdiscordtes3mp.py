import discord
import asyncio
import os
import json
import time

client = discord.Client()
list_all_user = []
list_all_channel = []
list_channelID_admin = ["replace to id channel","replace to id channel"]
playerlocationjson = 'C:\\tes3mp.Win64.release.0.7.0\\mp-stuff\\data\\playerLocations.json'#replace to you location playerlocations.json
	
@client.event
async def on_ready():
	print('Connecté')
	print(client.user.name)
	print(client.user.id)
	print('------')
	await on_event()

async def on_event():	
	await client.wait_until_ready()
	while not client.is_closed:
		try:
		
			server = client.get_server("352047092396457984")
			role = discord.utils.get(server.roles, name="Vocal")
			
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
						'author_role': member.top_role
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
							
							try:
									
								if name_discord == name_ingame and role_user_discord == role:
									user = server.get_member(id_user_discord)
									channelmember = user.voice.voice_channel
									channel = client.get_channel(id_channel_discord)
									find_channel = discord.utils.find(lambda m: m.name == nameCell['cell'], server.channels)
											
									if find_channel == None:
										everyone = discord.PermissionOverwrite(read_messages=False)
										await client.create_channel(server, nameCell['cell'], (server.default_role, everyone), type=discord.ChannelType.voice)
										print('nouveau channel crée')
										await asyncio.sleep(0.1)
										#return await on_event()									
										
									if channel != None and channel.type == discord.ChannelType.voice and name_channel_discord == cell_ingame and channelmember != None and channel != channelmember:				
										await client.move_member(user, channel)
										print('User %s déplacé avec succès ! big up'%(name_discord))
										await asyncio.sleep(0.1)																		
										
							except:					
								pass									

				for x in list_all_channel:
					name_channel_discord = x['name_channel_discord']
					id_channel_discord = x['id_channel_discord']				
					channel = client.get_channel(id_channel_discord)
					try:
						
						if not channel.id in list_channelID_admin and channel.type == discord.ChannelType.voice and not channel.voice_members and cell_ingame != name_channel_discord:									
							await client.delete_channel(channel)
							print('le channel %s a était delete.'%(channel.name))
							await asyncio.sleep(0.1)
							
					except:
						pass
						
			else:			
				message = "``Aucun joueurs actuellement en jeu``"
				print(message)
				await asyncio.sleep(1)
						
		except:
			pass																														
client.run('replace to token bot')

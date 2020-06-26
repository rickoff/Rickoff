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
    server = client.get_guild("replace to id server")	
    roleVocal = server.get_role("replace to id role vocal")	
    while not client.is_closed():
        try:
            list_checkList = []
            list_all_discord = []          
            with open(playerlocationjson) as json_data:
                d = json.load(json_data)
            list_all_discord = d['players']              
            if list_all_discord != []:            
                for member in server.members:        
                    for elt in list_all_discord:
                        if member.display_name.lower() == elt['name'].lower():                                                       
                            if elt['vocal'] == 1 and roleVocal in member.roles and member.voice.channel.name != elt['cell']:
                                list_checkList.append(elt['cell']) 
                                find_channel = discord.utils.find(lambda m: m.name == elt['cell'], server.channels)
                                if find_channel == None:
                                    overwrites = {
                                        server.default_role: discord.PermissionOverwrite(read_messages=False),
                                    }
                                    await server.create_voice_channel(elt['cell'], overwrites=overwrites)
                                    print('Le channel %s a était crée.'%(elt['cell'])) 
                                    find_channel = discord.utils.find(lambda m: m.name == elt['cell'], server.channels)
                                    await member.move_to(find_channel)
                                    print('member %s déplacé avec succès !'%(member.display_name))
                                    break
                                else:
                                    await member.move_to(find_channel)
                                    print('member %s déplacé avec succès !'%(member.display_name))
                                    break                                
                            
                for channel in server.channels:                       
                    if channel != None and channel.type == discord.ChannelType.voice and not channel.id in list_channelID_admin and not channel.members and not channel.name in list_checkList:										
                        await channel.delete()
                        print('Le channel %s a était supprimé.'%(channel.name))
                        break
            await asyncio.sleep(1)
        except:
            await asyncio.sleep(1)
 
    client.loop.create_task(on_createchannel())	
	
client.run('replace to token bot')#replace to token bot

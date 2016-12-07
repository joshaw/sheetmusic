-- Created:  Sun 13 Nov 2016
-- Modified: Wed 07 Dec 2016
-- Author:   Josh Wainwright
-- Filename: index.lua

local lfs = require('lfs')
local sheets = {}
local artists = {}
local songs = {}

local total_size = 0
local total_n = 0

local function printf(str, ...)
	io.write(str:format(...))
end

-- Convert bytes to kilo-, mega-, or giga-bytes
local suffixes = {'B', 'K', 'M', 'G'}
local function human_bytes(bytes)
	if bytes <= 0 then return '' end
	local n = 1
	while bytes >= 1024 do
		n = n + 1
		bytes = bytes / 1024
	end
	return string.format('%.0f%s', bytes, suffixes[n])
end

local function list_dir(dir)
	for f in lfs.dir(dir) do
		local path = dir .. '/' .. f
		local attrs = lfs.attributes(path)
		if f == '.' or f == '..' then
			--
		elseif attrs.mode == 'file' then
			total_n = total_n + 1
			local artist, song = f:match('^([^%-]+)_%-_([^%-]+)%..+')
			if not artist then
				artist = 'Unknown'
				song = f
			end
			artist = artist:gsub('_', ' ')
			song = song:gsub('_', ' ')
			local size = attrs.size
			total_size = total_size + size
			local entry = {name=song, path=path, size=size, artist=artist}
			songs[#songs+1] = entry
			if sheets[artist] then
				table.insert(sheets[artist], entry)
			else
				sheets[artist] = {entry}
				artists[#artists+1] = artist
			end
		elseif attrs.mode == 'directory' then
			list_dir(f)
		end
	end
end

list_dir('sheetmusic')
table.sort(artists)
table.sort(songs, function(a,b) return a.name < b.name end)

printf([[
<!DOCTYPE html>
<html>
<head>
<link rel='stylesheet' href='css.css'>
<meta name=viewport content="width=device-width, user-scalable=no, initial-scale=1">
<style>
body { padding: 0 2vw; }
h3 { margin: 0; }
.artists {
	padding: 0;
	margin: 0;
	list-style-type: none;
	-moz-columns: 15em;
	-webkit-columns: 15em;
	columns: 15em;
}
.artist { 
	padding: 0.3em;
	margin: 0 0 1em;
	page-break-inside: avoid;
}
.songs {
	-moz-columns: 20em;
	-webkit-columns: 20em;
	columns: 20em;
}
.small { font-size: xx-small; }
</style>
</head>
<body>
]])
printf('<h1>Sheet Music (%i, %s)</h1>\n', total_n, human_bytes(total_size))
printf('<h2>Artists</h2>\n')
printf('<ul class="artists">\n')
for i=1, #artists do
	local artist = artists[i]
	local songs = sheets[artist]
	printf('<li class="artist">\n')
	printf('<h3>%s</h3>\n', artist)
	printf('<ul>\n')
	for i=1, #songs do
		local s = songs[i]
		local size = human_bytes(s.size)
		printf('<li><a href="%s">%s</a> <span class="small">(%s)</span></li>\n', 
			s.path, s.name, size)
	end
	printf('</ul></li>\n')
end
printf('</ul>\n')

printf('<h2>Songs</h2>\n')
printf('<ul class="songs">\n')
for i=1, #songs do
	local s = songs[i]
	local size = human_bytes(s.size)
	printf('<li><a href="%s">%s</a> <span class="small">(%s, %s)</span></li>\n', 
		s.path, s.name, s.artist, size)
end
printf('</ul>\n')
printf('<span class="small">%s</span>\n', os.date('%c'))
printf('</body></html>\n')

-- iOS - A shell for ComputerCraft computers
-- Copyright (C) 2016 Tulir Asokan

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>

Aliases = { "nano" }
FillScreen = true

function Run(args)
	local function editFile(file, name)
		local fsFile = fs.open(file, "r")
		local dataBefore = nil
		if fsFile then
			dataBefore = fsFile.readAll()
			fsFile.close()
		end

		shell.run("/sys/edit.lua", file)

		local dataAfter = nil
		fsFile = fs.open(file, "r")
		if dataBefore then
			dataAfter = fsFile.readAll()
			fsFile.close()
		end

		io.Clear()
		if not fsFile then
			io.Cprintfln(colors.cyan, "%s not created.", name)
		elseif not dataBefore then
			io.Cprintfln(colors.cyan, "%s created.", name)
		elseif dataBefore == dataAfter then
			io.Cprintfln(colors.cyan, "%s unchanged.", name)
		else
			io.Cprintfln(colors.cyan, "%s updated.", name)
		end
	end

	if #args == 1 then
		local suffix = string.sub(args[1], -4)
		if args[1] == "startup" or args[1] == "startup.lua" then
			editFile("/.ios/startup.lua", "Startup file")
		elseif suffix == ".lua" then
			editFile("/.ios/localapps/" .. args[1], "App " .. string.sub(args[1], 1, -5))
		else
			editFile("/.ios/files/" .. args[1], "File " .. args[1])
		end
	elseif #args == 2 then
		if args[1] == "app" then
			editFile("/.ios/localapps/" .. args[2] .. ".lua", "App " .. args[2])
		elseif args[1] == "file" then
			editFile("/.ios/files/" .. args[2], "File " .. args[2])
		else
			io.Cprintfln(colors.red, "Directory \"%s\" not found.", args[1])
		end
	else
		io.Cprintln(colors.red, "Usage: edit [directory] <file>")
	end
end

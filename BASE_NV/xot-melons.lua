function getActorsAround(actorselected,actorsToFind, distance)
	actorList = Map.ActorsInCircle(actorselected.CenterPosition, WDist.FromCells(distance), function(a)
		return a.Type == actorsToFind
	end)
	return actorList
end


function setupRefs()

	facts = Map.ActorsInBox(Map.TopLeft, Map.BottomRight, function(actor)
		return actor.Type == "fact" or actor.Type == "mcv"
	end)


	Utils.Do(facts, function(a)
		
			-- Media.DisplayMessage (""..a.Owner.Name, "Mission", HSLColor.Red)
		if a.Owner ~= castlePlayer then
			actorOwner = a.Owner
			--Media.DisplayMessage (""..actorOwner.Name, "Mission", HSLColor.Red)

			toCapture = {}
			toCapture = { "silo","powr","oilb"}

			Utils.Do(toCapture, function(z)
				actorsToCapture = getActorsAround(a,z,15)
					
				Utils.Do(actorsToCapture, function(b)
					b.Owner = actorOwner
				end)
			end)
		end
	end)

	--Create Refs
	Trigger.AfterDelay(DateTime.Seconds(1), function()
		powrs = Map.ActorsInBox(Map.TopLeft, Map.BottomRight, function(actor)
			return 
			actor.Type == "silo"
		end)

		Utils.Do(powrs, function(a)

			actorOwner = a.Owner
			originalLocation = a.Location
			newLocation = originalLocation + CVec.New(0,1)

			if actorOwner.InternalName ~= "Creeps" then
				Actor.Create("proc", true, { Owner = actorOwner, Location = newLocation})
			end
			
			 --Media.DisplayMessage (""..actorOwner.InternalName, "Mission", HSLColor.Red)
			-- Media.DisplayMessage(""..newLocation, "Mission", HSLColor.Red)
		end)

	end)


	Trigger.AfterDelay(DateTime.Seconds(2), function()
		creepActors = getAllCreeps()
		removeactors(creepActors)
		--Media.DisplayMessage(""..#creepActors, "Mission", HSLColor.Red)
	end)
end

function getAllCreeps()
	targets = Utils.Where(Creeps.GetActors(), function(actor)
		return
			actor.Type == "powr" or actor.Type == "silo" or actor.Type == "oilb"
	end)
	return targets
end

--Remove Boxes in Table
function removeactors(a)
	Utils.Do(a, function(unit)
		unit.Destroy()
	end)
	return 
end



WorldLoaded = function()
	Creeps = Player.GetPlayer("Creeps") 
	Trigger.AfterDelay(DateTime.Seconds(2), function()
		setupRefs()
	end)
end


Tick = function()
end


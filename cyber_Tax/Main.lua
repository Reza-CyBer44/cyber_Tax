Tax = json.decode(LoadResourceFile(GetCurrentResourceName(),"baseTax.json"))
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Events
RegisterNetEvent('Cyber:RemoveMoneyWithTax')
AddEventHandler('Cyber:RemoveMoneyWithTax',function(money)
_source = source
RemoveMoneyWithTax(money,source)


end)
RegisterNetEvent('Cyber:GetCurrentTaxPercent')
AddEventHandler('Cyber:GetCurrentTaxPercent',function(cb)
CurrentTax = GetCurrentTaxPercent()
cb(CurrentTax)

end)


--                Functions
GetCurrentTaxPercent = function()

 return Tax

end

RemoveMoneyWithTax = function(mon,id)
 if mon and id and tonumber(mon) and tonumber( id ) then
 local xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer then
    local final = CalculateTax(mon)
	if EnableSociety then
	local ftax = tonumber(mon) * (Tax / 100)
	 TriggerEvent('esx_addonaccount:getSharedAccount', SocietyAddonAccount, function(account)
    	account.addMoney(amount)
	 end)
	end
	xPlayer.removeMoney(final)
  end
 end
end

CalculateTax = function(money)
 if tonumber(money) then
  return tonumber(money) + tonumber(money) * (Tax / 100)
 end
end

ChangeTaxNumber = function(money)
 if money and tonumber(money) and money <= 100 and money >= 0 then
  Tax = tonumber(money)
  SaveResourceFile( GetCurrentResourceName(), "baseTax.json" , json.encode(Tax), -1 )
 end
end

--              Commands 

RegisterCommand("ChangeTax", function(source , args)
    if source > 0 then
	local xPlayer = ESX.GetPlayerFromId(source)
	 if xPlayer.getJob().name == ChangeTaxJobName and xPlayer.getJob().grade >= ChangeTaxJobGrade then
      if args[1] then
		 if tonumber(args[1]) then
		
		  if tonumber(args[1]) < 100 and tonumber(args[1]) > 0 then
		 
		 ChangeTaxNumber(tonumber(args[1]))
		 if AnnounceChanges then
		  TriggerClientEvent('esx:showNotification', -1 , '~g~[TAX]~s ~r~Tax Percentage Has Been Changed To ~g~' .. args[1])
		 else
		 xPlayer.showNotification('~g~Tax Number Changed To ~b~' .. args[1])
		 end
		 
		 else
		 xPlayer.showNotification('~r~Please Write A valid ~y~Percent~s~ From 0 to 100')		
		 end
		
		 else
		 xPlayer.showNotification('~r~Please Write a Valid ~y~Number')
		 end
		else
	   xPlayer.showNotification("~r~Please Write The Final Tax ~y~Number") 
	  end
	 else
	 xPlayer.showNotification("~r~ Insufficient Permission")
	 end
    else
        if args[1] then
		 if tonumber(args[1]) then
		
		 if tonumber(args[1]) < 100 and tonumber(args[1]) > 0 then
		 
		 ChangeTaxNumber(tonumber(args[1]))
		 print('^2 Tax Number Changed To ^3' .. args[1])
		 else
		 print('^1 Please Write A valid Percent From 0 to 100')		
		 end
		
		 else
		 print('^1 Please Write a Valid Number')
		 end
		else
		print("^1 Please Write The Final Tax Number") 
		end 
    end
end, true) 


RegisterCommand("CurrentTax", function(source , args)
    if source > 0 then
	local xPlayer = ESX.GetPlayerFromId(source)
	if ShowTaxToEveryone then
	
	   xPlayer.showNotification('~g~Current Tax Percentage is ~b~' .. tostring(tax) )
	
	else
	 if xPlayer and xPlayer.getJob().name == ChangeTaxJobName and xPlayer.getJob().grade >= ChangeTaxJobGrade then
            
	 	   local xPlayer = ESX.GetPlayerFromId(source)
		   local tax = GetCurrentTaxPercent()
		   xPlayer.showNotification('~g~Current Tax Percentage is ~b~' .. tostring(tax) )
		   
	 elseif xPlayer then
	  xPlayer.showNotification("~r~ Insufficient Permission")
     end
	end
    else
	
        local tax = GetCurrentTaxPercent()
		print('^2 Current Tax Percentage is ^3' .. tostring(tax) )
		
    end
end, true) 



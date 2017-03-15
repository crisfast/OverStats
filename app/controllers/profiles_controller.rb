require 'net/http'
require 'json'

class ProfilesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create,:edit,:update]

    def new
    
    end

	def create
		# Preluare parametrii din formular
		battleTag = params[:btInput]
		regiune = params[:regiune]
        platforma = params[:platforma]
		user_id = params[:user_id]

        #Prelucrez battletagul
        battleTag.gsub!('#','-')

		if platforma == "psn" || platforma == "xbl"
			regiune = "any"
		end

		# Creare profil + activare
		profil = Profile.create({
			region: regiune, 
			platform: platforma,
            battletag: battleTag,
			user_id: user_id
			})
		@user = User.find(user_id)
        @user.update({activated: true})

		# Creare entry de Stats
        
        url1 = 'https://api.lootbox.eu/' + platforma + '/'  + regiune + '/' + battleTag + '/achievements'
		uri1 = URI(url1)
		achievements = Net::HTTP.get(uri1)

        url2 = 'https://owapi.net/api/v3/u/' + battleTag + '/stats' + '?platform=' + platforma
		uri2 = URI(url2)
		blizzProf = Net::HTTP.get(uri2)

        url3 = 'https://owapi.net/api/v3/u/' + battleTag + '/heroes' + '?platform=' + platforma
		uri3 = URI(url3)
		eroi = Net::HTTP.get(uri3)

		statisticiUser = UserStat.create({
			user_id: user_id,
			achievements: achievements,
			profile: blizzProf,
			heroes: eroi
		})

		# Redirect pe prima pagina
		redirect_to "/"
	end 

   def show
       	@id = params[:id]
		@profil = Profile.find(@id)
		@user = @profil.user
		statistici1 = @user.user_stat
	    @BlizzProfile = JSON(statistici1.profile)
		@HeroesProfile = JSON(statistici1.heroes)
   end

   def edit
       @id = params[:id]
       @profil = Profile.find(@id)
   end

   def update
    	# Obtinem valorile din request
		id = params[:idProf]
		battleTag = params[:btInput]
		regiune = params[:regiune]
        platforma = params[:platforma]

		if platforma == "psn" || platforma == "xbl"
			regiune = "any"
		end
		# Cautam post-ul pe care vrem sa il modificam
		profil = Profile.find(id)
		statistici = UserStat.find_by(user_id: profil.user_id)
		# Facem update in baza de date
		profil.update({ battletag: battleTag.gsub!('#','-'), region: regiune, platform: platforma })

		# Actualizam si statisticile

		url1 = 'https://api.lootbox.eu/' + platforma + '/'  + regiune + '/' + battleTag + '/achievements'
		uri1 = URI(url1)
		achievements = Net::HTTP.get(uri1)

        url2 = 'https://owapi.net/api/v3/u/' + battleTag + '/stats' + '?platform=' + platforma
		uri2 = URI(url2)
		blizzProf = Net::HTTP.get(uri2)

        url3 = 'https://owapi.net/api/v3/u/' + battleTag + '/heroes' + '?platform=' + platforma
		uri3 = URI(url3)
		eroi = Net::HTTP.get(uri3)

		statistici.update({
			achievements: achievements,
			profile: blizzProf,
			heroes: eroi
		})
		# Ne intoarcem la ultimul ecran accesat
		redirect_to "/"
    end
end

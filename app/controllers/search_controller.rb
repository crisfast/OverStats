class SearchController < ApplicationController
    before_action :authenticate_user!, only: [:index]

    def index
    
        if !params[:battleTagSearch].nil? && !params[:regiune].nil? && !params[:platforma].nil?
        
            if Profile.exists?(battletag: params[:battleTagSearch].gsub('#','-'))
                # preluam datele userului curent
                @userConectatProfileStats = JSON(current_user.user_stat.profile)
                @userConectatEroi = JSON(current_user.user_stat.heroes)

                #preluam datele jucatorului cautat
                @userCautat = Profile.find_by(battletag: params[:battleTagSearch].gsub('#','-'), region: params[:regiune], platform: params[:platforma])
                @userCautatEroi = JSON(@userCautat.user.user_stat.heroes)
                @userCautatProfileStats = JSON(@userCautat.user.user_stat.profile)
                @regiuneCautat = @userCautat.user.profile.region
            
            else 

                if GuestStat.exists?(battletag: params[:battleTagSearch].gsub('#','-'))

                    @userCautat = GuestStat.find_by(battletag: params[:battleTagSearch].gsub('#','-'), region: params[:regiune])
                    @userCautatEroi = JSON(@userCautat.heroes)
                    @userCautatProfileStats = JSON(@userCautat.profile) 
                    @regiuneCautat = params[:regiune]

                else

                    url1 = 'https://owapi.net/api/v3/u/' + params[:battleTagSearch].gsub('#','-') + '/stats' + '?platform=' + params[:platforma]
                    uri1 = URI(url1)
                    blizzProf = Net::HTTP.get(uri1)

                    url2 = 'https://owapi.net/api/v3/u/' + params[:battleTagSearch].gsub('#','-') + '/heroes' + '?platform=' + params[:platforma]
                    uri2 = URI(url2)
                    eroi = Net::HTTP.get(uri2)

                    statisticiGuest = GuestStat.create({
                    battletag: params[:battleTagSearch].gsub('#','-'),
                    region: params[:regiune],
                    profile: blizzProf,
                    heroes: eroi })

                    @userCautat = GuestStat.find_by(battletag: params[:battleTagSearch].gsub('#','-'), region: params[:regiune])
                    @userCautatEroi = JSON(@userCautat.heroes)
                    @userCautatProfileStats = JSON(@userCautat.profile) 
                    @regiuneCautat = params[:regiune]

                end

                @userConectatProfileStats = JSON(current_user.user_stat.profile)
                @userConectatEroi = JSON(current_user.user_stat.heroes)

            end

        end

    end

    def create
    end
end

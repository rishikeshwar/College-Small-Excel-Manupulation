class JournalsController < ApplicationController
	def edit 
		@journal = Journal.find(params[:id])
	end
    
    
	def update 
		@journal = Journal.find(params[:id])
		require 'rubyXL'
      
    	workbook = RubyXL::Parser.parse("/home/rishikeshwar/ri.xlsx")
    	pos = 0
    	start = 0
    	0.upto(10000) do |i|
    		print "#{workbook[0][i][0].value}"
    		if workbook[0][i][0].value == 1
    			start = i
    			break
    		end
    	end


    	@ending = Journal.order('id DESC').first
    	endo = 0

    	print "#{start}"
    	start.upto(1000) do |i| 
    		if @journal.id == workbook[0][i][0].value.to_i
    			pos = i
    			break
    		end
    	end
        
        
    	puts "coming coming #{pos}"
		if @journal.title.squish != params[:title].squish
			@journal.update_attribute(:title, "#{params[:title]}")
			print "#{pos}"
			workbook[0][pos][1].change_contents("#{params[:title]}", workbook['Sheet1'][pos][1].formula)
			workbook[0][pos][1].change_fill(rgb = 'cc0000')
		end

		if @journal.author.squish != params[:author].squish
			@journal.update_attribute(:author, "#{params[:author]}")
			workbook[0][pos][2].change_contents("#{params[:author]}", workbook['Sheet1'][pos][2].formula)
			workbook[0][pos][2].change_fill(rgb = 'cc0000')
		end

		if @journal.status != params[:status]
			@journal.update_attribute(:status, "#{params[:status]}")
			workbook[0][pos][3].change_contents("#{params[:status]}", workbook['Sheet1'][pos][3].formula)
			workbook[0][pos][3].change_fill(rgb = 'cc0000')
		end

		if @journal.JorC != params[:JorC]
			@journal.update_attribute(:JorC, "#{params[:JorC]}")
			workbook[0][pos][4].change_contents("#{params[:JorC]}", workbook['Sheet1'][pos][4].formula)
			workbook[0][pos][4].change_fill(rgb = 'cc0000')
		end

		if @journal.scopus != params[:scopus]
			@journal.update_attribute(:scopus, "#{params[:scopus]}")
			workbook[0][pos][5].change_contents("#{params[:scopus]}", workbook['Sheet1'][pos][5].formula)
			workbook[0][pos][5].change_fill(rgb = 'cc0000')
		end

		if @journal.affiliations.squish != params[:affiliations].squish
			@journal.update_attribute(:affiliations, "#{params[:affiliations]}")
			workbook[0][pos][6].change_contents("#{params[:affiliations]}", workbook['Sheet1'][pos][6].formula)
			workbook[0][pos][6].change_fill(rgb = 'cc0000')
		end

		if @journal.amritapapers.to_i != params[:amritapapers].to_i
			@journal.update_attribute(:amritapapers, "#{params[:amritapapers].to_i}")
			workbook[0][pos][7].change_contents(params[:amritapapers].to_i, workbook['Sheet1'][pos][7].formula)
			workbook[0][pos][7].change_fill(rgb = 'cc0000')
		end

		if @journal.coauthor != params[:coauthor]
			@journal.update_attribute(:coauthor, "#{params[:coauthor]}")
			workbook[0][pos][8].change_contents("#{params[:coauthor]}", workbook['Sheet1'][pos][8].formula)
			workbook[0][pos][8].change_fill(rgb = 'cc0000')
		end

		if @journal.communicated != params[:communicated]
			@journal.update_attribute(:communicated, "#{params[:communicated]}")
			workbook[0][pos][9].change_contents("#{params[:communicated]}", workbook['Sheet1'][pos][9].formula)
			workbook[0][pos][9].change_fill(rgb = 'cc0000')
		end

		if @journal.paperbefore != params[:paperbefore]
			@journal.update_attribute(:paperbefore, "#{params[:paperbefore]}")
			workbook[0][pos][10].change_contents("#{params[:paperbefore]}", workbook['Sheet1'][pos][10].formula)
			workbook[0][pos][10].change_fill(rgb = 'cc0000')
		end
		@user = User.find(session[:user_id])
		workbook.write('/home/rishikeshwar/ri.xlsx')
		workbook = nil
		redirect_to user_path(session[:user_id])
	end
end

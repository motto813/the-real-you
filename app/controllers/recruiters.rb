before do
  if session[:user].instance_of?(Recruiter) && params[:id].to_i == session[:user].id
    @authorized_recruiter = true
  else
    @authorized_recruiter = false
  end
end

get '/recruiters' do
  @recruiters = Recruiter.all

  erb :"recruiters/index"
end

get '/recruiters/new' do
  erb :"recruiters/new"
end

post '/recruiters' do
  @recruiter = Recruiter.new(params[:recruiter])

  if @recruiter.save
    redirect '/hiring'
  else
    @errors = @recruiter.errors.full_messages

    erb :"recruiters/new"
  end
end

get '/recruiters/:id' do
  if session[:user].instance_of?(Recruiter) && params[:id].to_i == session[:user].id
    @recruiter = Recruiter.find(params[:id])
    @positions = Position.listed_by_recruiter(params[:id])

    erb :"recruiters/show"
  else
    status 401
    @recruiter = Recruiter.new
    @errors = @recruiter.errors.full_messages
    @errors << "You can't view that recruiter's profile"
    erb :hiring
  end

  erb :"recruiters/show"
end

get '/recruiters/:id/edit' do
  @recruiter = Recruiter.find(params[:id])

  erb :"recruiters/edit"
end


put '/recruiters/:id' do
  @recruiter = Recruiter.find(params[:id])

  @recruiter.assign_attributes(params[:recruiter])

  if @recruiter.save
    redirect '/recruiters'
  else
    erb :"recruiters/edit"
  end
end


delete '/recruiters/:id' do
  @recruiter = Recruiter.find(params[:id])

  @recruiter.destroy

  redirect '/recruiters'
end

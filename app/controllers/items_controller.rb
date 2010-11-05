class ItemsController < ApplicationController
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find(params[:id])
  end
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to items_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to @item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to items_url
  end

	def choose
		@item = Item.find(params[:id])
		@item.user = current_user
		if @item.save
			flash[:notice] = "Item escolhido com sucesso."
		else
			flash[:error] = "Ocorreu um erro na escolha do item."
		end
		redirect_to items_url
	end
	
	def unchoose
		@item = Item.find(params[:id])
		@item.user = nil
		if @item.save
			flash[:notice] = "Escolha removida com sucesso."
		else
			flash[:error] = "Ocorreu um erro na remocao da sua escolha."
		end
		redirect_to items_url
	end
end

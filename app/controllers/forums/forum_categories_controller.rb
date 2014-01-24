class Forums::ForumCategoriesController < ApplicationController
  load_and_authorize_resource :forum_category
end

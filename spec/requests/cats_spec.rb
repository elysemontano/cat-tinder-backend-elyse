require 'rails_helper'

RSpec.describe "Cats", type: :request do

# ---------------------- CRUD
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )

      get '/cats'
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do
    it "creates a cat" do
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Meow Mix, and plenty of sunshine.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      expect(response).to have_http_status(200)
      cat = Cat.first
      expect(cat.name).to eq 'Buster'
    end
  end

  describe "PATCH /update" do
    it "updates a cat" do
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Meow Mix, and plenty of sunshine.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first

      updated_cat_params = {
        cat: {
          name: 'Buster',
          age: 5,
          enjoys: 'Meow Mix, and plenty of sunshine.', 
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
  
      patch "/cats/#{cat.id}", params: updated_cat_params
      updated_cat = Cat.find(cat.id)
      expect(response).to have_http_status(200)
      expect(updated_cat.age).to eq 5
    end
  end

  describe "DELETE /destroy" do
    it 'deletes a cat' do
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Meow Mix, and plenty of sunshine.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      delete "/cats/#{cat.id}"
      expect(response).to have_http_status(200)
      cats = Cat.all
      expect(cats).to be_empty
    end
  end





#------------------ VALIDATIONS

  describe "cannot create a cat without valid attributes" do
    it "doesn't create a cat without a name" do
      cat_params = {
          cat: {
          age: 5,
          enjoys: 'snuggles and teasing the dog',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
          }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      cat = JSON.parse(response.body)
      expect(cat['name']).to include "can't be blank"
    end

    it 'cannot create a cat without an age' do
      cat_params = {
        cat: {
          name: 'Boo',
          enjoys: 'cuddles and belly rubs', 
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['age']).to include "can't be blank"
    end
    it 'cannot create a cat without an enjoys' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2, 
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include "can't be blank"
    end

    it 'cannot create a cat without an image' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2, 
          enjoys: 'cuddles and belly rubs'
        }
      }
      post '/cats', params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['image']).to include "can't be blank"
    end
    it 'cannot create a cat without an enjoys that is at least 10 characters' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles', 
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include "is too short (minimum is 10 characters)"
    end
  end

  describe "cannot update a cat without valid attributes" do
    it 'cannot update a cat without a name' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      updated_cat_params = {
        cat: {
          name: '',
          age: 2,
          enjoys: 'cuddles and belly rubs', 
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['name']).to include "can't be blank"
    end
    it 'cannot update a cat without a age' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      updated_cat_params = {
        cat: {
          name: 'Boo',
          age: '',
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['age']).to include "can't be blank"
    end
    it 'cannot update a cat without an enjoys' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      updated_cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: '',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include "can't be blank"
    end
    it 'cannot update a cat without an image' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      updated_cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: ''
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['image']).to include "can't be blank"
    end

    it 'cannot update a cat without an enjoys that is at least 10 characters' do
      cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles and belly rubs',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first
      updated_cat_params = {
        cat: {
          name: 'Boo',
          age: 2,
          enjoys: 'cuddles',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      patch "/cats/#{cat.id}", params: updated_cat_params
      cat = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(cat['enjoys']).to include "is too short (minimum is 10 characters)"
    end
  end
end
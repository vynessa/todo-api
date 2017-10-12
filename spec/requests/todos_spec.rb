require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
    # Intiialize test data
    let!(:todos) { create_list(:todo, 10) }
    let(:todo_id) {todos.first.id}

    # Test suite to get Todos
    describe 'GET /todos' do
        before { get '/todos' }

        it 'returns todos' do
            expect(json).not_to be_empty
            expect(json.size).to eq(10)
        end

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end
    end

    # Test suite to get Todo by id
    describe 'GET /todos/:id' do
        before { get "todos/#{todo_id}" }

        context 'when the record exists' do
            it 'returns the todo' do
                except(json).not_to be_empty
                except(json['id']).to eq(todo_id)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the record does not exist' do
            let (:todo_id) {100}

            it 'returns status code 400' do
                expect(response).to have_http_status(400)
            end
            
            it 'returns a not found message' do
                expect(response.body).to match(/Couldn't find Todo/)
            end
        end
    end

    # Post todo test suite
    describe 'POST /todos' do
        let (:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

        context 'when the request is valid' do
            before { post '/todos', param: valid_attributes }
            
            it 'creates a todo' do
                except(json['title']).to eq('Learn Elm')
            end

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
        end

        context 'when the request is invalid' do
            before { post '/todos', param: { title: 'Foobar' } }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end
            
            it 'returns a validation failure message' do
                expect(response.body).to match(/Validation failed: Created by can't be blank/)
            end
        end
    end

    # Put todo test suite
    describe do
        let(:valid_attributes) { { title: 'Shopping' } }

        context 'when the record exists' do
            before { put "/todos/#{todo_id}", param: valid_attributes }

            it 'updates the record' do
                expect(response.body).to be_empty
            end

            it 'returns status code 204' do
                expect(response).to have_http_status(204)
            end
        end
    end

    # Delete todo test suite
    describe 'DELETE /todos/:id' do
        before { delete "/todos/#{todo_id}" }

        it 'returns status code 204' do
            except(response).to have_http_status(204)
        end
    end
end
# frozen_string_literal: true

RSpec.shared_examples 'a rezzable web_object' do |model_name|
  let(:owner) { FactoryBot.create :owner }
  let(:user) { FactoryBot.create :user }
  let(:klass) { "Rezzable::#{model_name.to_s.classify}".constantize }

  describe "creating a #{model_name}" do
    let(:path) { send("api_rezzable_#{model_name.to_s.pluralize}_path") }

    context 'as an owner' do
      let(:web_object) do
        FactoryBot.build model_name, user_id: owner.id
      end
      let(:atts) { { url: web_object.url } }

      it 'should return created status' do
        post path, params: atts.to_json,
                   headers: headers(
                     web_object, api_key: Settings.default.web_object.api_key
                   )
        expect(response.status).to eq 201
      end

      it "should create a #{model_name}" do
        expect do
          post path, params: atts.to_json,
                     headers: headers(
                       web_object, api_key: Settings.default.web_object.api_key
                     )
        end.to change(klass, :count).by(1)
      end

      it 'returns a nice message do ' do
        post path, params: atts.to_json,
                   headers: headers(
                     web_object, api_key: Settings.default.web_object.api_key
                   )
        expect(
          JSON.parse(response.body)['message']
        ).to eq("The #{model_name} is registered in the database.")
      end

      it 'returns the data' do
        post path, params: atts.to_json,
                   headers: headers(web_object,
                                    api_key: Settings.default.web_object.api_key)
        expect(JSON.parse(response.body)['data']).to eq(
          'api_key' => klass.last.api_key
        )
      end
    end

    context 'as a user' do
      let(:web_object) do
        FactoryBot.build model_name, user_id: user.id
      end
      let(:atts) { { url: web_object.url } }

      it 'should return unauthorized status' do
        post path, params: atts.to_json,
                   headers: headers(web_object,
                                    api_key: Settings.default.web_object.api_key)
        expect(response.status).to eq 401
      end
    end

    context 'user does not exist' do
      let(:web_object) do
        FactoryBot.build model_name
      end
      let(:atts) { { url: web_object.url } }

      it 'should return not found status' do
        post path, params: atts.to_json,
                   headers: headers(
                     web_object, avatar_key: SecureRandom.uuid,
                                 api_key: Settings.default.web_object.api_key
                   )
        expect(response.status).to eq 404
      end
    end
  end

  describe "showing #{model_name} data" do
    let(:path) { send("api_rezzable_#{model_name}_path", web_object.object_key) }

    context 'user exists' do
      let(:web_object) { FactoryBot.create model_name, user_id: owner.id }
      before(:each) { get path, headers: headers(web_object) }
      it 'should return OK status' do
        expect(response.status).to eq 200
      end

      it 'should return the data' do
        expect(JSON.parse(response.body)['data']).to eq(
          'updated_at' => web_object.updated_at.to_s(:long)
        )
      end
    end

    context 'user does not exists' do
      let(:web_object) { FactoryBot.create model_name }
      it 'should return NOT FOUND status' do
        get path, headers: headers(web_object, avatar_key: SecureRandom.uuid)
        expect(response.status).to eq 404
      end
    end
  end

  describe "updating a #{model_name}" do
    let(:path) { send("api_rezzable_#{model_name}_path", web_object.object_key) }
    context 'owner exists' do
      let(:web_object) { FactoryBot.create model_name, user_id: owner.id }
      let(:old_url) { web_object.url }
      context 'valid data' do
        let(:atts) { { description: 'some new idea', url: 'http://example.com' } }
        before(:each) { put path, params: atts.to_json, headers: headers(web_object) }
        it 'returns OK status' do
          expect(response.status).to eq 200
        end

        it 'returns a nice message' do
          expect(
            JSON.parse(response.body)['message']
          ).to eq "The #{model_name} has been updated in the database."
        end

        it "updates the #{model_name}" do
          web_object.reload
          expect(web_object.description).to eq atts[:description]
        end
      end

      context 'invalid data' do
        let(:atts) { { description: 'some new idea', url: '' } }
        before(:each) { put path, params: atts.to_json, headers: headers(web_object) }
        it 'returns BAD REQUEST status' do
          expect(response.status).to eq 400
        end

        it 'returns a helpful message' do
          expect(
            JSON.parse(response.body)['message']
          ).to eq "Validation failed: Url can't be blank"
        end

        it 'should not change the object' do
          expect(web_object.url).to eq old_url
        end
      end
    end

    context 'user does not exist' do
      let(:web_object) { FactoryBot.create model_name }
      let(:atts) { { description: 'some new idea', url: 'http://example.com' } }
      it 'should return NOT FOUND status' do
        get path, params: atts.to_json,
                  headers: headers(web_object, avatar_key: SecureRandom.uuid)
        expect(response.status).to eq 404
      end
    end
  end

  describe 'destroying' do
    let(:web_object) { FactoryBot.create model_name, user_id: owner.id }
    let(:path) { api_rezzable_terminal_path(web_object.object_key) }

    it 'should return OK status' do
      delete path, headers: headers(web_object)
      expect(response.status).to eq 200
    end

    it 'should return a nice message' do
      delete path, headers: headers(web_object)
      expect(
        JSON.parse(response.body)['message']
      ).to eq "The #{model_name} was removed from the database."
    end

    it 'should delete the object' do
      web_object.touch
      expect do
        delete path, headers: headers(web_object)
      end.to change(klass, :count).by(-1)
    end
  end
end

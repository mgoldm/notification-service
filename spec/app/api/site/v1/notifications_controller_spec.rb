# frozen_string_literal: true

describe Api::Site::V1::NotificationsController, type: :controller do
  include JwtUser

  let(:uuid) { notification.uuid }
  let!(:notification) { create(:notification, user: user, status: :new) }

  describe '#GET index' do
    let(:expected_attrs) do
      {
        button_title: notification.button_title,
        button_url: notification.button_url,
        description: notification.description,
        status: notification.status,
        style: notification.style,
        title: notification.title,
        uuid: uuid,
        is_closable: true,
        created_at: notification.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      }
    end

    context 'when no closed notifications exist' do
      before { get :index }

      it 'returns records' do
        expect(parsed_body).to eq([expected_attrs])
      end
    end

    context 'when closed records exist' do
      before do
        create(:notification, status: :closed, user: user)
        get :index
      end

      it 'returns only opened records' do
        expect(parsed_body).to eq([expected_attrs])
      end
    end

    context 'when all statuses exist' do
      before do
        create(:notification, user: user, status: :read)
        create(:notification, status: :closed, user: user)
        get :index
      end

      it 'excludes closed records' do
        expect(parsed_body.pluck(:status).sort).to eq(%w[new read])
      end
    end
  end

  describe '#PUT read' do
    context 'when record exists' do
      before { put :read, params: { uuid: uuid } }

      it 'marks notification as read' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body[:status]).to eq('read')
      end
    end

    context 'when record does not exist' do
      before { put :read, params: { uuid: 'nonexistent' } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#PUT read_all' do
    before do
      create_list(:notification, 3, user: user, status: :new)
      put :read_all
    end

    it 'marks all notifications as read' do
      expect(parsed_body.pluck(:status).uniq).to eq(['read'])
    end
  end

  describe '#PUT close' do
    context 'when record exists' do
      before { put :close, params: { uuid: uuid } }

      it 'marks notification as closed' do
        expect(response).to have_http_status(:ok)
        expect(parsed_body[:status]).to eq('closed')
      end
    end

    context 'when record does not exist' do
      before { put :close, params: { uuid: 'nonexistent' } }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

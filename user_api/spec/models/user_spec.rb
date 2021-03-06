# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  company_name :string
#  email        :string           not null
#  name         :string           not null
#  tel          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:model) { User }

  describe '# validations' do
    let(:user) { build(:user) }

    context 'name が blank の場合' do
      it 'バリデーションに引っかかる' do
        expected_error = '名前を入力してください'

        user.name = ''
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }

        user.name = nil
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }
      end
    end

    context 'email が正しいフォーマットではない場合' do
      it 'バリデーションに引っかかる' do
        expected_error = 'Emailは不正な値です'

        user.email = ''
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }

        user.email = nil
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }

        user.email = 'email.email.com'
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }
      end
    end

    context 'email が登録済みの場合' do
      it 'バリデーションに引っかかる' do
        expected_error = 'Emailはすでに存在します'

        exist_user = create :user
        user.email = exist_user.email
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }
      end
    end

    context 'tel が正しいフォーマットでない場合' do
      it 'バリデーションに引っかかる' do
        expected_error = '電話番号は不正な値です'

        user.tel = ''
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }

        user.tel = nil
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }

        user.tel = '123456789011'
        user.valid?
        is_asserted_by { user.errors.full_messages.first == expected_error }
      end
    end
  end

  describe '# scopes' do
    before do
      create :user, company_name: 'target_company_name', name: 'target_name', email: 'target_email@example.com'
      create_list :user, 5
    end

    context 'company_name_cont' do
      it '会社名に対してLIKE検索できる' do
        is_asserted_by { model.company_name_cont('target').size == 1 }
      end
    end

    context 'name_cont' do
      it '顧客名に対してLIKE検索できる' do
        is_asserted_by { model.name_cont('target').size == 1 }
      end
    end

    context 'email_cont' do
      it 'Emailに対してLIKE検索できる' do
        is_asserted_by { model.email_cont('target').size == 1 }
      end
    end

    context 'fields_cont' do
      it '会社名、顧客名、Emailに対してLIKE検索できる' do
        is_asserted_by { model.fields_cont('target_comp').size == 1 }
        is_asserted_by { model.fields_cont('target_name').size == 1 }
        is_asserted_by { model.fields_cont('target_email').size == 1 }
      end
    end
  end

  describe '# timestamps_to_unix' do
    let(:user) { create :user }

    context 'created_at_unix' do
      it 'created_atがunix_timeで出力される' do
        is_asserted_by { user.created_at_unix == user.created_at.to_i }
      end
    end

    context 'updated_at_unix' do
      it 'updated_atがunix_timeで出力される' do
        is_asserted_by { user.updated_at_unix == user.updated_at.to_i }
      end
    end
  end
end

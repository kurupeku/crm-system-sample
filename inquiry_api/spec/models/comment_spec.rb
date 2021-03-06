# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  inquiry_id :bigint           not null
#  staff_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_comments_on_inquiry_id  (inquiry_id)
#  index_comments_on_staff_id    (staff_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (inquiry_id => inquiries.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:model) { Comment }

  describe '# validations' do
    let(:comment) { build :comment }

    context 'contentが空の場合' do
      it 'バリデーションに弾かれる' do
        expected_error = '内容を入力してください'

        comment.content = ''
        comment.valid?
        is_asserted_by { comment.errors.full_messages.first == expected_error }

        comment.content = nil
        comment.valid?
        is_asserted_by { comment.errors.full_messages.first == expected_error }
      end
    end

    context 'user_idが空の場合' do
      it '関連するInquiryからuser_idを補完してくる' do
        comment.user_id = nil
        comment.valid?
        is_asserted_by { comment.user_id == comment.inquiry.user_id }
      end
    end

    context '親のInquiryのuser_idが変更になった場合' do
      it 'そのuser_idを紐づくCommentに反映する' do
        comment.save

        new_user_id = comment.inquiry.user_id + 1
        comment.inquiry.update user_id: new_user_id
        comment.reload
        is_asserted_by { comment.user_id == new_user_id }
      end
    end
  end

  describe '# scopes' do
    let(:inquiry_1) { create :inquiry }
    let(:inquiry_2) { create :inquiry }
    before do
      3.times { create :comment, inquiry: inquiry_1 }
      2.times { create :comment, inquiry: inquiry_2 }
    end

    context 'inquiry_id_eq' do
      it 'inquiry_idが一致するレコードを取得できる' do
        is_asserted_by { model.inquiry_id_eq(inquiry_1.id).size == 3 }
      end
    end
  end
end

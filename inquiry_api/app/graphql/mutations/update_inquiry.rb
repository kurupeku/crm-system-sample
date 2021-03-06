# frozen_string_literal: true

module Mutations
  class UpdateInquiry < BaseMutation
    class UpdateProgressInput < Types::BaseInputObject
      argument :rank, Integer, required: true
      argument :staff_id, Integer, required: false
    end

    argument :id, ID, required: true
    argument :company_name, String, required: false
    argument :name, String, required: false
    argument :email, String, required: false
    argument :tel, String, required: false
    argument :number_of_users, Integer, required: false
    argument :introductory_term, String, required: false
    argument :detail, String, required: false
    argument :user_id, Integer, required: false
    argument :menu_ids, [Integer], required: false
    argument :progress, UpdateProgressInput, required: false

    type Types::InquiryType

    def resolve(id:, **args)
      inquiry = Inquiry.find(id)
      inquiry.transaction do
        inquiry.assign_attributes inquiry_params(args)
        inquiry.progress.update! progress_params(args[:progress]) if args[:progress].present?
        inquiry.save! && inquiry
      end
    end

    private

    def inquiry_params(args)
      args.reject do |key, _|
        key == :progress
      end
    end

    def progress_params(progress)
      %i[rank staff_id].map do |key|
        [key, progress.send(key)]
      end.reject(&:blank?).to_h
    end
  end
end

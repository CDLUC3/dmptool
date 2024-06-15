# frozen_string_literal: true

# Controller that handles Answers to DMP questions
class AnswersController < ApplicationController
  respond_to :html
  include ConditionsHelper

  # POST /answers/create_or_update
  # TODO: Why!? This method is overly complex. Needs a serious refactor!
  #       We should break apart into separate create/update actions to simplify
  #       logic and we should stop using custom JSON here and instead use
  #       `remote: true` in the <form> tag and just send back the ERB.
  #       Consider using ActionCable for the progress bar(s)
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def create_or_update
    p_params = permitted_params

    # First it is checked plan exists and question exist for that plan
    begin
# SELECT `plans`.* FROM `plans` WHERE `plans`.`id` = 121295 LIMIT 1
      p = Plan.find(p_params[:plan_id])
# SELECT 1 AS one FROM `plans` INNER JOIN `templates` ON `templates`.`id` = `plans`.`template_id` INNER JOIN `phases` ON `phases`.`template_id` = `templates`.`id` INNER JOIN `sections` ON `sections`.`phase_id` = `phases`.`id` INNER JOIN `questions` ON `questions`.`section_id` = `sections`.`id` WHERE `plans`.`id` = 121295 AND `questions`.`id` = 4027 LIMIT 1
      unless p.question_exists?(p_params[:question_id])
        # rubocop:disable Layout/LineLength
        render(status: :not_found, json: {
                 msg: format(_('There is no question with id %{question_id} associated to plan id %{plan_id} for which to create or update an answer'), question_id: p_params[:question_id], plan_id: p_params[:plan_id])
               })
        # rubocop:enable Layout/LineLength
        return
      end
    rescue ActiveRecord::RecordNotFound
      # rubocop:disable Layout/LineLength
      render(status: :not_found, json: {
               msg: format(_('There is no plan with id %{id} for which to create or update an answer'), id: p_params[:plan_id])
             })
      # rubocop:enable Layout/LineLength
      return
    end

# SELECT `questions`.* FROM `questions` WHERE `questions`.`id` = 4027 ORDER BY `questions`.`number` ASC LIMIT 1
    q = Question.find(p_params[:question_id])

    # rubocop:disable Metrics/BlockLength
    Answer.transaction do
      args = p_params
      # Answer model does not understand :standards so remove it from the params
      standards = args[:standards]
      args.delete(:standards)

# SELECT `answers`.* FROM `answers` WHERE `answers`.`plan_id` = 121295 AND `answers`.`question_id` = 4027 LIMIT 1
      @answer = Answer.find_by!(
        plan_id: args[:plan_id],
        question_id: args[:question_id]
      )
# SELECT `users`.* FROM `users` WHERE `users`.`id` = 118750 ORDER BY `users`.`id` ASC LIMIT 1
# SELECT `plans`.* FROM `plans` WHERE `plans`.`id` = 121295 LIMIT 1
# SELECT `roles`.* FROM `roles` WHERE `roles`.`plan_id` = 121295
      authorize @answer

# INSERT INTO `answers`
      @answer.update(args.merge(user_id: current_user.id))
      if args[:question_option_ids].present?
        # Saves the record with the updated_at set to the current time.
        # Needed if only answer.question_options is updated
        @answer.touch
      end
      if q.question_format.rda_metadata?
        @answer.update_answer_hash(
          JSON.parse(standards.to_json), args[:text]
        )
        @answer.save!
      end
    # TODO: this is madness. Why not just do a find_or_initialize_by above?
    rescue ActiveRecord::RecordNotFound
      @answer = Answer.new(args.merge(user_id: current_user.id))
      @answer.lock_version = 1
      authorize @answer
# SELECT `question_formats`.* FROM `question_formats` WHERE `question_formats`.`id` = 1 LIMIT 1
      if q.question_format.rda_metadata?
        @answer.update_answer_hash(
          JSON.parse(standards.to_json), args[:text]
        )
      end
# SELECT `questions`.* FROM `questions` WHERE `questions`.`id` = 4027 ORDER BY `questions`.`number` ASC LIMIT 1
# SELECT `users`.* FROM `users` WHERE `users`.`id` = 118750 LIMIT 1
# SELECT 1 AS one FROM `answers` WHERE `answers`.`question_id` = 4027 AND `answers`.`plan_id` = 121295 LIMIT 1
# INSERT INTO `answers`
      @answer.save!
# SELECT `subscriptions`.* FROM `subscriptions` WHERE `subscriptions`.`plan_id` = 121295

    rescue ActiveRecord::StaleObjectError
      @stale_answer = @answer
      @answer = Answer.find_by(
        plan_id: args[:plan_id],
        question_id: args[:question_id]
      )
    end
    # rubocop:enable Metrics/BlockLength

    # TODO: Seems really strange to do this check. If its false it returns an
    #      200 with an empty body. We should update to send back some JSON. The
    #      check should probably happen on create/update
    # rubocop:disable Style/GuardClause

    if @answer.present?



# briley - 6/14 17:17
#          attempt to fix extremely slow query on one of the requests that was returning a 502

#      @plan = Plan.includes(
#        sections: {
#          questions: %i[
#            answers
#            question_format
#          ]
#        }
#      ).find(p_params[:plan_id])
      @plan = Plan.includes(answers: { question: :question_format }).find(p_params[:plan_id])



      @question = @answer.question
      @section = @plan.sections.find_by(id: @question.section_id)
      template = @section.phase.template

      remove_list_after = remove_list(@plan)

      all_question_ids = @plan.questions.pluck(:id)
      # rubocop pointed out that these variable is not used
      # all_answers = @plan.answers
      qn_data = {
        to_show: all_question_ids - remove_list_after,
        to_hide: remove_list_after
      }

      section_data = []
      @plan.sections.each do |section|
        next if section.number < @section.number

        # rubocop pointed out that these variables are not used
        # n_qs, n_ans = check_answered(section, qn_data[:to_show], all_answers)
        this_section_info = {
          sec_id: section.id,
          no_qns: num_section_questions(@plan, section),
          no_ans: num_section_answers(@plan, section)
        }
        section_data << this_section_info
      end

      send_webhooks(current_user, @answer)
      render json: {
        qn_data: qn_data,
        section_data: section_data,
        'question' => {
          'id' => @question.id,
          'answer_lock_version' => @answer.lock_version,
          'locking' => if @stale_answer
                         render_to_string(partial: 'answers/locking', locals: {
                                            question: @question,
                                            answer: @stale_answer,
                                            user: @answer.user
                                          }, formats: [:html])
                       end,
          'form' => render_to_string(partial: 'answers/new_edit', locals: {
                                       template: template,
                                       question: @question,
                                       answer: @answer,
                                       readonly: false,
                                       locking: false,
                                       base_template_org: template.base_org
                                     }, formats: [:html]),
          'answer_status' => render_to_string(partial: 'answers/status', locals: {
                                                answer: @answer
                                              }, formats: [:html])
        },
        'plan' => {
          'id' => @plan.id,
          'progress' => render_to_string(partial: 'plans/progress', locals: {
                                           plan: @plan,
                                           current_phase: @section.phase
                                         }, formats: [:html])
        }
      }.to_json

    end
    # rubocop:enable Style/GuardClause
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  private

  # rubocop:disable Metrics/AbcSize
  def permitted_params
    permitted = params.require(:answer)
                      .permit(:id, :text, :plan_id, :user_id, :question_id,
                              :lock_version, question_option_ids: [], standards: {})

    # If question_option_ids has been filtered out because it was a
    # scalar value (e.g. radiobutton answer)
    if !params[:answer][:question_option_ids].nil? &&
       permitted[:question_option_ids].blank?
      permitted[:question_option_ids] = [params[:answer][:question_option_ids]]
    end
    permitted.delete(:id) if permitted[:id].blank?
    # If no question options has been chosen.
    permitted[:question_option_ids] = [] if params[:answer][:question_option_ids].nil?
    permitted
  end
  # rubocop:enable Metrics/AbcSize

  def check_answered(section, q_array, all_answers)
    n_qs = section.questions.count { |question| q_array.include?(question.id) }
    n_ans = all_answers.count { |ans| q_array.include?(ans.question.id) and ans.answered? }
    [n_qs, n_ans]
  end
end

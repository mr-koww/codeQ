json.answer @answer, :id, :body, :question_id, :best

json.answer do
  json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
  end

  json.current_user_id current_user.id
  json.question_user_id @answer.question.user_id

  json.i18n do
    json.best I18n.t('answer.label.best')
    json.edit I18n.t('answer.button.edit')
    json.delete I18n.t('answer.button.delete')
    json.delete_confirm I18n.t('answer.confirm.delete')
    json.attachment_label I18n.t('attachment.label.title')
  end

end

json.notice I18n.t('answer.notice.update.success')
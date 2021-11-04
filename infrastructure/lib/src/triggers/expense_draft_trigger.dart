class ExpenseDraftTriggers {
  static const delete_draft_after_insert_expense =
      'create trigger delete_draft_after_insert_expense'
      '    after insert on expenses'
      '    begin'
      '        delete from expense_drafts where id = new.id;'
      '    end;';
}

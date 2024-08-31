class ExpenseService
  include Singleton

  Node = Struct.new(:name, :amount)
  Edge = Struct.new(:from, :to, :amount)


  def build_expense(expense)
    expense.amount = expense.payers.map(&:amount).reduce(:+)
    participants_count = expense.payers.filter { |x| !x.exclude }.length + expense.debtors.length
    expense.amount_per_participant = expense.amount / participants_count

    amount_per_participant = expense.amount_per_participant

    expense.debtors.each do |debtor|
      debtor.amount = amount_per_participant
    end

    expense.payers.each do |payer|
      if payer.amount < amount_per_participant
        diff = amount_per_participant - payer.amount

        # look for existing debtor when it comes to updates
        debtor = expense.debtors.find { |debtor| debtor.name == payer.name }

        if debtor.present?
          debtor.amount = diff
        else
          expense.debtors.build(name: payer.name, amount: diff)
        end
      end
    end

    expense
  end

  def build_summary(expense_group)
    summary_mapping = {}
    payers_summary_mapping = {}
    debtors_summary_mapping = {}

    expense_group.expenses.each do |expense|
      expense.debtors.each do |debtor|
        debtors_summary_mapping[debtor.name] = (debtors_summary_mapping[debtor.name] || 0) + debtor.amount
      end

      expense.payers.each do |payer|
        if payer.amount > expense.amount_per_participant
          payers_summary_mapping[payer.name] = (payers_summary_mapping[payer.name] || 0) + payer.amount - expense.amount_per_participant
        end
      end
    end

    # keep only the net amount inflow/outflow
    (debtors_summary_mapping.keys & payers_summary_mapping.keys).each do |key|
      if payers_summary_mapping[key] > debtors_summary_mapping[key]
        payers_summary_mapping[key] = payers_summary_mapping[key] - debtors_summary_mapping[key]
        debtors_summary_mapping.delete(key)
      elsif payers_summary_mapping[key] < debtors_summary_mapping[key]
        debtors_summary_mapping[key] = debtors_summary_mapping[key] - payers_summary_mapping[key]
        payers_summary_mapping.delete(key)
      else
        payers_summary_mapping.delete(key)
        debtors_summary_mapping.delete(key)
      end
    end

    summary_mapping[:debt] = debtors_summary_mapping
    summary_mapping[:payer] = payers_summary_mapping
    summary_mapping
  end

  def build_action_graph(summary)
    # list of edges here, the edges indicate an payment from one user to another user
    graph = []

    sorted_payers = summary[:payer].sort_by { |_name, amount| -amount}.map { |name, amount| Node.new(name, amount)}
    sorted_debtors = summary[:debt].sort_by { |_name, amount| -amount}.map { |name, amount| Node.new(name, amount)}

    sorted_payers.each do |payer_node|
      sorted_debtors.each do |debtor_node|
        # consider this payer as settled if if the payer has to get less than one rupee from others
        break if payer_node.amount.floor < 1
        # consider this debtor as settled if he owes less than 1 rupee
        next if debtor_node.amount.floor < 1

        if payer_node.amount >= debtor_node.amount
          graph.push(Edge.new(debtor_node.name, payer_node.name, debtor_node.amount))
          payer_node.amount = payer_node.amount - debtor_node.amount
          debtor_node.amount = 0
        else
          graph.push(Edge.new(debtor_node.name, payer_node.name, payer_node.amount))
          debtor_node.amount = debtor_node.amount - payer_node.amount
          payer_node.amount = 0
        end
      end
    end

    graph
  end
end
class Equation
  attr_accessor :ls, :rs

  def initialize(ls,rs)
    @ls = ls
    @rs = rs
  end

  def copy
    if ls.is_a?(string) || ls.is_a?(integer)
      left_side = ls
    else
      left_side = ls.copy
    end
    if rs.is_a?(string) || rs.is_a?(integer)
      right_side = rs
    else
      right_side = rs.copy
    end
    eqn(left_side,right_side)
  end

  def ==(eqn)
    eqn.class == self.class && ls == eqn.ls && rs == eqn.rs
  end

  def solve_one_var_eqn
    #assume left exp, right num and it is one variable
    #reverse the outer most expression until 'x' is left
    curr_steps = [self.copy]
    i = 1
    while (ls.is_a?(string) && rs.is_a?(integer)) == false && i < 100 do
      reverse_last_step(curr_steps)
      evaluate_right_side(curr_steps)
      i += 1
    end
    curr_steps
  end

  def reverse_last_step(curr_steps)
    if ls.is_a?(addition)
      if ls.args[0].is_a?(integer)
        value = ls.args[0]
        self.ls = ls.args[1]
        self.rs = sbt(rs,value)
        curr_steps << self.copy
        return
      end
      if ls.args[1].is_a?(integer)
        value = ls.args[1]
        self.ls = ls.args[0]
        self.rs = sbt(rs,value)
        curr_steps << self.copy
        return
      end
    end
    if ls.is_a?(multiplication)
      if ls.args[0].is_a?(integer)
        value = ls.args[0]
        self.ls = ls.args[1]
        self.rs = div(rs,value)
        curr_steps << self.copy
        return
      end
      if ls.args[1].is_a?(integer)
        value = ls.args[1]
        self.ls = ls.args[0]
        self.rs = div(rs,value)
        curr_steps << self.copy
        return
      end
    end
  end

  def evaluate_right_side(curr_steps)
    self.rs = rs.evaluate_numeral
    curr_steps << self.copy
  end

end

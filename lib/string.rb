require './helpers/objectify_utilities'

include ObjectifyUtilities

class String
  def latex
    self
  end


  def greater?(exp)
    if exp.is_a?(String)
      self < exp
    elsif exp.is_a?(Numeric)
      true
    else
      self.greater?(exp.args.first)
    end
  end

  def sort_elements
    self
  end

  def shorten
    gsub!('\\left','')
    gsub!('\\right','')
    gsub!('\\displaystyle','')
    self
  end



  def correct_latex?
    objectify(self).latex.shorten == self
  end

  def expand
    [self]
  end

  # def flatit
  #   self
  # end

  def objectify
    original_string = self.dup
    original_string.gsub!(' ','')
    str_copy = empty_brackets(original_string.dup)

    mtp_check_str_copy = str_copy.dup
    mtp_check_str_ary = split_mtp_args(mtp_check_str_copy)

    #addition with subtraction
    if str_copy.include?('-') || str_copy.include?('+')
      str_args = []
      for i in 1..(str_copy.length-1) #do not check the first char for '-'
        if str_copy[-i] == '-' && (str_copy[-(i+1)] != '+' && str_copy[-(i+1)] != '-')
          minus_index = str_copy.length - i
          str_args << str_copy.slice(0..minus_index-1)
          str_args << str_copy.slice(minus_index+1..-1)

          reenter_addition_str_content(original_string,str_args)
          remove_enclosing_bracks(str_args)
          object_args = str_args.inject([]){ |r,e| r << e.objectify }
          return sbt(object_args)
        end

        if str_copy[-i] == '+'
          # eg:   found + at indices [7,10] for a strength of length 15
          # extend to [-1,7,10,15] in order to build slice_indices of
          # [[0,6],[8,9],[11,14]]
          plus_indices = []
          plus_indices << -1
          for j in i..str_copy.length
            if str_copy[-j] == '+'
              plus_indices.insert(1,str_copy.length - j)
            end
            if str_copy[-j] == '-'
              break
            end
          end
          plus_indices << str_copy.length

          slice_indices = []
          for k in 1..plus_indices.length-1
            slice_indices << [plus_indices[k-1]+1,plus_indices[k]-1]
          end

          slice_indices.each do |a|
            str_args << str_copy.slice(a[0]..a[1])
          end

          reenter_addition_str_content(original_string,str_args)
          remove_enclosing_bracks(str_args)


          object_args = str_args.inject([]){ |r,e| r << e.objectify }
          return add(object_args)
        end

      end

    end

    #multiplication
    if str_copy.include?('+') == false && mtp_check_str_ary.length > 1 # && not a fraction of legnth 1 or pwer of length 1
      str_args = split_mtp_args(str_copy)
      reenter_str_content(original_string,str_args)
      remove_enclosing_bracks(str_args)
      object_args = str_args.inject([]){ |r,e| r << e.objectify }
      return mtp(object_args)
    end

    # frac/div
    if mtp_check_str_ary.length == 1 && mtp_check_str_ary[0] =~ /^\\frac/
      str_args = split_mtp_args(str_copy)
      reenter_str_content(original_string,str_args)
      str_copy = str_args[0]
      top_indices = matching_brackets(str_copy,'{','}')
      numerator = str_copy.slice(top_indices[0]+1..top_indices[1]-1)
      str_copy.slice!(0..top_indices[1])
      bot_indices = matching_brackets(str_copy,'{','}')
      denominator = str_copy.slice(bot_indices[0]+1..bot_indices[1]-1)
      str_args = [numerator,denominator]
      object_args = str_args.inject([]){ |r,e| r << e.objectify }
      return div(object_args)
    end

    #power
    if mtp_check_str_ary.length == 1 && mtp_check_str_ary[0] =~ /\^/
      str_args = split_mtp_args(str_copy)
      reenter_str_content(original_string,str_args)
      str_copy = str_args[0]
      str_args = []
      if str_copy[0] != '('
        str_args = str_copy.split('^')
      else
        bracket_indices = matching_brackets(str_copy, brac_types[0][0], brac_types[0][1],1)
        str_args << str_copy[0..bracket_indices[1]]
        str_args << str_copy[bracket_indices[1]+2..-1]
      end
      remove_enclosing_bracks(str_args)
      object_args = str_args.inject([]){ |r,e| r << e.objectify }
      return pow(object_args)
    end

    #string variable
    if length == 1 && self =~ /[A-Za-z]/
      return self
    end

    #number
    if self =~ /(^(\d|\-)\d*)/
      return self.to_i
    end

    # return add(obj_args)  if _outer_func_is_add?
    # return sbt(obj_args)  if _outer_func_is_sbt?
    # return self.to_i      if _is_numeral?
    # return self           if _is_string?

  end

  def new_objectify

    original_string = self.dup
    original_string.gsub!(' ','')
    structure_str = empty_brackets(original_string.dup)

    if structure_str.outer_func_is_add?
      args = structure_str.add_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.new_objectify }
      return add(object_args)
    end

    if structure_str.outer_func_is_sbt?
      args = structure_str.sbt_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.new_objectify }
      return sbt(object_args)
    end

    if structure_str.outer_func_is_mtp?
      args = structure_str.mtp_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.new_objectify }
      return mtp(object_args)
    end

    if structure_str.outer_func_is_div?
      args = structure_str.div_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.new_objectify }
      return div(object_args)
    end

    if structure_str.is_string_var?
      return self
    end

    if structure_str.is_numeral?
      return self.to_i
    end

  end

  def add_args(original_string)
    plus_indices = []
    plus_indices << -1
    for j in 0..(length-1)
      plus_indices << j if self[j] == '+'
    end
    plus_indices << length

    slice_indices = []
    for k in 1..plus_indices.length-1
      slice_indices << [plus_indices[k-1]+1,plus_indices[k]-1]
    end

    str_args = []

    slice_indices.each do |a|
      str_args << self.slice(a[0]..a[1])
    end

    reenter_addition_str_content(original_string,str_args)
    remove_enclosing_bracks(str_args)

    str_args
  end

  def sbt_args(original_string)
    sbt_index = 0
    for i in 1..(length-1)
      if self[-i] == '-' && self[-(i+1)] != '-' && (self[-(i+1)] != '+' || i+1 == length)
        sbt_index = length - i
      end
    end
    args = [slice(0..sbt_index-1),slice(sbt_index+1..-1)]
    reenter_addition_str_content(original_string,args)
    remove_enclosing_bracks(args)
    args
  end


  def mtp_args(original_string)
    str_args = split_mtp_args(self)
    reenter_str_content(original_string,str_args)
    remove_enclosing_bracks(str_args)
    str_args
  end

  def div_args(original_string)
    top_indices = matching_brackets(original_string,'{','}')
    numerator = original_string.slice(top_indices[0]+1..top_indices[1]-1)
    original_string.slice!(0..top_indices[1])
    bot_indices = matching_brackets(original_string,'{','}')
    denominator = original_string.slice(bot_indices[0]+1..bot_indices[1]-1)
    [numerator,denominator]
  end

  def outer_func_is_add?
    return false if include?('+') == false
    for i in 1..(length-1)
      return false if self[-i] == '-' && self[-(i+1)] != '+'
      return true if self[-i] == '+'
    end
    return false
  end

  def outer_func_is_sbt?
    return false if include?('-') == false
    for i in 1..(length-1)
      return true if self[-i] == '-' && self[-(i+1)] != '+'
    end
    return false
  end

  def outer_func_is_mtp?
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length == 1
    return true
  end

  def outer_func_is_div?
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length > 1
    return true if self =~ /^\\frac/
    return false
  end

  def outer_func_is_pow?
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length > 1
    return true if self =~ /\^/
    return false
  end

  def is_numeral?
    self.to_i.to_s == self
  end

  def is_string_var?
    !!(self =~ /[A-Za-z]/) && length == 1
  end

end

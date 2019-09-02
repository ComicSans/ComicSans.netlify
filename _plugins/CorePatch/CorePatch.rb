require "date"

# See https://edgeguides.rubyonrails.org/active_support_core_extensions.html

module Jekyll

  # Add patches to older ruby versions
  class CorePatch < Jekyll::Generator

    def generate(site)
      puts "[Active Support Core Extensions] Injecting patches..."
    end

  end

end

class Object
  # An object is blank if it's false, empty, or a whitespace string.
  # For example, +nil+, '', '   ', [], {}, and +false+ are all blank.
  #
  # This simplifies
  #
  #   !address || address.empty?
  #
  # to
  #
  #   address.blank?
  #
  # @return [true, false]
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  # An object is present if it's not blank.
  #
  # @return [true, false]
  def present?
    !blank?
  end

end

class NilClass
  # +nil+ is blank:
  #
  #   nil.blank? # => true
  #
  # @return [true]
  def blank?
    true
  end
end

class FalseClass
  # +false+ is blank:
  #
  #   false.blank? # => true
  #
  # @return [true]
  def blank?
    true
  end
end

class TrueClass
  # +true+ is not blank:
  #
  #   true.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class Array
  # An array is blank if it's empty:
  #
  #   [].blank?      # => true
  #   [1,2,3].blank? # => false
  #
  # @return [true, false]
  alias_method :blank?, :empty?

  # Splits or iterates over the array in groups of size +number+,
  # padding any remaining slots with +fill_with+ unless it is +false+.
  #
  #   %w(1 2 3 4 5 6 7 8 9 10).in_groups_of(3) {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5", "6"]
  #   ["7", "8", "9"]
  #   ["10", nil, nil]
  #
  #   %w(1 2 3 4 5).in_groups_of(2, '&nbsp;') {|group| p group}
  #   ["1", "2"]
  #   ["3", "4"]
  #   ["5", "&nbsp;"]
  #
  #   %w(1 2 3 4 5).in_groups_of(2, false) {|group| p group}
  #   ["1", "2"]
  #   ["3", "4"]
  #   ["5"]
  def in_groups_of(number, fill_with = nil)
    if number.to_i <= 0
      raise ArgumentError,
        "Group size must be a positive integer, was #{number.inspect}"
    end

    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat(Array.new(padding, fill_with))
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      collection.each_slice(number).to_a
    end
  end

  # Splits or iterates over the array in +number+ of groups, padding any
  # remaining slots with +fill_with+ unless it is +false+.
  #
  #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3) {|group| p group}
  #   ["1", "2", "3", "4"]
  #   ["5", "6", "7", nil]
  #   ["8", "9", "10", nil]
  #
  #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3, '&nbsp;') {|group| p group}
  #   ["1", "2", "3", "4"]
  #   ["5", "6", "7", "&nbsp;"]
  #   ["8", "9", "10", "&nbsp;"]
  #
  #   %w(1 2 3 4 5 6 7).in_groups(3, false) {|group| p group}
  #   ["1", "2", "3"]
  #   ["4", "5"]
  #   ["6", "7"]
  def in_groups(number, fill_with = nil)
    # size.div number gives minor group size;
    # size % number gives how many objects need extra accommodation;
    # each group hold either division or division + 1 items.
    division = size.div number
    modulo = size % number

    # create a new array avoiding dup
    groups = []
    start = 0

    number.times do |index|
      length = division + (modulo > 0 && modulo > index ? 1 : 0)
      groups << last_group = slice(start, length)
      last_group << fill_with if fill_with != false &&
        modulo > 0 && length == division
      start += length
    end

    if block_given?
      groups.each { |g| yield(g) }
    else
      groups
    end
  end

  # Divides the array into one or more subarrays based on a delimiting +value+
  # or the result of an optional block.
  #
  #   [1, 2, 3, 4, 5].split(3)              # => [[1, 2], [4, 5]]
  #   (1..10).to_a.split { |i| i % 3 == 0 } # => [[1, 2], [4, 5], [7, 8], [10]]
  def split(value = nil)
    arr = dup
    result = []
    if block_given?
      while (idx = arr.index { |i| yield i })
        result << arr.shift(idx)
        arr.shift
      end
    else
      while (idx = arr.index(value))
        result << arr.shift(idx)
        arr.shift
      end
    end
    result << arr
  end
end

class Hash

  # A hash is blank if it's empty:
  #
  #   {}.blank?                # => true
  #   { key: 'value' }.blank?  # => false
  #
  # @return [true, false]
  alias_method :blank?, :empty?

  # Older versions of Ruby may have a different implementation of transform_keys
  def transform_keys
    return enum_for(:transform_keys) { size } unless block_given?
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

end

class String

end

class Numeric #:nodoc:
  # No number is blank:
  #
  #   1.blank? # => false
  #   0.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class Time #:nodoc:
  # No Time is blank:
  #
  #   Time.now.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class DateTime
  class << self
    # Returns <tt>Time.zone.now.to_datetime</tt> when <tt>Time.zone</tt> or
    # <tt>config.time_zone</tt> are set, otherwise returns
    # <tt>Time.now.to_datetime</tt>.
    def current
      ::Time.zone ? ::Time.zone.now.to_datetime : ::Time.now.to_datetime
    end
  end

  # Returns the number of seconds since 00:00:00.
  #
  #   DateTime.new(2012, 8, 29,  0,  0,  0).seconds_since_midnight # => 0
  #   DateTime.new(2012, 8, 29, 12, 34, 56).seconds_since_midnight # => 45296
  #   DateTime.new(2012, 8, 29, 23, 59, 59).seconds_since_midnight # => 86399
  def seconds_since_midnight
    sec + (min * 60) + (hour * 3600)
  end

  # Returns the number of seconds until 23:59:59.
  #
  #   DateTime.new(2012, 8, 29,  0,  0,  0).seconds_until_end_of_day # => 86399
  #   DateTime.new(2012, 8, 29, 12, 34, 56).seconds_until_end_of_day # => 41103
  #   DateTime.new(2012, 8, 29, 23, 59, 59).seconds_until_end_of_day # => 0
  def seconds_until_end_of_day
    end_of_day.to_i - to_i
  end

  # Returns the fraction of a second as a +Rational+
  #
  #   DateTime.new(2012, 8, 29, 0, 0, 0.5).subsec # => (1/2)
  def subsec
    sec_fraction
  end

  # Returns a new DateTime where one or more of the elements have been changed
  # according to the +options+ parameter. The time options (<tt>:hour</tt>,
  # <tt>:min</tt>, <tt>:sec</tt>) reset cascadingly, so if only the hour is
  # passed, then minute and sec is set to 0. If the hour and minute is passed,
  # then sec is set to 0. The +options+ parameter takes a hash with any of these
  # keys: <tt>:year</tt>, <tt>:month</tt>, <tt>:day</tt>, <tt>:hour</tt>,
  # <tt>:min</tt>, <tt>:sec</tt>, <tt>:offset</tt>, <tt>:start</tt>.
  #
  #   DateTime.new(2012, 8, 29, 22, 35, 0).change(day: 1)              # => DateTime.new(2012, 8, 1, 22, 35, 0)
  #   DateTime.new(2012, 8, 29, 22, 35, 0).change(year: 1981, day: 1)  # => DateTime.new(1981, 8, 1, 22, 35, 0)
  #   DateTime.new(2012, 8, 29, 22, 35, 0).change(year: 1981, hour: 0) # => DateTime.new(1981, 8, 29, 0, 0, 0)
  def change(options)
    if new_nsec = options[:nsec]
      raise ArgumentError, "Can't change both :nsec and :usec at the same time: #{options.inspect}" if options[:usec]
      new_fraction = Rational(new_nsec, 1000000000)
    else
      new_usec = options.fetch(:usec, (options[:hour] || options[:min] || options[:sec]) ? 0 : Rational(nsec, 1000))
      new_fraction = Rational(new_usec, 1000000)
    end

    raise ArgumentError, "argument out of range" if new_fraction >= 1

    ::DateTime.civil(
      options.fetch(:year, year),
      options.fetch(:month, month),
      options.fetch(:day, day),
      options.fetch(:hour, hour),
      options.fetch(:min, options[:hour] ? 0 : min),
      options.fetch(:sec, (options[:hour] || options[:min]) ? 0 : sec) + new_fraction,
      options.fetch(:offset, offset),
      options.fetch(:start, start)
    )
  end

  # Uses Date to provide precise Time calculations for years, months, and days.
  # The +options+ parameter takes a hash with any of these keys: <tt>:years</tt>,
  # <tt>:months</tt>, <tt>:weeks</tt>, <tt>:days</tt>, <tt>:hours</tt>,
  # <tt>:minutes</tt>, <tt>:seconds</tt>.
  def advance(options)
    unless options[:weeks].nil?
      options[:weeks], partial_weeks = options[:weeks].divmod(1)
      options[:days] = options.fetch(:days, 0) + 7 * partial_weeks
    end

    unless options[:days].nil?
      options[:days], partial_days = options[:days].divmod(1)
      options[:hours] = options.fetch(:hours, 0) + 24 * partial_days
    end

    d = to_date.advance(options)
    datetime_advanced_by_date = change(year: d.year, month: d.month, day: d.day)
    seconds_to_advance = \
      options.fetch(:seconds, 0) +
      options.fetch(:minutes, 0) * 60 +
      options.fetch(:hours, 0) * 3600

    if seconds_to_advance.zero?
      datetime_advanced_by_date
    else
      datetime_advanced_by_date.since(seconds_to_advance)
    end
  end

  # Returns a new DateTime representing the time a number of seconds ago.
  # Do not use this method in combination with x.months, use months_ago instead!
  def ago(seconds)
    since(-seconds)
  end

  # Returns a new DateTime representing the time a number of seconds since the
  # instance time. Do not use this method in combination with x.months, use
  # months_since instead!
  def since(seconds)
    self + Rational(seconds, 86400)
  end
  alias :in :since

  # Returns a new DateTime representing the start of the day (0:00).
  def beginning_of_day
    change(hour: 0)
  end
  alias :midnight :beginning_of_day
  alias :at_midnight :beginning_of_day
  alias :at_beginning_of_day :beginning_of_day

  # Returns a new DateTime representing the middle of the day (12:00)
  def middle_of_day
    change(hour: 12)
  end
  alias :midday :middle_of_day
  alias :noon :middle_of_day
  alias :at_midday :middle_of_day
  alias :at_noon :middle_of_day
  alias :at_middle_of_day :middle_of_day

  # Returns a new DateTime representing the end of the day (23:59:59).
  def end_of_day
    change(hour: 23, min: 59, sec: 59, usec: Rational(999999999, 1000))
  end
  alias :at_end_of_day :end_of_day

  # Returns a new DateTime representing the start of the hour (hh:00:00).
  def beginning_of_hour
    change(min: 0)
  end
  alias :at_beginning_of_hour :beginning_of_hour

  # Returns a new DateTime representing the end of the hour (hh:59:59).
  def end_of_hour
    change(min: 59, sec: 59, usec: Rational(999999999, 1000))
  end
  alias :at_end_of_hour :end_of_hour

  # Returns a new DateTime representing the start of the minute (hh:mm:00).
  def beginning_of_minute
    change(sec: 0)
  end
  alias :at_beginning_of_minute :beginning_of_minute

  # Returns a new DateTime representing the end of the minute (hh:mm:59).
  def end_of_minute
    change(sec: 59, usec: Rational(999999999, 1000))
  end
  alias :at_end_of_minute :end_of_minute

  # Returns a <tt>Time</tt> instance of the simultaneous time in the system timezone.
  def localtime(utc_offset = nil)
    utc = new_offset(0)

    Time.utc(
      utc.year, utc.month, utc.day,
      utc.hour, utc.min, utc.sec + utc.sec_fraction
    ).getlocal(utc_offset)
  end
  alias_method :getlocal, :localtime

  # Returns a <tt>Time</tt> instance of the simultaneous time in the UTC timezone.
  #
  #   DateTime.civil(2005, 2, 21, 10, 11, 12, Rational(-6, 24))     # => Mon, 21 Feb 2005 10:11:12 -0600
  #   DateTime.civil(2005, 2, 21, 10, 11, 12, Rational(-6, 24)).utc # => Mon, 21 Feb 2005 16:11:12 UTC
  def utc
    utc = new_offset(0)

    Time.utc(
      utc.year, utc.month, utc.day,
      utc.hour, utc.min, utc.sec + utc.sec_fraction
    )
  end
  alias_method :getgm, :utc
  alias_method :getutc, :utc
  alias_method :gmtime, :utc

  # Returns +true+ if <tt>offset == 0</tt>.
  def utc?
    offset == 0
  end

  # Returns the offset value in seconds.
  def utc_offset
    (offset * 86400).to_i
  end

  # Layers additional behavior on DateTime#<=> so that Time and
  # ActiveSupport::TimeWithZone instances can be compared with a DateTime.
  def <=>(other)
    if other.respond_to? :to_datetime
      super other.to_datetime rescue nil
    else
      super
    end
  end
end

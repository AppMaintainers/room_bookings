class BookingValidator < ActiveModel::Validator

  def validate(record)
    Booking.all.each do |b|
      if record[:room] == b[:room] and record[:id] != b[:id]
        if (record[:start] <=> b[:end]) < 0 and (record[:end] <=> b[:start]) > 0
          record.errors[:base] << "The room is already booked during this time"
          break
        end
      end
    end
  end

end


class Booking < ActiveRecord::Base

  validates :room, presence: true, format: { with: /\A\d{2}[1-9]\z/ }
  validates_date :start, :on => :create, :on_or_after => :today
  validates_date :start, :on => :update, :before => :end
  validates_date :end, :after => :start
  validates_with BookingValidator

end

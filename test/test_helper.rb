# frozen_string_literal: true

require "bundler/setup"
require "twemoji"
require "minitest/autorun"

module Twemoji
  module TestExtensions
    def assert_nothing_raised
      yield if block_given?
    end

    class DiversityEmoji
      def self.all
        BASES.map { |base| diversitify(base) }
      end

      BASES = %w(
        :santa: :snowboarder: :runner: :surfer: :horse_racing: :swimmer: :weight_lifter: :ear:
        :nose: :point_up_2: :point_down: :point_left: :point_right: :facepunch: :wave: :ok_hand:
        :+1: :-1: :clap: :open_hands: :boy: :girl: :man: :woman: :cop: :bride_with_veil:
        :person_with_blond_hair: :man_with_gua_pi_mao: :man_with_turban: :older_man: :older_woman:
        :baby: :construction_worker: :princess: :angel: :information_desk_person: :guardsman:
        :dancer: :nail_care: :massage: :haircut: :muscle: :sleuth_or_spy:
        :raised_hand_with_fingers_splayed: :middle_finger: :spock-hand: :no_good: :ok_woman: :bow:
        :raising_hand: :raised_hands: :person_frowning: :person_with_pouting_face: :pray: :rowboat:
        :bicyclist: :mountain_bicyclist: :walking: :bath: :the_horns: :point_up: :person_with_ball:
        :fist: :hand: :victory_hand: :writing_hand:
      )
      private_constant :BASES

      def self.diversitify(base)
        "#{base} #{base}:skin-tone-2: #{base}:skin-tone-3: #{base}:skin-tone-4: #{base}:skin-tone-5: #{base}:skin-tone-6:"
      end
      private_class_method :diversitify
    end

  end
end

class Minitest::Test
  include Twemoji::TestExtensions
end

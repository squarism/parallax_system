#!/usr/bin/env ruby

$: << File.join(File.dirname($0),"..","config")
require 'environment'

class Fixnum
  def ordinal
    %w[first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth][self - 1]
  end
 end

GameboxApp.run ARGV, ENV

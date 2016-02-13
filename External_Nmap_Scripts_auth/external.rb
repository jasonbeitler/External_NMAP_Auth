#!/usr/bin/env ruby
#
#	Ruby 1.9 Code
#	Coded by: Jason Beitler
#

# Vars
begin
	email_hd        = '/email_header_default.txt'
	email           = '/email_header.txt'
	homeDir         = '/home/user'
	outFile         = "results"
	scanDir	 	= '/External_Nmap_Scripts_auth/ip_list'
	appDir          = "#{homeDir}/External_Nmap_Scripts_auth"
	targetList 	= "#{homeDir +  scanDir}/external_targets"
	confDir         = "#{appDir}/email_conf"
	logDir          = "#{appDir}/logs/"
	logFile         = Time.now.to_s.gsub(/ /,'_')
	$logWriter      = File.new(logDir + logFile,'w')
	$finalOut		= <<-HEADER
From: external@no-reply.com
To: email@address
Subject: Daily Nmap Scan - External

HEADER
rescue Exception => e
	puts "[!] Error: #{e.message}"
end

# Methods

# Writes messages to STDOUT and logfile
def log(message)
	begin
		puts "#{message}"
		$logWriter.puts(message + "\n")
     rescue Exception => e
		puts "[!] Error: #{e.message}"
	 end
end

# Make final output for email
def makeEmail(aFile)
        begin
                inRead = File.open(aFile,'r')
                while line = inRead.gets
                        $finalOut << line
                end
        rescue Exception => e
                log("[!] Error: #{e.message}")
        ensure
                inRead.close if inRead
        end
end

# Begin


log("[+]Starting nmap.") # Status Update


# Scan Static Range
log("[+]Scanning External IP Range...")
exitCode = system(`nmap -iL #{targetList} -sS -T4 -PN -p1- -R --open -oN #{outFile}`)


# Send Report

log("[+]Emailing report.")
$logWriter.close # Close log writer object

# Append log output to a variable to be put into the message body of the email
makeEmail(logDir + logFile)
makeEmail('results')

# Send Email
require 'net/smtp'
require 'rubygems'
require 'tlsmail'
#smtp = Net::SMTP.new 'smtp.gamil.com', 587
begin

#smtp.enable_starttls

        Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        Net::SMTP.start('smtp.gmail.com', 587, Socket.gethostname, 'email account', 'passwd', :login) do |server|
                server.send_message($finalOut, 'To:Email', [ 'To:email']) # Params: send_message(message_body, from, to[])
        end
rescue Exception => e
        puts "[!] Error: #{e.message}"
end

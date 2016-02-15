README

GEM required
 - gmail_sender
 - tlsmail
 - gem install gmail_sender tlsmail

 - At the bottom of the external.rb you will see the SMTP settings. Make sure you update them with your relevent info

 - In external.rb you will need to change the home directory (Line 13)

 - In email_conf you will need to update both files with a To:email @ddress

 - In ip_list you will need to add the IP(s) you wish to scan. 
 	1 IP perline 
 	Sadly at this time masscan ignores hosts file
 	
 - You can also adjust the nmap args if these dont fit your needs.

 - There is an external.rb and external_test.rb. This will allow you to always have a working copy and allow you to test new settings.

 **DISCLAIMER**
These scripts are for use with your IPs or IPs you have premission to scan. I will not take responsibility if you use these scripts to scan IPs you do not have premission to scan or otherwise use them in a malicious way. 
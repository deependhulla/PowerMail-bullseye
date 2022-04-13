#!/bin/sh

## various Reference link for study
#https://github.com/elubow/dspam-spamassassin
#http://www.surbl.org/lists
#ttps://www.spamcop.net/fom-serve/cache/291.html
## https://wiki.apache.org/spamassassin/CustomRulesets
## http://www.chaosreigns.com/mtx/
##https://www.howtoforge.com/adding-and-updating-spamassassin-rulesets-with-rulesdujour
## http://wiki.qmailtoaster.com/index.php/Install_Pyzor

#sa update channel http://daryl.dostech.ca/sa-update/sare/sare-sa-update-howto.txt

wget http://daryl.dostech.ca/sa-update/sare/GPG.KEY -O /etc/spamassassin/daryl.dostech.ca-GPG.KEY
sa-update --import /etc/spamassassin/daryl.dostech.ca-GPG.KEY
echo > /etc/spamassassin/sare-sa-update-channels.txt
echo "updates.spamassassin.org" >> /etc/spamassassin/sare-sa-update-channels.txt
echo "70_sare_adult.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
sa-update --channelfile /etc/spamassassin/sare-sa-update-channels.txt --gpgkey 856AA88A

echo "check cf files in/var/lib/spamassassin/3.004001/"

## more rules /channel availble on http://daryl.dostech.ca/sa-update/sare/
#echo "72_sare_redirect_post3.0.0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_evilnum0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_bayes_poison_nxm.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_html0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_html_eng.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_header0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_header_eng.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_specific.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "72_sare_bml_post25x.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "99_sare_fraud_post25x.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_spoof.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_random.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_oem.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_genlsubj0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_genlsubj_eng.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_unsub.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_uri0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_obfu0.cf.sare.sa-update.dostech.net" >> /etc/spamassassin/sare-sa-update-channels.txt
#echo "70_sare_stocks.cf.sare.sa-update.dostech.net >> /etc/spamassassin/sare-sa-update-channels.txt
#

/bin/rm -rf /etc/spamassassin/bogus-virus-warnings.cf
wget -c http://www.timj.co.uk/uploads/bogus-virus-warnings.cf -O /etc/spamassassin/bogus-virus-warnings.cf


#/bin/rm -rf /etc/spamassassin/french_rules.cf
#wget -c http://maxime.ritter.eu.org/Spam/french_rules.cf -O /etc/spamassassin/french_rules.cf
## mirror url
#wget -c http://airmex.nerim.net/rule-get/french_rules.cf -O /etc/spamassassin/french_rules.cf



#/bin/rm -rf /etc/spamassassin/hebrewspamhtml.cf
#wget -c http://www.deltaforce.net/hebrewspam/hebrewspamhtml.cf -O /etc/spamassassin/hebrewspamhtml.cf

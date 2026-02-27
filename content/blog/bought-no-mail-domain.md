+++
title = "Bought a domain (but not for mails). What now?"
date = "2026-02-27"
description = "If you bought a domain but don't want to use it for mail (yet), I recommend you to set two values to your domain to not let it be inside a blacklist."
+++

# TL;DR

Set the following two entries for your domain:

| Host     | Type  | Content               |
|:--------:|:-----:|:---------------------:|
| `@`      | `TXT` | `v=spf1 -all`         |
| `_dmarc` | `TXT` | `v=DMARC1; p=reject;` |

And your domain can't be misused for spam or bad mails anymore.

# Explanation

## SPF

### What is SPF for?

[SPF] allows you to set some rules for emails, with your domain in the `From:` field of an email, are
allowed to come from.

This prevents cases where a random person just [yoinks] your domain and put it in the `From:` field of their mail
and abusive it for spam mails for example.

### Content description

`v=spf1 -all` means:
- `v=spf1`: We are using the 1st version of [SPF]
- `-all`: This domain doesn't send any mail at all.".

So if others are getting mails from your domain, they can see that this can't be possible, since you're saying here
that no mails can be send from your domain, hence the receiver can happily discard it for example.

For a more detailed explaination, click [here](http://www.open-spf.org/SPF_Record_Syntax/).

## DMARC

### What is DMARC for?

With [DMARC] you can tell others which **p**olicy (that's what the `p=` means) should be used if any checks failed.

The checks are usually from [SPF] and [DKIM] (which allows you to sign your mails) but if you don't want to use
your domain to send mails anyhow, then [SPF] should be enough.

### Content description

`v=DMARC1; p=reject;` means here:

- `v=DMARC1`: Use the first version of DMARC
- `p=reject;`: Just reject the mail and do nothing.

If you want to read more about [DMARC], I think [this](https://mxtoolbox.com/dmarc/details/) is a good page.

[SPF]: https://en.wikipedia.org/wiki/Sender_Policy_Framework
[DMARC]: https://dmarc.org/
[yoinks]: https://dictionary.cambridge.org/dictionary/english/yoink
[DKIM]: https://de.wikipedia.org/wiki/DomainKeys_Identified_Mail
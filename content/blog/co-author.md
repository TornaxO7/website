+++
title = "Get the ID of a Github-User"
date = "2026-01-07"
description = "Simple command to copy+paste to get the id of a github user to create their no-reply e-mail adress."
+++

So basically if you wanted to add someone as a [co-author], you'd need to create your commit-message as follows (I recommend to stick to the [commit conventions]):

```COMMIT_EDITMSG
<commit message>

Co-authored-by: NAME <email> # NOTE: (`NAME` is not the username!)
```

but if you _don't_ know the email address of a user and the user account was created **after** July 18, 2017 then you can use their [no-reply mail] which has the following format:

```
ID+USERNAME@users.noreply.github.com
```

Neat, but how do we get `ID`? With an API-call! To be more specifique: [api.github.com]
With the power of [curl] and [jq] that's just a oneliner:

```bash
curl https://api.github.com/users/<username> | jq ".id"
```

In my case it would be `curl https://api.github.com/users/TornaxO7 | jq ".id"` which returns `50843046`.

So now in total it would look like this in the end:

```COMMIT_EDITMSG
Co-authored-by: TornaxO7 <50843046+TornaxO7@users.noreply.github.com>
```

That's it. Cheers!

[co-author]: https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors
[no-reply mail]: https://docs.github.com/en/account-and-profile/reference/email-addresses-reference?versionId=free-pro-team%40latest&productId=account-and-profile&restPage=concepts%2Cemail-addresses#your-noreply-email-address
[api.github.com]: https://api.github.com/
[curl]: https://github.com/curl/curl
[jq]: https://github.com/jqlang/jq
[commit conventions]: https://www.conventionalcommits.org/en/v1.0.0/

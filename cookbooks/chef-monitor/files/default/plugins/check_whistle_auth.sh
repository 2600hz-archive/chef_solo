#!/bin/bash

#           .       .
#           \`-"'"-'/
#            } 6 6 {
#           =.  Y  ,=
#             /^^^\  .
#            /     \  )
#           (  )-(  )/
#            ""   ""
# .  . .-. . .   .-. .-. .-. .-. . . .-.
#  )(  |-| | |   .'' |-. |\| |\| |-|  /
# '  ` ` ' `.'   `-- `-' `-' `-' ' ` `-'
# thx to Darren and Karl for the fancy regex



fUsage () {
    echo "Usage: [--url=remote.system.com] [--realm=yourealm.sip.2600hz.com] [--user=your.username] [--pass=your.password] [--shared=http://yourlocalsystem.com:8000/v1/shared_auth]"
    echo "Options"
    echo "--url: the url of the remote system to authenticate against"
    echo "--realm: the realm of the user's account"
    echo "--user: the username you use to login"
    echo "--pass: the password you use to login"
    echo "--shared: optional, only if you use shared authentication against your local system"
    echo "Example:"
    echo "--url=apps.2600hz.com --realm=xavier.sip.2600hz.com --user=xavier --pass=xavier --shared=http://apps001-aa-ord.2600hz.com:8000/v1/shared_auth"
    exit 1
}

fAuthToken () {
if [ "$status" = "success" ]
then
  echo "Authentication is working on $url"
  exit 0
else
  echo "Authentication is broken on $url"
  exit 2
fi
}

fSharedToken () {
if [ "$status" = "success" ]
then
  auth_token=`echo "$response" | sed -rn 's/.*"auth_token":"(\w*)".*/\1/p'`
  account_id=`echo "$response" | sed -rn 's/.*"account_id":"(\w*)".*/\1/p'`
  owner_id=`echo "$response" | sed -rn 's/.*"owner_id":"(\w*)".*/\1/p'`

  shared_token="`curl -s -i -H "Content-Type: application/json" -X PUT -d '{"data":{"realm":"'$realm'","account_id":"'$account_id'","shared_token":"'$auth_token'"},"verb":"PUT"}' $shared`"

  status_shared=`echo "$shared_token" | sed -rn 's/.*"status":"(\w*)".*/\1/p'`

  if [ "$status_shared" = "success" ]
  then
    echo "Shared Auth is working on $shared"
    exit 0
  else
    echo "Shared Auth is broken on $shared"
    exit 2
  fi

else
  echo "Authentication is broken on $url"
  exit 2
fi
}



while [ -n "$*" ]; do
    case "x$1" in
        x--url=*)
            url=`echo "$1"|cut -d= -sf2`
            ;;
        x--realm=*)
            realm=`echo "$1"|cut -d= -sf2`
            ;;
        x--user=*)
            user=`echo "$1"|cut -d= -sf2`
            ;;
        x--pass=*)
            pass=`echo "$1"|cut -d= -sf2`
            ;;
        x--shared=*)
            shared=`echo "$1"|cut -d= -sf2`
            ;;
        x--help)
            fUsage
            ;;
        *)
            fUsage
            ;;
    esac
    shift
done

cred="`echo -n "$user:$pass" | md5sum | cut -f1 -d' '`"

response="`curl -s -i -H "Content-Type: application/json" -X PUT -d '{"data":{"credentials":"'$cred'","realm":"'$realm'"},"verb":"PUT"}' http://$url:8000/v1/user_auth`"

status=`echo "$response" | sed -rn 's/.*"status":"(\w*)".*/\1/p'`


if [ -z "$shared" ]; then
  fAuthToken
else
  fSharedToken
fi

exit 1
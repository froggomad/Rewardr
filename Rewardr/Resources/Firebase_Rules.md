#  Firebase Security Rules

## /children:
anyone can write

### /children/uid:
* logged in child can read
```
"children": {
  ".write": true,
    "$user_id": {
      ".read": "$user_id === auth.uid"
    }
}
```

## /parent/uid
* logged in parent can read/write

```
"parent": {
"$user_id": {
  ".read": "$user_id === auth.uid",
  ".write": "$user_id === auth.uid",
```

### /parent/uid/children/uid
* logged in child can read their own chores/rewards/details

```
"children": {
"$user_id": {
  ".read": "$user_id === auth.uid",
  ".write": true,          
  }
}
```

In total:
```
{
  "rules": {
    "children": {
      ".write": true,
        "$user_id": {
          ".read": "$user_id === auth.uid"
        }
    },
    "parent": {
      "$user_id": {
        ".read": "$user_id === auth.uid",
        ".write": "$user_id === auth.uid",
      "children": {
        "$user_id": {
          ".read": "$user_id === auth.uid",
          ".write": true,          
          }
        }
          }
    }
    }
}
```

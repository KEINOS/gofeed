#!/bin/sh

which gofeed-cli > /dev/null
if [ $? -ne 0 ]; then
  echo 'gofeed-cli not installed or placed in the env paths.'
  exit 1
fi

echo '======================'
echo ' Test for ParseString'
echo '======================'

# Sample of input string for ParseString command
str_feed=$(cat <<'FEED'
<rss version="2.0">
<channel>
<managingEditor>Name of Managing Editor Here</managingEditor>
<itunes:author>Author Name of iTunes Here</itunes:author>
</channel>
</rss>
FEED
)

expect=$(cat <<'EXPECT'
{
    "author": {
        "name": "Name of Managing Editor Here"
    },
    "itunesExt": {
        "author": "Author Name of iTunes Here"
    },
    "extensions": {
        "itunes": {
            "author": [
                {
                    "name": "author",
                    "value": "Author Name of iTunes Here",
                    "attrs": {},
                    "children": {}
                }
            ]
        }
    },
    "items": [],
    "feedType": "rss",
    "feedVersion": "2.0"
}
EXPECT
)

result=$(gofeed-cli string "${str_feed}")

result_md5=$(echo "$result" | md5sum)
expect_md5=$(echo "$expect" | md5sum)

echo "- Expect Hash: ${expect_md5}"
echo "- Result Hash: ${result_md5}"

printf '- Comparing results ... '

if [[ "$result_md5" != "$expect_md5" ]]; then
  echo 'NG'
  exit 1
fi
echo 'OK'

echo '==================='
echo ' Test for ParseURL'
echo '==================='

url_sample='https://qiita.com/KEINOS/feed.atom'
echo "- Fetching sample feed from: ${url_sample}"
printf '- Parsing and comparing results ... '

# Set -f to NOT extract the "*" in the returned string while $()
set -f
result=$(gofeed-cli url "${url_sample}" 2>&1)
if [ $? -ne 0 ]; then
  echo 'NG'
  echo $result
  exit 1
fi

echo "${result}" | grep KEINOSの記事 > /dev/null
if [ $? -ne 0 ]; then
   echo 'NG'
   echo '* Unexpected result. The result was:'
   echo $result
   exit 1
fi
echo 'OK (Includes a string expected from the feed)'

exit 0

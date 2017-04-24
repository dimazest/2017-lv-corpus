-- Collection size
select collection, count(*)
from tweet
where created_at >= '2016-11-01' and created_at < '2017-04-01'
group by collection
order by count(*) desc;

-- Client statistics
with tweets as (
select * from tweet
where collection = 'lv-rehydrated' and created_at >= '2016-11-01' and created_at < '2017-04-01'
)
select
features#>>'{filter,source}' source,
count(*) c,
round(count(*)::numeric  / (select count(*) from tweets), 3) * 100  as share
from tweets
group by source
order by c desc
limit 10;

-- Final collection
with tweets as (
select *  from tweet
where collection = 'lv-rehydrated' and created_at >= '2016-11-01' and created_at < '2017-04-01'
)
insert into
tweet(tweet_id, collection, text, features, created_at) (
select tweet_id, 'lv-final' as collection, tweets.text, features::jsonb, created_at
from tweets
where
    features#>>'{filter,source}' <> '<a href="http://foursquare.com" rel="nofollow">Foursquare</a>'
and features#>>'{filter,source}' <> '<a href="http://instagram.com" rel="nofollow">Instagram</a>'
and features#>>'{filter,source}' <> '<a href="http://www.endomondo.com" rel="nofollow">Endomondo</a>'
and features#>>'{filter,source}' <> '<a href="http://twitter.com/WorldCities/cities" rel="nofollow">World Cities</a>'
and features#>>'{filter,source}' <> '<a href="http://linkis.com" rel="nofollow">Linkis: turn sharing into growth</a>'
and (
   features#>>'{languages,0}' = 'lv'
or features#>>'{languages,0}' = 'ru'
or features#>>'{languages,0}' = 'en'
)
and created_at > '2016-10-31'
);

-- Mid November
with tweets as (
select *  from tweet
where collection = 'lv-final' and created_at >= '2016-11-11' and created_at < '2016-11-19'
)
insert into
tweet(tweet_id, collection, text, features, created_at) (
select tweet_id, 'lv-mid-nov' as collection, tweets.text, features::jsonb, created_at
from tweets
);

-- Early January
with tweets as (
select *  from tweet
where collection = 'lv-final' and created_at >= '2017-01-03' and created_at < '2017-01-10'
)
insert into
tweet(tweet_id, collection, text, features, created_at) (
select tweet_id, 'lv-early-jan' as collection, tweets.text, features::jsonb, created_at
from tweets
);

-- Late January
with tweets as (
select *  from tweet
where collection = 'lv-final' and created_at >= '2017-01-22' and created_at < '2017-01-24'
)
insert into
tweet(tweet_id, collection, text, features, created_at) (
select tweet_id, 'lv-late-jan' as collection, tweets.text, features::jsonb, created_at
from tweets
);



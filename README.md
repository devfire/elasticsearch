# A collection of scripts to manage large ElasticSearch clusters.
## Gather and Publish Stats
Use this [script](publishCloudWatchMetrics.bash) to gather and publish ElasticSearch cluster statistics to Amazon CloudWatch.
## Remove Old Indices
Use this [script](removeOldElasticSearchIndices.bash) to remove indices older than N number of days. The date computation is done automatically, provided the index pattern follows a standard *index-YYYY.MM.DD* format.

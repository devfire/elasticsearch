#!/usr/bin/bash

nameSpace=ElasticSearch
ClusterURL=elasticsearch-nonprod
esURL=http://elasticsearch-nonprod

#force a pretty json output and remove non numeric values
healthStatus=$(curl -s $esURL/_cluster/health | jq . | grep -v -E '(cluster_name|status|timed_out)')

#get the keys first, then go through every key and publish numeric values only
echo $healthStatus | jq -r 'keys[]' | while read key; do
	value=$(echo $healthStatus | jq -r ".$key")
	aws cloudwatch put-metric-data --metric-name "$key" --namespace "$nameSpace" --value $value --dimensions ClusterURL="$ClusterURL"
done

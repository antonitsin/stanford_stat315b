
#getting the data

library(ggplot2)
library(ebaytd)
library(plyr)
c <- teradataConnect()
s <- "
Select user_gr, succ_evnt_type, count(distinct guid) vstrs
  from  p_alexey_t.ch_lp_groups_bbowa
  group by 1,2
"

df <- dbGetQuery(c,s)

#checking data types
str(df)
names(df)<-make.names(names(df), unique = FALSE, allow_ = TRUE)
names(df) <- tolower(names(df))
df$user_gr<-as.factor(df$user_gr)
df$succ_evnt_type<-as.factor(df$succ_evnt_type)



#pivoting the data
table<-ddply(df,c("succ_evnt_type", "user_gr"), summarize, sum_visitors=sum(vstrs, na.rm=TRUE))
table
library(reshape)
pivot <- cast(table, succ_evnt_type~user_gr, sum)
pivot
str(pivot)

#plotting data
plot<-ggplot(table, aes(x=succ_evnt_type, y=sum_visitors)) +
        geom_density(alpha=.3)
plot


qplot(succ_evnt_type, data=table, geom="bar", binwidth = 0.1,
      weight=sum_visitors, ylim = c(0,1000), facets = . ~ user_gr)

#playing with source
d <- teradataConnect()
f <- "
select pagetype, session_traffic_source_id, count(unique guid) from p_alexey_t.ch_lp_large
where pagetype in ('coll', 'Haitao')
group by 1,2
"

df_2 <- dbGetQuery(d,f)
str(df_2)
df_2$pagetype<-as.factor(df_2$pagetype)
df_2$session_traffic_source_id<-as.factor(df_2$session_traffic_source_id)
df_2


qplot(session_traffic_source_id, data=df_2, geom="bar", binwidth = 0.1,
weight=guid,  facets = . ~ pagetype)


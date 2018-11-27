library(ggplot2)
library(maps)
library(tidyverse)
mail_value <- c(1, 2, 3, 1, 3, 4, 1, 1,
                2, 2, 3, 2, 2, 1, 2, 2,
                1, 1, 2, 2, 1, 1, 3, 1,
                1, 3, 2, 3, 1, 3, 2, 1,
                2, 2, 2, 2, 4, 1, 1, 1,
                2, 1, 1, 3, 2, 1, 4, 1,
                2, 2)

mail_dt <- data.frame(tolower(as.character(state.name)), as.factor(mail_value))
names(mail_dt) <- c("region", "value")

mail_dt <- mail_dt %>%
  mutate(value = fct_recode(value,
    "  Excuse Absentee  " = "1",
    "  Temporary No-Excuse Abs.  " = "2",
    "  Permanent No-Excuse Abs.  " = "3",
    "  All-Mail Elections  " = "4"
  ))

us <- map_data("state")

ggplot() +
  geom_map(data=us, map=us, aes(long, lat, map_id=region)) +
  geom_map(data=mail_dt, map=us, aes(fill=value, map_id=region), color="black", size=0.15) +
  scale_fill_brewer(palette = "Blues") +
  labs(x=NULL, y=NULL) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  theme(panel.border = element_blank()) +
  theme(panel.background = element_blank()) +
  theme(axis.ticks = element_blank()) +
  theme(axis.text = element_blank()) +
  theme(legend.position="bottom") +
  theme(legend.title=element_blank()) +
  theme(legend.text=element_text(size=6.5)) +
  ggsave("us_vbm_status.png", width = 5.00, height = 4.20)


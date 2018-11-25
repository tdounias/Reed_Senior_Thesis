theories <- c("Decision at the margins", "Habitual Voting",
              "Social/Structural Voting", "Resources and Organizations")

H1 <- c("Y", "--", "Y", "N")

H2 <- c("Y", "N", "N", "N")

vbm <- c("Marginal", "No Effect/Decrease", "No Effect", "Increase")

hyp_effect <- data.frame(theories, H1, H2, vbm)

names(hyp_effect) <- c("", "H1", "H2", "Effect on Turnout")

pandoc.table(hyp_effect, caption = "Predicted Outcomes from Hypotheses")

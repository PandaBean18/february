Reaction.destroy_all
Post.destroy_all
User.destroy_all

users = [
    User.create!(email: "raghavb@gmail.com", username: "rndbn"),
    User.create!(email: "intern_chaos@flop.in", username: "git_force_pusher"),
    User.create!(email: "hustle_god@flop.in", username: "linkedin_disaster"),
    User.create!(email: "burnout_dev@flop.in", username: "coffee_to_code_error"),
    User.create!(email: "pm_panic@flop.in", username: "agile_escape_artist"),
    User.create!(email: "sysadmin_tears@flop.in", username: "rm_rf_survivor")
]

stories_pool = [
    { category: "Production Meltdown", story: "Dropped the main production database on day 3 of my internship. Currently packing my bag." },
    { category: "imposter syndrome", story: "Completed a 6-stage interview panel including a take-home architecture project, just to receive an automated rejection letter addressed to 'Dear Candidate'." },
    { category: "General mess", story: "Meant to forward a spicy meme about the new corporate policy to a coworker. Accidentally hit 'Reply All' to the global department thread. 450 people saw it." },
    { category: "Git Tangle", story: "Resolved a messy merge conflict by force-pushing directly to master. Wiped out two weeks of the senior developer's backend optimization logic." },
    { category: "General mess", story: "Sent the final high-volume print batch order for the company's new merchandise assets. The banners explicitly say 'Shitf Down' instead of 'Shift Down'." },
    { category: "imposter syndrome", story: "During a live coding round, my brain flatlined so aggressively that I forgot how to instantiate a basic array in front of three principal engineers." },
    { category: "meeting mishap", story: "Thought my mic was completely muted during an intense town hall event. Let out a massive sigh and said 'this could have been a slack message' right as the CEO was speaking." },
    { category: "Production Meltdown", story: "Left an oversized AWS EC2 compute instance cluster churning over the entire long weekend while running a recursive test script. Woke up to a $14,000 billing alert." },
    { category: "Production Meltdown", story: "Tripped over a loose power cable in the server closet while looking for an extra monitor. Accidentally hard-rebooted the primary office router mid-deployment." },
    { category: "meeting mishap", story: "Accidentally invited the client directly to an internal brainstorming calendar block titled 'Fixing the absolute mess they handed us'." },
    { category: "Production Meltdown", story: "Copied a complex security regex script directly from an AI model without reviewing the logic. Blocked legitimate authentication queries for all global users for 4 hours." },
    { category: "meeting mishap", story: "Accepted two overlapping high-priority client sprint updates. Tried to alternate tabs on separate devices, but ended up unmuting and talking about Project A to the client for Project B." },
    { category: "imposter syndrome", story: "Put 'Expert Level Ruby on Rails proficiency' on my application profile. The interviewer immediately asked me to explain the internal architectural differences between include and join queries." },
    { category: "Production Meltdown", story: "Wrote a recursive sync script that accidentally triggered a critical third-party API call loop. Burned through our entire monthly operational usage quota in exactly 23 minutes." },
    { category: "meeting mishap", story: "Forgot I was actively sharing my primary display during a team design sync. Opened a new tab to quickly search 'how to update resume undetected' while everyone watched." },
    { category: "Git Tangle", story: "Accidentally committed a raw, unencrypted `.env` text file containing our master database credentials directly into a public GitHub repository." },
    { category: "imposter syndrome", story: "Woke up 40 minutes late for a final round executive interview because my phone decided to install an automated operating system update overnight." },
    { category: "client chaos", story: "Sent a message criticizing the project manager's timeline constraints directly to the project manager instead of my work group chat." },
    { category: "burnout", story: "Merged an untested styling layout change right before leaving for the weekend. Broke the primary payment portal checkout button for mobile viewports." },
    { category: "General mess", story: "Exported the low-res placeholder image for the app's app store landing banner instead of the finalized graphic asset. It stayed live for 2 days." }
]

posts = []

stories_pool.each do |story_data|
    posts << Post.create!(
        user: users.sample,
        category: story_data[:category],
        story: story_data[:story]
    )
end

reaction_types = [ "fail", "dead", "relatable", "cheers" ]

posts.each do |post|
    reacting_users = users.sample(rand(2..users.size))

    reacting_users.each do |user|
        next if post.user_id == user.id

        Reaction.create!(
            post: post,
            user: user,
            reaction_type: reaction_types.sample
        )
    end
end
